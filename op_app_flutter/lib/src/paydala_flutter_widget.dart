import 'dart:async';
import 'dart:convert';
// import 'dart:convert';
import 'dart:io';
// import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
// import 'package:op_app_flutter/main.dart';
import 'package:op_app_flutter/src/signedcreds.dart';

class PaydalaFlutterWidget extends StatefulWidget {
  final String title;
  final String url;
  final String payload;
  late String requestId;
  late SignedCreds signedCreds;

  PaydalaFlutterWidget(
      {required this.title, required this.url, required this.payload}) {
    signedCreds = getSignedCreds(payload);
    if (kDebugMode) {
      print(
          "payload : ${signedCreds.creds}, signature : ${signedCreds.signature}");
    }
    try {
      var credsMap = jsonDecode(signedCreds.creds);
      requestId = credsMap['payload']["requestId"];
    } catch (e) {
      if (kDebugMode) {
        print("Error decoding JSON: $e");
      }
    }
    // var credsMap = jsonDecode(signedCreds.creds);
    // requestId = credsMap['payload']["requestId"];
    ;
  }
  // const PaydalaFlutterWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PaydalaFlutterWidgetState createState() => _PaydalaFlutterWidgetState();
}

class _PaydalaFlutterWidgetState extends State<PaydalaFlutterWidget> {
  final Completer<WebViewController> controller =
      Completer<WebViewController>();
  var cjwt =
      'eyJhbGciOiJSUzI1NiJ9.eyJzdWIiOiJDSldUIFRlc3QiLCJpYXQiOjE2NzUxNjg1NzUsImlzcyI6IlBheWRhbGEgRGV2IiwicGF5bG9hZCI6eyJjYXRlZ29yeV9pZCI6IjEiLCJ0aW1lX3N0YW1wIjoiMTY3NTE2ODU3NTYzNyIsImNsaWVudF9pZCI6IjZmNWRmMDRlNDg0NjQwZTk4ZTIzMTAyNjhiNWRiYmQ0In19.t53IidJsaqh6ELktpZoeZ4FS_70ogFn5Zlk_lO1jRUF-KU1h5ycKF64RJBNdb-V6iCkdTciqi_rSCtLJzyVfYqCg17oG59u3fn22uLssY-BXMPuEG5KI5Va-ESRgYJnBFcny4AKGe3VASZE-JxyTnK56wZzDpLfX8AYq7bFVS3VpChL3agHAWKD45w5NZMZhdlvGn9cFFJGK54-qWEO2dcb47Xsz-8V016oQhRsNRrkIWSXIdT15OnIFgdMw73CbstYQE3FIPFNtT6pVDtpvf-qpkVvAPK-vjG0vz34FM9IrJzhpK5KV37qm6mhMrGuIzhwoh0T1hz2RnKRuA7AIbPAbkN9w1gCSv841Z_eyql4HHpmVQAeGR6aNhXiKRY99wZZihwbxmPaCscqtfzucFqINQSvrzirdthxkb5mqAKwRQR6x3Cw8ozLMLGupoQgmPcZYMUKN-pnhiIdGBw09hlxUW0CtmOZeO9c4b3UkTFuQAPCJ4G8mCZ9MhtcCkKo_zeMAWTaXekHUDR99EwZWoy5i1lQgaNR_pPjRvmzHF_Yo5uquBxLZMETIuAphEgdDeL7D-0IFNcBjM8o48iJHT2h0bIYJSDHWlvNjQ62VhC-ameXBvm38RFiXg0MOUlvJG3gPaZwLrFgENLHQQGXxSF7uVVEqC4VQNXPakPbqPmo';

  // late final WebViewController controller;

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
    // controller
    //   ..loadRequest(
    //     Uri.parse('https://flutter.dev'),
    //   );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),

      // appBar: AppBar(
      //   title: const Text('Flutter WebView example'),
      //   // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
      //   actions: <Widget>[
      //     NavigationControls(_controller.future),
      //     SampleMenu(_controller.future),
      //   ],
      // ),
      // We're using a Builder here so we have a context that is below the Scaffold
      // to allow calling Scaffold.of(context) so we can show a snackbar.
      body: Builder(builder: (BuildContext context) {
        return WebView(
          // initialUrl: widget.url, //'https://ultodds.com/',
          // withHeaders: {"authorization": cjwt},
          javascriptMode: JavascriptMode.unrestricted,
          // onWebViewCreated: (WebViewController webViewController) {
          //   controller.complete(webViewController);
          // },
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
            _paydalaJavascriptChannel(context),
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
      //floatingActionButton: favoriteButton(),
    );
  }

  bool isJSON(String str) {
    try {
      jsonDecode(str);
      return true;
    } catch (_) {
      return false;
    }
  }

  var txnRespJsonStr = '''
{
    "result": "partial", // or "success" or "failed"
    "refType": 2, // for requestId
    "txnRef": "3b524d4-c254-11ed-afa1-0242ac120002", // requestId
    "timeStamp": "2020-01-01T00:00:00Z",
    "txnDetails": [
      {
        "txnRef": "1234567890",
        "status": "failed",
        "currencyId": 1,
        "amount": 100.00,
        "timeStamp": "2020-01-01T00:00:00Z"
      },
      {
        "txnRef": "7264839283",
        "status": "success",
        "currencyId": 1,
        "amount": 50.00,
        "timeStamp": "2020-01-01T01:00:00Z"
      }
    ]
  }
  ''';

  JavascriptChannel _paydalaJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'PayDala',
        onMessageReceived: (JavascriptMessage message) {
          double totalAmout = 0.0;
          // print(message);
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
            final Map<String, dynamic> data = json.decode(message.message);
            List<dynamic> txnDetails = [];

            try {
              txnDetails = data['txnDetails'];
            } catch (e) {
              if (kDebugMode) {
                print("Missing txtDetails: $e");
              }
            }

            for (final txnDetail in txnDetails) {
              // Access and examine each property of the txnDetail object
              try {
                final String txnRef = txnDetail['txnRef'];
                final String status = txnDetail['status'];
                final int currencyId = txnDetail['currencyId'];
                final double amount = txnDetail['amount'];
                final String timeStamp = txnDetail['timeStamp'];
              } catch (e) {
                if (kDebugMode) {
                  print("Dictionary access error : $e");
                }
              }
              // print('$txnRef $status $currencyId $amount $timeStamp');
            }
          }

          // Navigator.pushReplacementNamed(context, '/wallet');
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/wallet',
            (route) => false,
          ).then((value) => setState(() {}));
          ;
          // setState(() {
          //   Navigator.pushNamedAndRemoveUntil(
          //     context,
          //     '/wallet',
          //     (route) => false,
          //   );
          // });
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
