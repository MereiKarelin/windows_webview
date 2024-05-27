import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:webview_windows/webview_windows.dart';

class WebviewScreenshot {
  final WebviewController _controller = WebviewController();
  final ScreenshotController _screenshotController = ScreenshotController();

  Future<void> initialize() async {
    await _controller.initialize();
    await _controller.setBackgroundColor(Colors.transparent);
    await _controller.setPopupWindowPolicy(WebviewPopupWindowPolicy.deny);
  }

  Future<void> loadHtmlContent(String htmlContent) async {
    await _controller.loadUrl(Uri.dataFromString(htmlContent, mimeType: 'text/html').toString());
  }

  Future<Uint8List?> captureScreenshot() async {
    return await _screenshotController.captureFromWidget(
      Container(
        width: 800,
        height: 600,
        child: Webview(_controller),
      ),
    );
  }

  WebviewController get controller => _controller;
  ScreenshotController get screenshotController => _screenshotController;
}

Future<Uint8List?> renderHtmlToImage(String htmlContent) async {
  final WebviewController controller = WebviewController();
  await controller.initialize();
  final completer = Completer<Uint8List?>();

  controller.webMessage.listen((message) {
    if (message.message.containsKey('screenshot')) {
      final base64image = message.message['screenshot'];
      final bytes = base64Decode(base64image.split(',').last);
      completer.complete(bytes);
    }
  });

  await controller.loadStringContent(
    '''
      <!DOCTYPE html>
      <html>
      <head>
        <title>Screenshot</title>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/0.4.1/html2canvas.min.js"></script>
        <script>
          function captureScreenshot() {
            html2canvas(document.body).then(canvas => {
              const base64image = canvas.toDataURL('image/png');
              window.chrome.webview.postMessage({screenshot: base64image});
            }).catch(err => {
              console.error('Error capturing screenshot:', err);
              window.chrome.webview.postMessage({error: err.toString()});
            });
          }

          document.addEventListener('DOMContentLoaded', (event) => {
            captureScreenshot();
          });
        </script>
      </head>
      <body>
        $htmlContent
      </body>
      </html>
    ''',
  );

  controller.webMessage.listen((message) {
    if (message.message.containsKey('error')) {
      completer.completeError(Exception(message.message['error']));
    }
  });

  return await completer.future;
}
