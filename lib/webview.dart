import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:webview_win_floating/webview.dart';

Future<Uint8List?> captureHtmlScreenshot(String htmlContent) async {
  final webviewController = WinWebViewController();
  final completer = Completer<Uint8List?>();

  try {
    await webviewController.loadHtmlString(htmlContent);

    // Ожидание завершения загрузки и рендеринга HTML-кода
    await Future.delayed(const Duration(seconds: 5));

    // Захват скриншота
    final screenshot = await webviewController.runJavaScriptReturningResult('''
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

    webviewController.addJavaScriptChannel('screenshot', callback: (base64image) {
      final message = base64image.message;

// Преобразование base64 в Uint8List
      Uint8List imageBytes = base64Decode(message.split(',').last);
      completer.complete(imageBytes);
    });
  } catch (e) {
    print('Error capturing HTML screenshot: $e');
    completer.completeError(e);
  }

  return await completer.future;
}
