import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';

import 'channel_event.dart';

part 'txn_response.g.dart';

@JsonSerializable(explicitToJson: true)
class TransactionResponse {
  String result;
  late String message;
  int refType;
  String txnRef;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime timeStamp;
  List<TransactionDetails> txnDetails;

  TransactionResponse({
    required this.result,
    required this.message,
    required this.refType,
    required this.txnRef,
    required this.timeStamp,
    required this.txnDetails,
  });

  factory TransactionResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionResponseToJson(this);

  static DateTime _dateTimeFromJson(String dateTime) =>
      DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").parse(dateTime);

  static String _dateTimeToJson(DateTime dateTime) =>
      DateFormat("yyyy-MM-dd'T'HH:mm:ssZ").format(dateTime);
}

@JsonSerializable(explicitToJson: true)
class TransactionDetails {
  String txnRef;
  String status;
  int currencyId;
  double amount;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime timeStamp;

  TransactionDetails({
    required this.txnRef,
    required this.status,
    required this.currencyId,
    required this.amount,
    required this.timeStamp,
  });

  factory TransactionDetails.fromJson(Map<String, dynamic> json) =>
      _$TransactionDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionDetailsToJson(this);

  static DateTime _dateTimeFromJson(String dateTime) =>
      DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(dateTime);

  static String _dateTimeToJson(DateTime dateTime) =>
      DateFormat("yyyy-MM-ddTHH:mm:ssZ").format(dateTime);
}

TransactionResponse createTxnResponse(String creds) {
  var credsMap = jsonDecode(creds);

  print("creds = $creds");

  return TransactionResponse(
      result: "",
      message: "",
      refType: 2,
      txnRef: credsMap["payload"]["requestId"],
      timeStamp: DateTime.parse(credsMap["timestamp"]),
      txnDetails: []);
}

TransactionDetails createTxnDetails(String jsonStr) {
  var jsonMap = jsonDecode(jsonStr);

  if (kDebugMode) {
    print("txnDetails = $jsonStr");
  }

  var chEvent = ChannelEvent.fromJson(jsonMap);
  var txnDetail = TransactionDetails(
    txnRef: chEvent.payload.txnRef,
    status: chEvent.payload.status,
    currencyId: 1,
    amount: chEvent.payload.amount,
    timeStamp: chEvent.payload.timeStamp,
  );

  return txnDetail;
}
