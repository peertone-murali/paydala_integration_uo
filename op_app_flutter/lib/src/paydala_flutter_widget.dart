import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:op_app_flutter/src/channel_event.dart';
import 'package:op_app_flutter/src/signedcreds.dart';
import 'package:op_app_flutter/src/txn_response.dart';
import 'package:op_app_flutter/src/utils.dart';

class PaydalaFlutterWidget extends StatefulWidget {
  final String title;
  final String url;
  late String requestId;
  late SignedCreds signedCreds;
  TransactionResponse? txnResponse;

  PaydalaFlutterWidget(
      {required this.title, required this.url, required this.signedCreds}) {
    txnResponse = createTxnResponse(signedCreds.creds);
    try {
      var credsMap = jsonDecode(signedCreds.creds);
      requestId = credsMap['payload']["requestId"];
    } catch (e) {
      if (kDebugMode) {
        print("Error decoding JSON: $e");
      }
    }
  }

  @override
  // ignore: library_private_types_in_public_api
  _PaydalaFlutterWidgetState createState() => _PaydalaFlutterWidgetState();
}

class _PaydalaFlutterWidgetState extends State<PaydalaFlutterWidget> {
  final Completer<WebViewController> controller =
      Completer<WebViewController>();

  late Location location = Location();
  late Future locationData;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
    locationData = _getLocationData();
    location.onLocationChanged.listen((l) {
      //locationData = _getLocationData();
      // _controller.animateCamera(
      //   CameraUpdate.newCameraPosition(
      //     CameraPosition(target: LatLng(l.latitude!, l.longitude!), zoom: 15),
      //   ),
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: Text(widget.title),
      ),*/

      // We're using a Builder here so we have a context that is below the Scaffold
      // to allow calling Scaffold.of(context) so we can show a snackbar.
      body: Builder(builder: (BuildContext context) {
        return WebView(
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) async {
            await webViewController.loadUrl(
              widget.url, //Uri.encodeFull(widget.url),
              headers: {
                "credentials": widget.signedCreds
                    .creds, //.encodeComponent(widget.signedCreds.creds),
                "x-client-sign": widget.signedCreds
                    .signature, //.encodeComponent(widget.signedCreds.signature),
                "operatorRequestId":
                    widget.requestId, // Uri.encodeComponent(widget.requestId)
              },
            );
          },
          onProgress: (int progress) {
            print('WebView is loading (progress : $progress%)');
          },
          javascriptChannels: <JavascriptChannel>{
            _paydalaJavascriptChannel(context, widget),
          },
          navigationDelegate: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              print('blocking navigation to $request}');
              return NavigationDecision.prevent;
            }
            print('allowing navigation to $request');
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
          gestureNavigationEnabled: true,
          backgroundColor: const Color(0x00000000),
          geolocationEnabled: true, // set geolocationEnable true or not
        );
      }),
    );
  }

  JavascriptChannel _paydalaJavascriptChannel(
      BuildContext context, PaydalaFlutterWidget widget) {
    return JavascriptChannel(
        name: 'PayDala',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text("txnDetails ${message.message}")),
          // );
          if (kDebugMode) {
            print("txnDetails JSON = ${message.message}");
          }
          // showMessageDialog(context, "Deposit result", message.message);
          // Navigator.pop(context);
          var txnResponse = message.message;

          if (isJSON(txnResponse)) {
            try {
              final chEvent = ChannelEvent.fromJson(jsonDecode(txnResponse));
            } catch (e) {
              if (kDebugMode) {
                print("JSON parse error : $e");
              }
            }
            final Map<String, dynamic> data = json.decode(message.message);
            List<dynamic> txnDetails = [];

            try {
              txnDetails = data['txnDetails'];
            } catch (e) {
              if (kDebugMode) {
                print("Missing txtDetails: $e");
              }
            }
          }
          // Navigator.pushReplacementNamed(context, '/wallet');
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/wallet',
            (route) => false,
          ).then((value) => setState(() {}));
        });
  }
}

Future<LocationData?> _getLocationData() async {
  Location location = Location();
  LocationData locationData;

  bool serviceEnabled;
  PermissionStatus permissionGranted;

  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return null;
    }
  }

  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return null;
    }
  }

  locationData = await location.getLocation();

  return locationData;
}
