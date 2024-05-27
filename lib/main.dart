import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:windows_webview/webview.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final WebviewScreenshot _webviewScreenshot = WebviewScreenshot();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('HTML to Screenshot Example'),
        ),
        body: Center(
          child: FutureBuilder<Uint8List?>(
            future: _getHtmlScreenshot(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                return Image.memory(snapshot.data!);
              } else {
                return Text('No screenshot available');
              }
            },
          ),
        ),
      ),
    );
  }

  Future<Uint8List?> _getHtmlScreenshot() async {
    await _webviewScreenshot.initialize();
    String htmlContent = '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dynamic Table Example</title>
    <style>
        /* Your CSS styles here */
    </style>
</head>
<body>
    <div id="foo">
        <div id="receipt-image">
            <h2 id="recieptTitle"></h2>
            <div id="subdivision"></div>
            <div class="parent">
                <div class="child" id="idout"></div>
                <div class="child" id="tableName"></div>
            </div>
            <div id="note"></div>
            <table id="tableInfo" border="0">
                <tbody>
                    <tr>
                        <td id="printedDateTitle"></td>
                        <td id="printedDate"></td>
                    </tr>
                </tbody>
            </table>
            <br>
            <table id="paymentsTable" border="1">
                <thead>
                    <tr>
                        <th>#</th>
                        <th id="nameTableRow"></th>
                        <th id="priceTableRow"></th>
                    </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
        <br>
        <div id="version"></div>
        <div id="lastSync"></div>
        <script>
            // Your JavaScript code here
        </script>
        <script src="https://cdn.jsdelivr.net/npm/html2canvas@1.0.0-rc.5/dist/html2canvas.min.js" defer></script>
        <hr />
        <hr />
    </div>
</body>
</html>
    ''';
    return await _webviewScreenshot.getScreenshotFromHtml(htmlContent);
  }
}
