import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:universal_io/io.dart';
import 'package:webview_universal/webview_desktop/webview_desktop.dart' as webview_desktop;
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WebViewExample(),
    );
  }
}

class WebViewExample extends StatefulWidget {
  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  late webview_desktop.Webview _webview;
  bool _isWebViewInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  Future<void> _initializeWebView() async {
    bool isWebviewAvailable = await webview_desktop.WebviewWindow.isWebviewAvailable();
    if (isWebviewAvailable) {
      _webview = await webview_desktop.WebviewWindow.create(
        configuration: webview_desktop.CreateConfiguration(
          titleBarTopPadding: Platform.isMacOS ? 20 : 0,
        ),
      );
      setState(() {
        _isWebViewInitialized = true;
      });

      _webview.setBrightness(Brightness.dark);
      _webview.registerJavaScriptMessageHandler('screenshotHandler', (String name, dynamic body) {
        print('Screenshot received: $body');
      });

      String htmlString = '''<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Screen Capture</title>
</head>
<body>
    <h1>Screen Capture Example</h1>
    <button id="capture-btn" onclick="captureScreen()">Capture Screen</button>
    <script>
        async function captureScreen() {
            try {
                const stream = await navigator.mediaDevices.getDisplayMedia({ video: true });
                const video = document.createElement('video');
                video.srcObject = stream;
                video.play();

                video.onloadedmetadata = async () => {
                    const canvas = document.createElement('canvas');
                    canvas.width = video.videoWidth;
                    canvas.height = video.videoHeight;
                    const context = canvas.getContext('2d');
                    context.drawImage(video, 0, 0, canvas.width, canvas.height);

                    const dataURL = canvas.toDataURL('image/png');
                    window.flutter_inappwebview.callHandler('screenshotHandler', dataURL);

                    video.srcObject.getTracks().forEach(track => track.stop());
                };
            } catch (err) {
                console.error('Error: ' + err);
            }
        }
    </script>
</body>
</html>
''';
      _webview.launch(Uri.dataFromString(
        htmlString,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8'),
      ).toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebView Screen Capture'),
      ),
      body: _isWebViewInitialized ? Container() : Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_isWebViewInitialized) {
            _webview.evaluateJavaScript('captureScreen();');
          }
        },
        child: Icon(Icons.camera),
      ),
    );
  }
}
