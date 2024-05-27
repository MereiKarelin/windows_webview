import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:webview_windows/webview_windows.dart';

class WebviewPage extends StatefulWidget {
  @override
  _WebviewPageState createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  final WebviewController _controller = WebviewController();
  final ScreenshotController _screenshotController = ScreenshotController();

  Uint8List? _screenshotBytes;

  @override
  void initState() {
    super.initState();
    _initializeWebview();
  }

  Future<void> _initializeWebview() async {
    await _controller.initialize();
    await _controller.setBackgroundColor(Colors.transparent);
    await _controller.setPopupWindowPolicy(WebviewPopupWindowPolicy.deny);
    _controller.url.listen((url) {
      print('Webview is loading: $url');
    });
    await _controller.loadUrl('https://flutter.dev');
    setState(() {});
  }

  Future<void> _takeScreenshot() async {
    final screenshotBytes = await _screenshotController.capture();
    setState(() {
      _screenshotBytes = screenshotBytes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebView Screenshot Example'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Screenshot(
              controller: _screenshotController,
              child: _controller.value.isInitialized ? Webview(_controller) : Center(child: CircularProgressIndicator()),
            ),
          ),
          if (_screenshotBytes != null)
            Expanded(
              child: Image.memory(_screenshotBytes!),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takeScreenshot,
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}
