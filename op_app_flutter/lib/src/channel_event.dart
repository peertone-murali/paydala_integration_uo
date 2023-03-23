import 'package:json_annotation/json_annotation.dart';

part 'channel_event.g.dart';

@JsonSerializable(explicitToJson: true)
class TransactionComplete {
  String type;
  EventPayload payload;

  TransactionComplete({required this.type, required this.payload});

  factory TransactionComplete.fromJson(Map<String, dynamic> json) =>
      _$TransactionCompleteFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionCompleteToJson(this);
}

@JsonSerializable(explicitToJson: true)
class EventPayload {
  String result;
  int refType;
  String status;
  int currencyId;
  double amount;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime timeStamp;
  String txnRef;

  @JsonKey(name: 'payload')
  EventPayload({
    required this.result,
    required this.refType,
    required this.status,
    required this.currencyId,
    required this.amount,
    required this.timeStamp,
    required this.txnRef,
  });

  factory EventPayload.fromJson(Map<String, dynamic> json) =>
      _$EventPayloadFromJson(json);

  Map<String, dynamic> toJson() => _$EventPayloadToJson(this);

  static DateTime _dateTimeFromJson(String timestamp) =>
      DateTime.parse(timestamp).toUtc();

  static String _dateTimeToJson(DateTime dateTime) =>
      dateTime.toUtc().toIso8601String();
}
