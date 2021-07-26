

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPayment extends StatelessWidget {
  String url;
  WebViewPayment(this.url);

  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pay'),
      ),
      body: Builder(builder: (BuildContext context){
        return WebView(
          initialUrl: url,
        );
      },),
    );
  }
}
