import 'package:json_annotation/json_annotation.dart';

part 'xfr_payload.g.dart';

@JsonSerializable(explicitToJson: true)
class TransferRequest {
  final String requestId;
  final String customerId;
  final String email;
  final int currencyId;
  final double amount;
  final String xfrType;
  final AccountDetails accountDetails;

  TransferRequest({
    required this.requestId,
    required this.customerId,
    required this.email,
    required this.currencyId,
    required this.amount,
    required this.xfrType,
    required this.accountDetails,
  });

  factory TransferRequest.fromJson(Map<String, dynamic> json) =>
      _$TransferRequestFromJson(json);

  Map<String, dynamic> toJson() => _$TransferRequestToJson(this);
}

@JsonSerializable()
class AccountDetails {
  final String accountName;
  final String bankName;
  final String accountNo;
  final String routingNo;
  final String swiftCode;
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
