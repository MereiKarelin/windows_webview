import 'package:flutter/material.dart';
import 'package:webview_windows/webview_windows.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WebviewController.initializeEnvironment();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final WebviewController _controller = WebviewController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('WebView Example')),
        body: FutureBuilder<void>(
          future: _controller.initialize(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Webview(
                _controller,
                width: 800,
                height: 600,
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _controller.loadUrl('https://flutter.dev');
          },
          child: Icon(Icons.web),
        ),
      ),
    );
  }
}

class WebviewPage extends StatelessWidget {
  final WebviewController controller = WebviewController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('WebView Page')),
      body: FutureBuilder<void>(
        future: controller.initialize(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Webview(
              controller,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
