import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:op_app_flutter/src/payload.dart';

void main() {
  group('Payload', () {
    test('fromJson() should correctly parse json', () {
      // Arrange
      const json = '''
        {
          "requestId": "1234",
          "customerId": "5678",
          "defaultUser": {
            "address": {
              "city": "New York",
              "postalCode": "07051",
              "region": "New York",
              "address": "First Avenue"
            },
            "dob": "1986-02-20",
            "email": "john.smith@demora.org",
            "ssn": "2451",
            "first_name": "John",
            "last_name": "Smith",
            "phone": "2010100341"
          },
          "predefinedAmount": {
            "values": 30,
            "isEditable": false
          },
          "redirectUrl": "https://dev.paydala.com",
          "isWebView": true
        }
      ''';

      // Act
      final payload = Payload.fromJson(jsonDecode(json));

      // Assert
      expect(payload.requestId, '1234');
      expect(payload.customerId, '5678');
      expect(payload.redirectUrl, 'https://dev.paydala.com');
      expect(payload.isWebView, true);
      expect(payload.defaultUser.firstName, 'John');
      expect(payload.defaultUser.address.postalCode, '07051');
      expect(payload.predefinedAmount.values, 30);
      expect(payload.predefinedAmount.isEditable, false);
    });

    test('toJson() should correctly serialize to json', () {
      // Arrange
      final payload = Payload(
        requestId: '1234',
        customerId: '5678',
        redirectUrl: 'https://dev.paydala.com',
        isWebView: true,
        defaultUser: DefaultUser(
          address: Address(
            city: 'New York',
            postalCode: '07051',
            region: 'New York',
            address: 'First Avenue',
          ),
          dob: '1986-02-20',
          email: 'john.smith@demora.org',
          ssn: '2451',
          firstName: 'John',
          lastName: 'Smith',
          phone: '2010100341',
        ),
        predefinedAmount: PredefinedAmount(
          values: 30,
          isEditable: false,
        ),
        userFlow: {
          guestOnly: true,
        },

    });


      // Act
      final json = payload.toJson();

      // Assert
      expect(json['requestId'], '1234');
      expect(json['customerId'], '5678');
      expect(json['redirectUrl'], 'https://dev.paydala.com');
      expect(json['isWebView'], true);
      expect(json['defaultUser']['firstName'], 'John');
      expect(json['defaultUser']['address']['postalCode'], '07051');
      expect(json['predefinedAmount']['values'], 30);
      expect(json['predefinedAmount']['isEditable'], false);
    });
  });
}
