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

      String htmlString = await rootBundle.loadString('assets/screen_capture.html');
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
