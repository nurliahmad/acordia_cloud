import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart' as webview;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Call Center App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Call Center App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _onWebResourceError(webview.WebResourceError e) {
    var html = """
                                            <html>
                            <head>
                            <title>Error Loading Page</title>
                            <style>
                                  body {p=
                                      background-repeat: no-repeat;
                                      background-size: 100% 100%;
                                  }
                                  .button {
                                    background-color: #ffffff;
                                    color: #673AB7;
                                    padding: 10px 20px;
                                    border: none;
                                    border-radius: 20px;
                                    cursor: pointer;
                                    font-size: 35px;
                                    height: 70px;
                                    width: 300px;
                                  }
                              </style>
                            </head>
                            
                            <body>
                              <center style="margin-top: 20em;">
                                <p style="font-size: 2em;">Terjadi kesalahan saat menghubungi Call Center</p>
                                <p style="font-size: 2em;">Silahkan coba kembali</p>
                                <a href="https://admin.accordiacloud.com/mobilewebrtc2.html?phone=0123456789">
                                  <button class="button button">Hubungkan Ulang</button>
                                </a>
                              </center>
                            </body>
                          </html>
                                        """;
    controllers.future.then((value) => value.loadHtmlString(html));

    print("WebResourceError: ${e.errorCode}");
  }

  webview.WebViewController? _controller;
  final controllers = Completer<webview.WebViewController>();

  late webview.WebViewController _webViewController;
  int loadingPercentage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Sample Call Center App',
                ),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          ),
          webview.WebView(
            initialUrl: '<add your link>',
            javascriptMode: webview.JavascriptMode.unrestricted,
            onWebViewCreated: (webview.WebViewController c) {
              // this.controllers = c as Completer<WebView.WebViewController>;
              c.clearCache();
              controllers.complete(c);
              _controller = c;
              _webViewController = c;
            },
            onPageStarted: (url) {
              setState(() {
                loadingPercentage = 0;
              });
            },
            onProgress: (progress) {
              if (mounted) {
                setState(() {
                  loadingPercentage = progress;
                });
              }
            },
            onPageFinished: (url) {
              setState(() {
                loadingPercentage = 100;
              });
            },
            onWebResourceError: _onWebResourceError,
          ),
          loadingPercentage < 100
              ? Container(
                  color: Colors.grey,
                  child: const Center(
                      child: CircularProgressIndicator(
                    color: Color(0xFF673AB7),
                  )),
                )
              : const SizedBox()
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Call Center',
      //   child: const Icon(Icons.call),
      // ),
    );
  }
}
