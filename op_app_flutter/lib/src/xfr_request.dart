import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'xfr_request.g.dart';

@JsonSerializable(explicitToJson: true)
class TransferRequest {
  @JsonKey(name: 'client_id')
  final String clientId;
  @JsonKey(name: 'category_id')
  final int categoryId;
  final String region;
  final String timestamp;
  @JsonKey(name: 'payload')
  final XfrPayload payload;

  TransferRequest({
    required this.clientId,
    required this.categoryId,
    required this.region,
    required this.timestamp,
    required this.payload,
  });

  factory TransferRequest.fromJson(Map<String, dynamic> json) =>
      _$TransferRequestFromJson(json);

  Map<String, dynamic> toJson() => _$TransferRequestToJson(this);
}

@JsonSerializable(explicitToJson: true)
class XfrPayload {
  String requestId;
  String customerId;
  final String email;
  @JsonKey(name: 'currencyId')
  final int currencyID;
  double amount;
  @JsonKey(name: 'xfrType')
  final String xfrType;
  @JsonKey(name: 'accountDetails')
  final AccountDetails accountDetails;

  XfrPayload({
    required this.requestId,
    required this.customerId,
    required this.email,
    required this.currencyID,
    required this.amount,
    required this.xfrType,
    required this.accountDetails,
  });

  factory XfrPayload.fromJson(Map<String, dynamic> json) =>
      _$XfrPayloadFromJson(json);

  Map<String, dynamic> toJson() => _$XfrPayloadToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AccountDetails {
  @JsonKey(name: 'accountName')
  final String accountName;
  @JsonKey(name: 'bankName')
  final String bankName;
  @JsonKey(name: 'accountNo')
  final String accountNo;
  @JsonKey(name: 'routingNo')
  final String routingNo;
  @JsonKey(name: 'swiftCode')
  final String swiftCode;
  @JsonKey(name: 'accountType')
  final String accountType;

  AccountDetails({
    required this.accountName,
    required this.bankName,
    required this.accountNo,
    required this.routingNo,
    required this.swiftCode,
    required this.accountType,
  });

  factory AccountDetails.fromJson(Map<String, dynamic> json) =>
      _$AccountDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$AccountDetailsToJson(this);
}

const requestJson = """{
  "client_id": "425c10d5cb874f6c986ffd47b0411440",
  "category_id": 1,
  "region": "New York",
  "timestamp": "",
  "payload": {
    "requestId": "66623bfe-cdae-11ed-afa1-0242ac120002",
    "customerId": "123456",
    "email": "john.smith@demora.org",
    "currencyId": 1,
    "amount": 10.0,
    "xfrType": "towallet",
    "accountDetails": {
      "accountName": "Chase Test",
      "bankName": "",
      "accountNo": "293647325",
      "routingNo": "322271627",
      "swiftCode": "",
      "accountType": "savings"
    }
  }
}""";

TransferRequest createRequest() {
  return TransferRequest.fromJson(jsonDecode(requestJson));
}
