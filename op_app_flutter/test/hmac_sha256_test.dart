import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:op_app_flutter/src/op_server_api.dart';
import 'package:op_app_flutter/src/utils.dart';

//wrongly named file
void main() {
  test('HMAC with Java', () {
    const data = 'Hello World!';
    const key = '1fc2b5832bf04c5599476f24c8d86ab8';

    const expectedOutput =
        '9a20ddec8ae972bb18d57c0b18e9063486bc023dfea946f4f9f282db315d9e74';

    final output = generateHmacSha256Signature(data, key); //, key);
    if (kDebugMode) {
      print("expectedOutput = $expectedOutput, actualOutput = $output");
    }

    expect(output, equals(expectedOutput));
  });
}
