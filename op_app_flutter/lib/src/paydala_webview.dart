import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

// Define the endpoint URL and the data to send in the request body
const String endpointUrl = 'http://localhost:8080/getSignedCreds';

class SignedCreds {
  final String creds;
  final String signature;

  SignedCreds(this.creds, this.signature);

  SignedCreds.fromJson(Map<String, dynamic> json)
      : creds = json['creds'],
        signature = json['signature'];

  Map<String, dynamic> toJson() => {
        'creds': creds,
        'signature': signature,
      };
}

getSignedCreds(String payload) {
// Make the POST request
  http.post(Uri.parse(endpointUrl), body: payload).then((response) {
    if (response.statusCode == 200) {
      // The API call was successful
      print(response.body);
    } else {
      // There was an error
      print('Error: ${response.reasonPhrase}');
    }
  }).catchError((error) {
    // There was an error in making the request
    print('Error: $error');
  });
}

class PaydalaWebView extends StatefulWidget {
  final String title;
  final String url;
  final String payload;

  PaydalaWebView(
      {required this.title, required this.url, required this.payload});
  // const PaydalaWebView({super.key});

  @override
  State<PaydalaWebView> createState() => _PaydalaWebViewState();
}

class _PaydalaWebViewState extends State<PaydalaWebView> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    // getSignedCreds(payload);
    controller = WebViewController()
      ..loadRequest(
        Uri.parse('https://flutter.dev'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
