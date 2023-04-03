import 'dart:convert';
import 'dart:async';
// import 'package:crypto/crypto.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
// import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:op_app_flutter/src/signedcreds.dart';
import 'package:op_app_flutter/src/txn_response.dart';
import 'package:op_app_flutter/src/xfr_response.dart';
import 'package:op_app_flutter/src/xfr_request.dart';
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

Future<TransferResponse?> sendMoney(TransferRequest transaction) async {
  // String apiUrl = 'https://dev-api.paydala.com/transactions/v1/sendMoney';
  // String clientId = '425c10d5cb874f6c986ffd47b0411440';
  // String clientSecret = 'put-your-client-secret-here'; // replace with your actual client secret
  final timestamp = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
  // String body = json.encode({
  //   'client_id': CLIENT_ID,
  //   'category_id': 1,
  //   'region': 'New York',
  //   'timestamp': timestamp,
  //   'payload': transaction.toJson(),
  // });
  TransferResponse? result;
  String jsonString = json.encode(transaction.toJson());
  String signature = generateHmacSha256Signature("$timestamp$jsonString",
      SECRET); //generateSignature(clientSecret, timestamp, body);
  Map<String, String> headers = {
    'CB-ACCESS-CLIENT-ID': CLIENT_ID,
    'CB-ACCESS-TIMESTAMP': timestamp,
    'CB-ACCESS-SIGN': signature,
    'Content-Type': 'application/json',
  };
  final response = await http.post(
      Uri.parse("$pdBaseUrl/transactions/v1/sendMoney"),
      headers: headers,
      body: jsonString);

  if (response.statusCode == 200) {
    result = TransferResponse.fromJson(json.decode(response.body));
    pdPrint('Transaction was successful');
  } else {
    result = TransferResponse(
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
