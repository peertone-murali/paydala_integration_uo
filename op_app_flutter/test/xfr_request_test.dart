import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';
import 'package:op_app_flutter/src/xfr_request.dart';

void main() {
  group('TransferRequest', () {
    test('fromJson and toJson', () {
      String jsonString = '''
{
    "requestId": "66623bfe-cdae-11ed-afa1-0242ac120002",
    "customerId": "sqnbxf",
    "email" : "john.doe@example.com",
    "currencyId": 1,
    "amount": 100.0,
    "xfrType" : "towallet",
    "accountDetails": {
        "accountName": "",
        "bankName": "",
        "accountNo": "",
        "routingNo": " ",
        "swiftCode": ""
    }       
}
''';

      Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      TransferRequest transferRequest = TransferRequest.fromJson(jsonMap);
      expect(transferRequest.requestId, '66623bfe-cdae-11ed-afa1-0242ac120002');
      expect(transferRequest.customerId, 'sqnbxf');
      expect(transferRequest.email, 'john.doe@example.com');
      expect(transferRequest.currencyId, 1);
      expect(transferRequest.amount, 100.0);
      expect(transferRequest.xfrType, 'towallet');
      expect(transferRequest.accountDetails.accountName, '');
      expect(transferRequest.accountDetails.bankName, '');
      expect(transferRequest.accountDetails.accountNo, '');
      expect(transferRequest.accountDetails.routingNo, ' ');
      expect(transferRequest.accountDetails.swiftCode, '');

      String encodedJsonString = jsonEncode(transferRequest.toJson());
      Map<String, dynamic> encodedJsonMap = jsonDecode(encodedJsonString);
      TransferRequest encodedTransferRequest =
          TransferRequest.fromJson(encodedJsonMap);
      expect(encodedTransferRequest.requestId,
          '66623bfe-cdae-11ed-afa1-0242ac120002');
      expect(encodedTransferRequest.customerId, 'sqnbxf');
      expect(encodedTransferRequest.email, 'john.doe@example.com');
      expect(encodedTransferRequest.currencyId, 1);
      expect(encodedTransferRequest.amount, 100.0);
      expect(encodedTransferRequest.xfrType, 'towallet');
      expect(encodedTransferRequest.accountDetails.accountName, '');
      expect(encodedTransferRequest.accountDetails.bankName, '');
      expect(encodedTransferRequest.accountDetails.accountNo, '');
      expect(encodedTransferRequest.accountDetails.routingNo, ' ');
      expect(encodedTransferRequest.accountDetails.swiftCode, '');
    });
  });
}
