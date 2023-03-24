import 'package:flutter_test/flutter_test.dart';
import 'package:op_app_flutter/src/channel_event.dart';

void main() {
  group('ChannelEvent', () {
    test('fromJson creates a valid ChannelEvent instance', () {
      final Map<String, dynamic> json = {
        'type': 'event_type',
        'payload': {
          'result': 'result_value',
          'refType': 1,
          'status': 'status_value',
          'currencyId': 1,
          'amount': 1.0,
          'timeStamp': '2022-03-24T12:34:56Z',
          'txnRef': 'txnRef_value',
        },
      };

      final channelEvent = ChannelEvent.fromJson(json);

      expect(channelEvent.type, equals('event_type'));
      expect(channelEvent.payload.result, equals('result_value'));
      expect(channelEvent.payload.refType, equals(1));
      expect(channelEvent.payload.status, equals('status_value'));
      expect(channelEvent.payload.currencyId, equals(1));
      expect(channelEvent.payload.amount, equals(1.0));
      expect(channelEvent.payload.timeStamp.toIso8601String(),
          equals('2022-03-24T12:34:56.000Z'));
      expect(channelEvent.payload.txnRef, equals('txnRef_value'));
    });

    test('toJson returns a valid JSON map', () {
      final channelEvent = ChannelEvent(
        type: 'event_type',
        payload: EventPayload(
          result: 'result_value',
          refType: 1,
          status: 'status_value',
          currencyId: 1,
          amount: 1.0,
          timeStamp: DateTime.parse('2022-03-24T12:34:56Z'),
          txnRef: 'txnRef_value',
        ),
      );

      final json = channelEvent.toJson();

      expect(json['type'], equals('event_type'));
      expect(json['payload']['result'], equals('result_value'));
      expect(json['payload']['refType'], equals(1));
      expect(json['payload']['status'], equals('status_value'));
      expect(json['payload']['currencyId'], equals(1));
      expect(json['payload']['amount'], equals(1.0));
      expect(json['payload']['timeStamp'], equals('2022-03-24T12:34:56.000Z'));
      expect(json['payload']['txnRef'], equals('txnRef_value'));
    });
  });
}
