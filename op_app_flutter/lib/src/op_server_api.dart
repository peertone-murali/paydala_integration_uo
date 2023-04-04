import 'dart:convert';
import 'dart:async';
// import 'package:crypto/crypto.dart';
// import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
// import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:op_app_flutter/src/signedcreds.dart';
import 'package:op_app_flutter/src/txn_response.dart';
// import 'package:op_app_flutter/src/xfr_response.dart';
// import 'package:op_app_flutter/src/withdraw_payload.dart';
import 'package:op_app_flutter/src/utils.dart';
import 'package:op_app_flutter/src/withdraw_payload.dart';
import 'package:op_app_flutter/src/withdraw_response.dart';

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

SignedCreds getSignedCredsServer(String payload, bool addtimestamp) {
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
      return SignedCreds(
          creds: payloadMap['creds'],
          signature: payloadMap['signature'],
          timestamp: payloadMap['timestamp']);
    } else {
      // There was an error
      pdPrint('Error: ${response.reasonPhrase}');
    }
  }).catchError((error) {
    // There was an error in making the request
    pdPrint('Error: $error');
  });
  return SignedCreds(creds: "", signature: "", timestamp: 0);
}

SignedCreds getSignedCredsLocal(String payload, bool addtimestamp) {
  Map<String, dynamic>? payloadMap;

  try {
    payloadMap = jsonDecode(payload);
  } catch (e) {
    pdPrint("Error in decoding payload: $e");
    return SignedCreds(creds: "", signature: "", timestamp: 0);
  }
  var timestamp = DateTime.now().toUtc().millisecondsSinceEpoch;
  Map<String, dynamic> credsMap = {
    "client_id": CLIENT_ID,
    "category_id": 1,
    "region": "New York",
    "timestamp": getIso8601Timestamp(timestamp),
    "payload": payloadMap
  };
  var creds = jsonEncode(credsMap);

  return SignedCreds(
      creds: creds,
      signature: addtimestamp
          ? generateHmacSha256Signature("${timestamp.toString()}$creds", SECRET)
          : generateHmacSha256Signature(creds, SECRET),
      timestamp: timestamp);
}

SignedCreds getSignedCreds(String payload, bool addtimestamp) {
  if (kDebugMode) {
    return getSignedCredsLocal(payload, addtimestamp);
  } else {
    SignedCreds? signedCreds = getSignedCredsServer(payload, addtimestamp);
    return signedCreds;
  }
}

TransactionResponse? getTxnStatusLocal(int refType, String txnRef) {
  final body = jsonEncode({'refType': refType, 'txnRef': txnRef});
  final timestamp = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
  final headers = {
    'CB-ACCESS-SIGN':
        generateHmacSha256Signature("$timestamp$CLIENT_ID", SECRET),
    'CB-ACCESS-TIMESTAMP': timestamp, //.toUtc().toIso8601String(), //timestamp,
    'CB-ACCESS-CLIENT-ID': CLIENT_ID,
    'Content-Type': 'application/json'
  };

  pdPrint("headers = ${jsonEncode(headers)} and body = $body");

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
        pdPrint('Error: ${response.reasonPhrase}');
        // return null;
      }
    });
  } catch (e) {
    pdPrint("Error processing response: $e");
    rethrow;
  }
  // print("it should not come here");
  return null;
}

Future<WithdrawResponse?> sendMoney(WithdrawPayload payload) async {
  if (kDebugMode) {
    return sendMoneyLocal(payload);
  } else {
    return null;
  }
}

Future<WithdrawResponse?> sendMoneyLocal(WithdrawPayload payload) async {
  // final timestamp = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
  WithdrawResponse? result;

  String jsonString = json.encode(payload.toJson());
  SignedCreds signedCreds = getSignedCreds(jsonString, true);

  Map<String, String> headers = {
    'CB-ACCESS-CLIENT-ID': CLIENT_ID,
    'CB-ACCESS-TIMESTAMP': signedCreds.timestamp.toString(),
    'CB-ACCESS-SIGN': signedCreds.signature,
    // generateHmacSha256Signature(message, SECRET), //signedCreds.signature,
    'Content-Type': 'application/json',
  };

  // var headerStr = jsonEncode(headers);

  final response = await http.post(
      Uri.parse("$pdBaseUrl/transactions/v1/sendMoney"),
      headers: headers,
      body: signedCreds.creds);

  if (response.statusCode == 200) {
    result = WithdrawResponse.fromJson(json.decode(response.body));
    pdPrint('Transaction was successful');
  } else {
    result = WithdrawResponse(
      success: false,
      error: response.body,
      response: Response(amount: 0, txnRef: "", currencyId: 0),
    );
    pdPrint('Transaction failed with status code ${response.statusCode}');
  }

  return result;
}


// Future<http.Response> postJson(String url, Map<String, dynamic> body) async {
//   http.Response response = await http.post(
//     Uri.parse(url),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: jsonEncode(body),
//   );
//   if (response.statusCode == 200) {
//     return response;
//   } else {
//     throw Exception('Failed to load data');
//   }
// }

// void main() async {
//   String url = 'https://example.com/api';
//   Map<String, dynamic> body = {'key1': 'value1', 'key2': 'value2'};

//   try {
//     http.Response response = await postJson(url, body);
//     print(response.body);
//   } catch (error) {
//     print('HTTP request failed with error: $error');
//   }
// }
