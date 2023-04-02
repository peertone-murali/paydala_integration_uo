import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:op_app_flutter/src/signedcreds.dart';
import 'package:op_app_flutter/src/txn_response.dart';
// import 'package:op_app_flutter/src/txn_response.dart';
import 'package:op_app_flutter/src/utils.dart';

var CLIENT_ID = "425c10d5cb874f6c986ffd47b0411440";
var SECRET = "1fc2b5832bf04c5599476f24c8d86ab8";
// Define the endpoint URL and the data to send in the request body
const String opBaseUrl = 'http://localhost:8080/getSignedCreds';
var pdBaseUrl = "https://dev-api.paydala.com";

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
  final headers = {'Content-Type': 'application/json'};
// Make the POST request
  http
      .post(Uri.parse(pdBaseUrl), headers: headers, body: payload)
      .timeout(const Duration(seconds: 10))
      .then((response) {
    if (response.statusCode == 200) {
      // The API call was successful
      // print(response.body);
      var payloadMap = jsonDecode(response.body);
      return SignedCreds(payloadMap['creds'], payloadMap['signature']);
    } else {
      // There was an error
      print('Error: ${response.reasonPhrase}');
    }
  }).catchError((error) {
    // There was an error in making the request
    print('Error: $error');
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
    SignedCreds? signedCreds = getSignedCredsServer(payload);
    return signedCreds;
  }
}

TransactionResponse? getTxnStatusLocal1(int refType, String txnRef) {
  final body = jsonEncode({'refType': refType, 'txnRef': txnRef});
  final timestamp = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
  final headers = {
    'CB-ACCESS-SIGN':
        generateHmacSha256Signature("$timestamp$CLIENT_ID", SECRET),
    'CB-ACCESS-TIMESTAMP': timestamp, //.toUtc().toIso8601String(), //timestamp,
    'CB-ACCESS-CLIENT-ID': CLIENT_ID,
    'Content-Type': 'application/json'
  };

  print("headers = ${jsonEncode(headers)} and body = $body");

  try {
    final response = http
        .post(
      Uri.parse("$pdBaseUrl/transactions/status"),
      headers: headers,
      body: body,
    )
        .then((response) {
      pdPrint("getTxnStatusLocal: ${response.body}");
      if (response.statusCode == 200) {
        // The API call was successful
        // print(response.body);
        try {
          var payloadMap = jsonDecode(response.body);
          return TransactionResponse.fromJson(payloadMap);
        } catch (e) {
          pdPrint("Error processing response: $e");
          rethrow;
        }
      } else {
        // There was an error
        print('Error: ${response.reasonPhrase}');
        return null;
      }
    });
  } catch (e) {
    pdPrint("Error processing response: $e");
    rethrow;
  }
  print("it should not come here");
  return null;
}

TransactionResponse? getTxnStatusLocal(int refType, String txnRef) {
  final body = jsonEncode({'refType': refType, 'txnRef': txnRef});
  // final headers = {
  //   'CB-ACCESS-SIGN': generateHmacSha256Signature(body, SECRET),
  //   'CB-ACCESS-TIMESTAMP': DateTime.now().millisecondsSinceEpoch,
  //   'CB-ACCESS-CLIENT-ID': CLIENT_ID,
  //   'Content-Type': 'application/json'
  // };
  final timestamp = DateTime.now().toUtc().millisecondsSinceEpoch;
  final headers = {
    'CB-ACCESS-SIGN':
        "f01dba102347f5665a9c76bc97bfaada71318c38e8ee107ccf9035f366b93431",
    //generateHmacSha256Signature("$timestamp$CLIENT_ID", SECRET),
    'CB-ACCESS-TIMESTAMP':
        1679926141737, //timestamp, //.toUtc().toIso8601String(), //timestamp,
    'CB-ACCESS-CLIENT-ID': CLIENT_ID,
    'Content-Type': 'application/json'
  };

  print("headers = ${jsonEncode(headers)} and body = $body");

  final dio = Dio();
  final response = dio
      .post("$pdBaseUrl/transactions/status",
          data: body, options: Options(headers: headers))
      .then((response) {
    pdPrint("getTxnStatusLocal: ${response.data}");
    if (response.statusCode == 200) {
      // The API call was successful
      try {
        var payloadMap = jsonDecode(response.data);
        return TransactionResponse.fromJson(payloadMap);
      } catch (e) {
        pdPrint("Error processing response: $e");
        rethrow;
      }
    } else {
      // There was an error
      print(
          'httpStatus: ${response.statusCode}, Error : ${response.statusMessage}');
      return null;
    }
  });

  print("it should not come here");
  return null;
}
