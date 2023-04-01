import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:op_app_flutter/src/op_server_api.dart';
import 'package:op_app_flutter/src/txn_response.dart';
// import 'package:op_app_flutter/src/utils.dart';

// {'requestId': '2e1141e4-c744-4d22-a589-a3337d913d8d', 'amount': '50.0', 'txnRref': 'BleFQaLsV', 'status': 'Deposit successful'}

//wrongly named file
void main() {
  const refType = 2;
  const txnRef = '2e1141e4-c744-4d22-a589-a3337d913d8d';
  TransactionResponse? txnResponse = getTxnStatusLocal(refType, txnRef);
  if (txnResponse != null) {
    print(txnResponse.toJson());
  }
  test('Test getTxnStatus', () {
    if (txnResponse != null) {
      expect(txnResponse.txnRef, equals(txnRef));
      expect(txnResponse.result, equals('success'));
      expect(txnResponse.refType, equals(refType));
      expect(txnResponse.txnDetails.length, equals(1));
      expect(txnResponse.txnDetails[0].txnRef, equals('BleFQaLsV'));
      expect(txnResponse.txnDetails[0].status, equals('Deposit successful'));
      expect(txnResponse.txnDetails[0].currencyId, equals(1));
      expect(txnResponse.txnDetails[0].amount, equals(50.0));
      print("txnResponse JSON : ${txnResponse.toJson()}");
    } else {
      expect(txnResponse, isNotNull);
    }
  });
}
