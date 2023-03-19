import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

var CLIENT_ID = "425c10d5cb874f6c986ffd47b0411440";
var SECRET = "1fc2b5832bf04c5599476f24c8d86ab8";

String getCurrentTimestamp() {
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
  return formatter.format(now.toUtc());
}

String generateHmacSha256Signature(String message) {
  var key = utf8.encode(SECRET);
  var bytes = utf8.encode(message);
  var hmacSha256 = Hmac(sha256, key); // Create a HMAC-SHA256 hasher.
  var digest = hmacSha256.convert(bytes); // Calculate the digest (signature).
  return digest.toString();
}

String generateGuid() {
  var rand = Random();
  var codeUnits = List.generate(16, (index) {
    return rand.nextInt(256);
  });

  // set version bits
  codeUnits[6] = (codeUnits[6] & 0x0f) | 0x40;
  codeUnits[8] = (codeUnits[8] & 0x3f) | 0x80;

  var chars = codeUnits.map((codeUnit) {
    return codeUnit.toRadixString(16).padLeft(2, '0');
  }).join('');

  return '${chars.substring(0, 8)}-${chars.substring(8, 12)}-'
      '${chars.substring(12, 16)}-${chars.substring(16, 20)}-${chars.substring(20)}';
}

String generateUuid() {
  var uuid = Uuid();
  return uuid.v4();
}