import 'package:flutter_test/flutter_test.dart';
// import 'package:json_annotation/json_annotation.dart';
// import 'package:intl/intl.dart';
import 'package:op_app_flutter/src/txn_details.dart';

void main() {
  test('TransactionResponse.fromJson() should correctly parse JSON', () {
    final json = {
      "result": "partial",
      "refType": 2,
      "txnRef": "3b524d4-c254-11ed-afa1-0242ac120002",
      "timeStamp": "2023-03-19 10:00:00.000",
      "txnDetails": [
        {
          "txnRef": "abcdef",
          "status": "processing",
          "currencyId": 1,
          "amount": 10.0,
          "timeStamp": "2023-03-19 10:01:00.000"
        },
        {
          "txnRef": "ghijkl",
          "status": "processed",
          "currencyId": 2,
          "amount": 20.0,
          "timeStamp": "2023-03-19 10:02:00.000"
        }
      ]
    };

    final transactionResponse = TransactionResponse.fromJson(json);

    expect(transactionResponse.result, equals("partial"));
    expect(transactionResponse.refType, equals(2));
    expect(transactionResponse.txnRef,
        equals("3b524d4-c254-11ed-afa1-0242ac120002"));
    expect(transactionResponse.timeStamp,
        equals(DateTime.parse("2023-03-19 10:00:00.000")));
    expect(transactionResponse.txnDetails.length, equals(2));

    final txnDetails1 = transactionResponse.txnDetails[0];
    expect(txnDetails1.txnRef, equals("abcdef"));
    expect(txnDetails1.status, equals("processing"));
    expect(txnDetails1.currencyId, equals(1));
    expect(txnDetails1.amount, equals(10.0));
    expect(txnDetails1.timeStamp,
        equals(DateTime.parse("2023-03-19 10:01:00.000")));

    final txnDetails2 = transactionResponse.txnDetails[1];
    expect(txnDetails2.txnRef, equals("ghijkl"));
    expect(txnDetails2.status, equals("processed"));
    expect(txnDetails2.currencyId, equals(2));
    expect(txnDetails2.amount, equals(20.0));
    expect(txnDetails2.timeStamp,
        equals(DateTime.parse("2023-03-19 10:02:00.000")));
  });

  test('TransactionResponse toJson should match the expected json format', () {
    final dateTime1 = DateTime(2023, 3, 22, 15, 30, 0, 0, 0);
    final dateTime2 = DateTime(2023, 3, 23, 10, 0, 0, 0, 0);
    final txnDetails1 = TransactionDetails(
      txnRef: 'abcdef',
      status: 'processing',
      currencyId: 1,
      amount: 10.0,
      timeStamp: dateTime1,
    );
    final txnDetails2 = TransactionDetails(
      txnRef: 'ghijkl',
      status: 'successful',
      currencyId: 2,
      amount: 20.0,
      timeStamp: dateTime2,
    );
    final transactionResponse = TransactionResponse(
      result: 'partial',
      refType: 2,
      txnRef: '3b524d4-c254-11ed-afa1-0242ac120002',
      timeStamp: dateTime1,
      txnDetails: [txnDetails1, txnDetails2],
    );

    final expectedJson = {
      'result': 'partial',
      'refType': 2,
      'txnRef': '3b524d4-c254-11ed-afa1-0242ac120002',
      'timeStamp': '2023-03-22 15:30:00.000',
      'txnDetails': [
        {
          'txnRef': 'abcdef',
          'status': 'processing',
          'currencyId': 1,
          'amount': 10.0,
          'timeStamp': '2023-03-22 15:30:00.000',
        },
        {
          'txnRef': 'ghijkl',
          'status': 'successful',
          'currencyId': 2,
          'amount': 20.0,
          'timeStamp': '2023-03-23 10:00:00.000',
        },
      ],
    };

    expect(transactionResponse.toJson(), expectedJson);
  });
}
