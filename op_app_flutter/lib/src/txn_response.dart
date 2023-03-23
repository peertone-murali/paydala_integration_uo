// import 'package:flutter_test/flutter_test.dart';
// import 'package:json_annotation/json_annotation.dart';
// import 'package:intl/intl.dart';

// part 'txn_details.g.dart';

/*@JsonSerializable()
class TransactionResponse {
  String result;
  int refType;
  String txnRef;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime timeStamp;
  List<TransactionDetails> txnDetails;

  TransactionResponse({
    required this.result,
    required this.refType,
    required this.txnRef,
    required this.timeStamp,
    required this.txnDetails,
  });

  factory TransactionResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionResponseToJson(this);

  static DateTime _dateTimeFromJson(String dateTime) =>
      DateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(dateTime);

  static String _dateTimeToJson(DateTime dateTime) =>
      DateFormat("yyyy-MM-dd HH:mm:ss.SSS").format(dateTime);
}

@JsonSerializable()
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
      DateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(dateTime);

  static String _dateTimeToJson(DateTime dateTime) =>
      DateFormat("yyyy-MM-dd HH:mm:ss.SSS").format(dateTime);
}*/

import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';

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
