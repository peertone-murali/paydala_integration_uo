// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'xfr_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransferRequest _$TransferRequestFromJson(Map<String, dynamic> json) =>
    TransferRequest(
      requestId: json['requestId'] as String,
      customerId: json['customerId'] as String,
      email: json['email'] as String,
      currencyId: json['currencyId'] as int,
      amount: (json['amount'] as num).toDouble(),
      xfrType: json['xfrType'] as String,
      accountDetails: AccountDetails.fromJson(
          json['accountDetails'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TransferRequestToJson(TransferRequest instance) =>
    <String, dynamic>{
      'requestId': instance.requestId,
      'customerId': instance.customerId,
      'email': instance.email,
      'currencyId': instance.currencyId,
      'amount': instance.amount,
      'xfrType': instance.xfrType,
      'accountDetails': instance.accountDetails.toJson(),
    };

AccountDetails _$AccountDetailsFromJson(Map<String, dynamic> json) =>
    AccountDetails(
      accountName: json['accountName'] as String,
      bankName: json['bankName'] as String,
      accountNo: json['accountNo'] as String,
      routingNo: json['routingNo'] as String,
      swiftCode: json['swiftCode'] as String,
    );

Map<String, dynamic> _$AccountDetailsToJson(AccountDetails instance) =>
    <String, dynamic>{
      'accountName': instance.accountName,
      'bankName': instance.bankName,
      'accountNo': instance.accountNo,
      'routingNo': instance.routingNo,
      'swiftCode': instance.swiftCode,
    };
