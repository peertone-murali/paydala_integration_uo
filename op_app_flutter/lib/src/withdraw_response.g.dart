// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withdraw_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WithdrawResponse _$WithdrawResponseFromJson(Map<String, dynamic> json) =>
    WithdrawResponse(
      success: json['success'] as bool,
      error: json['error'] as String?,
      response: json['response'] == null
          ? null
          : Response.fromJson(json['response'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WithdrawResponseToJson(WithdrawResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'error': instance.error,
      'response': instance.response?.toJson(),
    };

Response _$ResponseFromJson(Map<String, dynamic> json) => Response(
      amount: (json['amount'] as num).toDouble(),
      txnRef: json['txnRef'] as String,
      currencyId: json['currencyId'] as int,
    );

Map<String, dynamic> _$ResponseToJson(Response instance) => <String, dynamic>{
      'amount': instance.amount,
      'txnRef': instance.txnRef,
      'currencyId': instance.currencyId,
    };
