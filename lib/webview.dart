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

Future<Uint8List?> captureHtmlScreenshot(String htmlContent) async {
  final webviewScreenshot = WebviewScreenshot();

  try {
    // Инициализация веб-вью
    await webviewScreenshot.initialize();

    // Загрузка HTML-кода в веб-вью
    await webviewScreenshot.loadHtmlContent(htmlContent);

    // Ожидание завершения загрузки и рендеринга HTML-кода
    await Future.delayed(Duration(seconds: 5)); // Время для загрузки и рендеринга HTML-кода, можно настроить по необходимости

    // Захват скриншота
    final screenshot = await webviewScreenshot.captureScreenshot();

    return screenshot;
  } catch (e) {
    print('Error capturing HTML screenshot: $e');
    return null;
  }
}
