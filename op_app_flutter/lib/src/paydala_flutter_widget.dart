import 'dart:async';
import 'dart:convert';
import 'dart:io';

// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:op_app_flutter/src/channel_event.dart';
import 'package:op_app_flutter/src/payload.dart';
import 'package:op_app_flutter/src/signedcreds.dart';
import 'package:op_app_flutter/src/txn_response.dart';
import 'package:op_app_flutter/src/utils.dart';
// import 'package:op_app_flutter/src/utils.dart';

class PaydalaFlutterWidget extends StatefulWidget {
  final ValueChanged<Object> onTransaction;
  final String title;
  final String url;
  late String requestId;
  late SignedCreds signedCreds;
  TransactionResponse? txnResponse;

  PaydalaFlutterWidget(
      {required this.onTransaction,
      required this.title,
      required this.url,
      required this.signedCreds}) {
    txnResponse = createTxnResponse(signedCreds.creds);
    try {
      var credsMap = jsonDecode(signedCreds.creds);
      requestId = credsMap['payload']["requestId"];
    } catch (e) {
      pdPrint("Error decoding JSON: $e");
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
            var headers = {
              "credentials": Uri.encodeComponent(widget.signedCreds.creds),
              "x-client-sign": widget.signedCreds
                  .signature, //.encodeComponent(widget.signedCreds.signature),
              "requestId":
                  widget.requestId, // Uri.encodeComponent(widget.requestId)
            };
            print(headers);
            await webViewController.loadUrl(
              "${widget.url}&credentials=${headers['credentials']}&requestId=${headers['requestId']}&x-client-sign=${headers['x-client-sign']}", //Uri.encodeFull(widget.url),
              // headers: headers,
            );
          },
          onProgress: (int progress) {
            pdPrint('WebView is loading (progress : $progress%)');
          },
          javascriptChannels: <JavascriptChannel>{
            _paydalaJavascriptChannel(context, widget),
          },
          navigationDelegate: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              pdPrint('blocking navigation to $request}');
              return NavigationDecision.prevent;
            }
            pdPrint('allowing navigation to $request');
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            pdPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            pdPrint('Page finished loading: $url');
          },
          gestureNavigationEnabled: true,
          backgroundColor: const Color(0x00000000),
          geolocationEnabled: true, // set geolocationEnable true or not
        );
      }),
    );
  }

//   final String channelEventStr = '''
// {
//  "type": "transactionComplete",
//  "payload":{
//   "result": "success",
//   "refType": 2,
//   "status": "success",
//   "currencyId": 1,
//   "amount": 100.00,
//   "timeStamp": "2020-01-01T00:00:00Z",
//   "txnRef": "3b524d4-c254-11ed-afa1-0242ac120002"
//  }
// }''';

//   final String channelEventStr1 = '''
// {
//   "type": "transactionComplete",
//   "singleTxnDetail": {
//     "refType": 1,
//     "status": "success",
//     "currencyId": 1,
//     "amount": 20,
//     "timeStamp": "2023-03-30T11:06:08.682Z",
//     "txnRef": "wpiZa9tRK"
//   }
// }
// ''';

  JavascriptChannel _paydalaJavascriptChannel(
      BuildContext context, PaydalaFlutterWidget widget) {
    return JavascriptChannel(
        name: 'PayDala',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text("txnDetails ${message.message}")),
          // );

          pdPrint("txnDetails JSON = ${message.message}");

          // showMessageDialog(context, "Deposit result", message.message);
          // Navigator.pop(context);
          // var txnResponse = message.message;
          final jsonMap = jsonDecode(message.message);
          if (jsonMap["type"] == "closePaydala") {
            Navigator.pop(context);
            return;
          }

          ChannelEvent? chEvent;
          var txnResponse = message.message;
          //channelEventStr;
          try {
            chEvent = createChannelEvent(txnResponse);
          } catch (e) {
            pdPrint("Error creating ChannelEvent: $e");
          }

          final TransactionDetails txnDetail = createTxnDetails(txnResponse);
          final Payload payload =
              Payload.fromJson(jsonDecode(widget.signedCreds.creds)['payload']);
          // if (chEvent?.type == "paydalaClose") {
          //   Navigator.pop(context);
          // }
          // final
          txnDetail.amount = payload.predefinedAmount.values;
          widget.txnResponse?.txnDetails.add(txnDetail);

          widget.onTransaction(txnDetail);

          if (chEvent?.type == "transactionComplete") {
            widget.onTransaction(widget.txnResponse as Object);
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/wallet',
              (route) => false,
            ).then((value) => setState(() {}));
          }
        });

    // Navigator.pushReplacementNamed(context, '/wallet');
    //   // Navigator.pushNamedAndRemoveUntil(
    //   //   context,
    //   //   '/wallet',
    //   //   (route) => false,
    //   // ).then((value) => setState(() {}));
    // });
    //});
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
