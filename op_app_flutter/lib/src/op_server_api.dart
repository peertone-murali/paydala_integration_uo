import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:op_app_flutter/src/signedcreds.dart';
import 'package:op_app_flutter/src/txn_response.dart';
import 'package:op_app_flutter/src/utils.dart';

var CLIENT_ID = "425c10d5cb874f6c986ffd47b0411440";
var SECRET = "1fc2b5832bf04c5599476f24c8d86ab8";
// Define the endpoint URL and the data to send in the request body
const String opBaseUrl = 'http://localhost:8080/getSignedCreds';
var paydalaBaseUrl = "https://api.paydala.com";

/* This function is called by the Paydala flutter widget to get the signed credentials
 * from the operator's server. Hence the endpoint needs to implemented on the operator's 
 * server. The operator's server should return a JSON object with the following fields:
 * 
 * 1. creds: The signed credentials
 * 2. signature: The signature of the signed credentials
 * 
 * Rever to the sample code of the operator server's endpoint under the following
 * op_backend/python/op_server_fastapi and op_backend/python/op_server_django server 
 * implementations.
 */

SignedCreds getSignedCredsServer(String payload) {
// Make the POST request
  http.post(Uri.parse(paydalaBaseUrl), body: payload).then((response) {
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
  Map<String, dynamic> payloadMap = jsonDecode(payload);
  Map<String, dynamic> credsMap = {
    // "requestId": generateUuid(),
    // "customerId": "1", // replace with customer id
    "client_id": CLIENT_ID,
    "category_id": 1,
    "region": "New York",
    "timestamp": getCurrentTimestamp(),
    "payload": payloadMap
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

Future<http.Response> getTxnStatusLocal(String refType, String txnRef) async {
  final body = jsonEncode({'refType': refType, 'txnRef': txnRef});
  final headers = {
    'CB-ACCESS-SIGN': generateHmacSha256Signature(body, SECRET),
    'CB-ACCESS-TIMESTAMP':
        DateTime.now().toUtc().toIso8601String(), //timestamp,
    'CB-ACCESS-CLIENT-ID': CLIENT_ID,
    'Content-Type': 'application/json'
  };

  final response = await http.post(
      Uri.parse("$paydalaBaseUrl/transaction/status"),
      headers: headers,
      body: body);

  try {
    var responseMap = jsonDecode(response.body);
    if (responseMap['status'] == 'success') {
      return response;
    } else {
      throw Exception(responseMap['message']);
    }
  } catch (e) {
    pdPrint("Error decoding JSON: $e");
  }
  // return TransactionResponse(result: result, message: message, refType: refType, txnRef: txnRef, timeStamp: timeStamp, txnDetails: txnDetails)

  return response;
}

Future<SignedCreds?> makeRequest(String payload) async {
  const samplePayload = '''{
    "requestId": "",
    "customerId" : "1",
    "defaultUser": {
      "address": {
        "city": "New York",
        "postalCode": "07051",
        "region": "New York",
        "address": "First Avenue"
      },
      "dob": "1986-02-20",
      "email": "john.smith@demora.org",
      "ssn": "2451",
      "first_name": "John",
      "last_name": "Smith",
      "phone": "2010100341"
    },
    "predefinedAmount": {
      "values": 30,
      "isEditable": false
    },
    "redirectUrl": "https://dev.paydala.com",
    "isWebView": true
  }''';

  try {
    final headers = {'Content-Type': 'application/json'};
    final response = await http
        .post(Uri.parse("$opBaseUrl/getSignedCreds"),
            headers: headers, body: payload)
        .timeout(const Duration(seconds: 10));
    if (response.statusCode == 400) {
      pdPrint("Error: ${response.reasonPhrase}");
    }

    pdPrint("${response.statusCode}");
    pdPrint(response.body);

    try {
      SignedCreds signedCreds = SignedCreds.fromJson(jsonDecode(response.body));
      return signedCreds;
    } catch (e) {
      pdPrint("Error decoding JSON: $e");
    }
  } catch (e) {
    pdPrint('Request timed out');
  }
  return null;
}
