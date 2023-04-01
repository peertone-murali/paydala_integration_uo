// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:flutter/foundation.dart';

// import 'package:crypto/crypto.dart';
// import 'package:op_app_flutter/src/utils.dart';

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
