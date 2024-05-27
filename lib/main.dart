import 'package:flutter/material.dart';
import 'package:windows_webview/webview.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WebviewPage(),
    );
  }
}
