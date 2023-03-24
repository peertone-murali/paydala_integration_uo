import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'channel_event.g.dart';

@JsonSerializable(explicitToJson: true)
class ChannelEvent {
  String type;
  EventPayload payload;

  ChannelEvent({required this.type, required this.payload});

  factory ChannelEvent.fromJson(Map<String, dynamic> json) =>
      _$ChannelEventFromJson(json);

  Map<String, dynamic> toJson() => _$ChannelEventToJson(this);
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

ChannelEvent createChannelEvent(String jsonStr) {
  var channelMap = jsonDecode(jsonStr);

  print("creds = $jsonStr");

  return ChannelEvent.fromJson(channelMap);
}
