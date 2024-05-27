import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:webview_win_floating/webview.dart';

class WebViewScreenshotWidget extends StatefulWidget {
  final String htmlContent;

  const WebViewScreenshotWidget({Key? key, required this.htmlContent}) : super(key: key);

  @override
  _WebViewScreenshotWidgetState createState() => _WebViewScreenshotWidgetState();
}

class _WebViewScreenshotWidgetState extends State<WebViewScreenshotWidget> {
  late final WinWebViewController _webviewController;
  Uint8List? _screenshot;

  @override
  void initState() {
    super.initState();
    _webviewController = WinWebViewController();
    _loadWebViewContent();
  }

  Future<void> _loadWebViewContent() async {
    await _webviewController.loadHtmlString(widget.htmlContent);
    await Future.delayed(Duration(seconds: 5)); // Ждем некоторое время для загрузки контента

    // Захват снимка экрана после загрузки HTML-кода
    final screenshot = await _captureHtmlScreenshot();
    setState(() {
      _screenshot = screenshot;
    });
  }

  Future<Uint8List?> _captureHtmlScreenshot() async {
    try {
      // Получение размеров страницы
      final pageWidth = await _webviewController.runJavaScriptReturningResult('document.documentElement.scrollWidth');
      final pageHeight = await _webviewController.runJavaScriptReturningResult('document.documentElement.scrollHeight');

      final screenshot = await _webviewController.runJavaScriptReturningResult('''
        // Получение размеров страницы
        var pageWidth = document.documentElement.scrollWidth;
        var pageHeight = document.documentElement.scrollHeight;

        // Создание canvas элемента с размерами страницы
        var canvas = document.createElement('canvas');
        canvas.width = pageWidth;
        canvas.height = pageHeight;
        var ctx = canvas.getContext('2d');

        // Заполнение canvas содержимым страницы
        ctx.drawImage(document.documentElement, 0, 0, pageWidth, pageHeight);

        // Преобразование изображения в base64 строку
        var base64image = canvas.toDataURL('image/png');

        // Отправка скриншота обратно в Flutter через JavaScript канал
        window.flutter_inappwebview.callHandler('screenshot', base64image);
      ''');
      Uint8List? imageBytes;

      _webviewController.addJavaScriptChannel('screenshot', callback: (base64image) {
        final message = base64image.message;

        // Преобразование base64 в Uint8List
        imageBytes = base64Decode(message.split(',').last);
      });
      return imageBytes;
    } catch (e) {
      print('Error capturing HTML screenshot: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebView Screenshot'),
      ),
      body: _screenshot != null
          ? Image.memory(_screenshot!) // Отображение скриншота, если он был захвачен
          : const Center(child: CircularProgressIndicator()), // Индикатор загрузки, пока скриншот не готов
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WebViewScreenshotWidget(
        htmlContent: '<html><body><h1>Hello, World!</h1></body></html>',
      ),
    );
  }
}
