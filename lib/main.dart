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

      // Load the HTML content
      String htmlContent = await rootBundle.loadString('assets/screen_capture.html');
      _webview.launch(Uri.dataFromString(
        htmlContent,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8'),
      ).toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebView Screen Capture'),
      ),
      body: _isWebViewInitialized ? Container() : const Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_isWebViewInitialized) {
            _captureScreen();
          }
        },
        child: const Icon(Icons.camera),
      ),
    );
  }

  Future<void> _captureScreen() async {
    try {
      // JavaScript code to capture the screen
      final String jsCode = '''
        (async function() {
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
              window.screenshotHandler.postMessage(dataURL);

              video.srcObject.getTracks().forEach(track => track.stop());
            };
          } catch (err) {
            console.error('Error: ' + err);
          }
        })();
      ''';

      // Execute JavaScript code in the WebView
      await _webview.evaluateJavaScript(jsCode);
    } catch (e) {
      print('Error capturing screen: $e');
    }
  }
}
