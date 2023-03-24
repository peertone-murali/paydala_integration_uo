import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:op_app_flutter/src/signedcreds.dart';
import 'package:op_app_flutter/src/utils.dart';

var CLIENT_ID = "425c10d5cb874f6c986ffd47b0411440";
var SECRET = "1fc2b5832bf04c5599476f24c8d86ab8";

SignedCreds getSignedCredsServer(String payload) {
// Make the POST request
  http.post(Uri.parse(endpointUrl), body: payload).then((response) {
    if (response.statusCode == 200) {
      // The API call was successful
      // print(response.body);
      var payloadMap = jsonDecode(response.body);
      return SignedCreds(payloadMap['creds'], payloadMap['signature']);
    } else {
      // There was an error
      // print('Error: ${response.reasonPhrase}');
    }
  }).catchError((error) {
    // There was an error in making the request
    // print('Error: $error');
  });
  return SignedCreds("", "");
}

SignedCreds getSignedCredsLocal(String payload) {
  Map<String, dynamic> map = jsonDecode(payload);
  Map<String, dynamic> credsMap = {
    // "requestId": generateUuid(),
    // "customerId": "1", // replace with customer id
    "client_id": CLIENT_ID,
    "category_id": 1,
    "region": "New York",
    "timestamp": getCurrentTimestamp(),
    "payload": map
  };
  var creds = jsonEncode(credsMap);
  return SignedCreds(creds, generateHmacSha256Signature(creds, SECRET));
}

SignedCreds getSignedCreds(String payload) {
  if (kDebugMode) {
    return getSignedCredsLocal(payload);
  } else {
    return getSignedCredsServer(payload);
  }
}
