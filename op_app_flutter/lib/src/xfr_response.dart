import 'package:json_annotation/json_annotation.dart';

part 'xfr_response.g.dart';

@JsonSerializable(explicitToJson: true)
class TransferResponse {
  final bool success;
  final String? error;
  final Response? response;

  TransferResponse({
    required this.success,
    this.error,
    this.response,
  });

  factory TransferResponse.fromJson(Map<String, dynamic> json) =>
      _$TransferResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TransferResponseToJson(this);
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
