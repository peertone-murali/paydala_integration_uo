// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'txn_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionResponse _$TransactionResponseFromJson(Map<String, dynamic> json) =>
    TransactionResponse(
      result: json['result'] as String,
      refType: json['refType'] as int,
      txnRef: json['txnRef'] as String,
      timeStamp:
          TransactionResponse._dateTimeFromJson(json['timeStamp'] as String),
      txnDetails: (json['txnDetails'] as List<dynamic>)
          .map((e) => TransactionDetails.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TransactionResponseToJson(
        TransactionResponse instance) =>
    <String, dynamic>{
      'result': instance.result,
      'refType': instance.refType,
      'txnRef': instance.txnRef,
      'timeStamp': TransactionResponse._dateTimeToJson(instance.timeStamp),
      'txnDetails': instance.txnDetails.map((e) => e.toJson()).toList(),
    };

TransactionDetails _$TransactionDetailsFromJson(Map<String, dynamic> json) =>
    TransactionDetails(
      txnRef: json['txnRef'] as String,
      status: json['status'] as String,
      currencyId: json['currencyId'] as int,
      amount: (json['amount'] as num).toDouble(),
      timeStamp:
          TransactionDetails._dateTimeFromJson(json['timeStamp'] as String),
    );

Map<String, dynamic> _$TransactionDetailsToJson(TransactionDetails instance) =>
    <String, dynamic>{
      'txnRef': instance.txnRef,
      'status': instance.status,
      'currencyId': instance.currencyId,
      'amount': instance.amount,
      'timeStamp': TransactionDetails._dateTimeToJson(instance.timeStamp),
    };
