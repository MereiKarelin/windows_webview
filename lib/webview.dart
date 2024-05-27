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

  Future<Uint8List?> getScreenshotFromHtml(String htmlContent) async {
    // Load the HTML content
    await _controller.loadUrl(Uri.dataFromString(htmlContent, mimeType: 'text/html').toString());
    await Future.delayed(Duration(seconds: 2)); // Wait for the content to load

    // Take a screenshot
    final screenshotBytes = await _screenshotController.captureFromWidget(
      Container(
        width: 800, // Set your desired width
        height: 600, // Set your desired height
        child: Webview(_controller),
      ),
    );
    return screenshotBytes;
  }
}
