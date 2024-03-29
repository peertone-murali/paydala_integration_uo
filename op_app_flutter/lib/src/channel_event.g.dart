// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelEvent _$ChannelEventFromJson(Map<String, dynamic> json) => ChannelEvent(
      type: json['type'] as String,
      payload: EventPayload.fromJson(
          json['singleTxnDetail'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChannelEventToJson(ChannelEvent instance) =>
    <String, dynamic>{
      'type': instance.type,
      'singleTxnDetail': instance.payload.toJson(),
    };

EventPayload _$EventPayloadFromJson(Map<String, dynamic> json) => EventPayload(
      result: json['result'] as String?,
      refType: json['refType'] as int,
      status: json['status'] as String,
      currencyId: json['currencyId'] as int,
      amount: (json['amount'] as num).toDouble(),
      timeStamp: EventPayload._dateTimeFromJson(json['timeStamp'] as String),
      txnRef: json['txnRef'] as String,
    );

Map<String, dynamic> _$EventPayloadToJson(EventPayload instance) =>
    <String, dynamic>{
      'result': instance.result,
      'refType': instance.refType,
      'status': instance.status,
      'currencyId': instance.currencyId,
      'amount': instance.amount,
      'timeStamp': EventPayload._dateTimeToJson(instance.timeStamp),
      'txnRef': instance.txnRef,
    };
