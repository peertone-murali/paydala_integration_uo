// import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:crypto/crypto.dart';
import 'package:op_app_flutter/src/utils.dart';

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

SignedCreds? getSignedCreds(String payload) {
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
  return null;
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
  return SignedCreds(creds, generateHmacSha256Signature(creds));
}

class UserTransaction {
  double amount;
  bool canMakeDeposits;

  UserTransaction(this.amount, this.canMakeDeposits);

  UserTransaction.fromJson(Map<String, dynamic> json)
      : amount = json['amount'],
        canMakeDeposits = json['canMakeDeposits'];

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'canMakeDeposits': canMakeDeposits,
      };
}

class User {
  String firstName;
  String middleName;
  String lastName;
  String customerId;
  String email;
  String dob;
  String ssl4;
  String streetAddress;
  String addressCity;
  String addressState;
  String addressZip;
  String addressCountry;
  String mobilePh;
  UserTransaction userTransaction;

//{"firstname":"Joe","middlename":"st.","lastname":"smith","customer_id":"1","email":"john","dob":"10/22/2000","ssl4":"3456","street_address":"123 Elm st","address_city":"Big city","address_state":"Tx","address_zip":"56060","address_country":"USA","mobile_ph":"4023345676"}

  User(
    this.firstName,
    this.middleName,
    this.lastName,
    this.customerId,
    this.email,
    this.dob,
    this.ssl4,
    this.streetAddress,
    this.addressCity,
    this.addressState,
    this.addressZip,
    this.addressCountry,
    this.mobilePh,
    this.userTransaction,
  );

  User.fromJson(Map<String, dynamic> json)
      : firstName = json['firstName'],
        middleName = json['middleName'],
        lastName = json['lastName'],
        customerId = json['customerId'],
        email = json['email'],
        dob = json['dob'],
        ssl4 = json['ssl4'],
        streetAddress = json['streetAddress'],
        addressCity = json['addressCity'],
        addressState = json['addressState'],
        addressZip = json['addressZip'],
        addressCountry = json['addressCountry'],
        mobilePh = json['mobilePh'],
        userTransaction = UserTransaction.fromJson(json['userTransaction']);

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'middleName': middleName,
        'lastName': lastName,
        'customerId': customerId,
        'email': email,
        'dob': dob,
        'ssl4': ssl4,
        'streetAddress': streetAddress,
        'addressCity': addressCity,
        'addressState': addressState,
        'addressZip': addressZip,
        'addressCountry': addressCountry,
        'mobilePh': mobilePh,
        'userTransaction': userTransaction.toJson(),
      };
}
