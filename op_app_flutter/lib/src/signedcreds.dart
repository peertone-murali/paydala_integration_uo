// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:flutter/foundation.dart';

// import 'package:crypto/crypto.dart';
// import 'package:op_app_flutter/src/utils.dart';

class SignedCreds {
  final String creds;
  final String signature;
  final int timestamp; // = DateTime.now().millisecondsSinceEpoch;

  SignedCreds(
      {required this.creds, required this.signature, required this.timestamp});

  SignedCreds.fromJson(Map<String, dynamic> json)
      : creds = json['creds'],
        signature = json['signature'],
        timestamp = json['timestamp'];

  Map<String, dynamic> toJson() => {
        'creds': creds,
        'signature': signature,
        'timestamp': timestamp,
      };
}
