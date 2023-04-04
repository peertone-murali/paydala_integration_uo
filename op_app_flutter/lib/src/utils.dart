import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

bool isJSON(String str) {
  try {
    jsonDecode(str);
    return true;
  } catch (_) {
    return false;
  }
}

String getCurrentTimestamp() {
  var now = DateTime.now();
  return now.toUtc().toIso8601String();
}

String getIso8601Timestamp(int milliseconds) {
  var now = DateTime.fromMillisecondsSinceEpoch(milliseconds);
  return "${now.toIso8601String()}Z";
}

String generateHmacSha256Signature(String message, String secret) {
  var key = utf8.encode(secret);
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

void pdPrint(String message) {
  assert(() {
    // print(message);
    debugPrint(message, wrapWidth: 80);
    return true;
  }());
}
