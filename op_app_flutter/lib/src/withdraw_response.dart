import 'package:json_annotation/json_annotation.dart';

part 'withdraw_response.g.dart';

@JsonSerializable(explicitToJson: true)
class WithdrawResponse {
  final bool success;
  final String? error;
  final Response? response;

  WithdrawResponse({
    required this.success,
    this.error,
    this.response,
  });

  factory WithdrawResponse.fromJson(Map<String, dynamic> json) =>
      _$WithdrawResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WithdrawResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Response {
  final double amount;
  final String txnRef;
  final int currencyId;

  Response({
    required this.amount,
    required this.txnRef,
    required this.currencyId,
  });

  factory Response.fromJson(Map<String, dynamic> json) =>
      _$ResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseToJson(this);
}
