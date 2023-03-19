import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:op_app_flutter/src/payload.dart';

/*void main() {
  test('Payload.fromJson() should parse JSON correctly', () {
    final json = '''
    {
      "defaultUser": {
        "address": {
          "city": "New Jersey",
          "postalCode": "07051",
          "region": "New Jersey",
          "address": "First Avenue"
        },
        "dob": "1986-02-20",
        "email": "john.smith@demora.org",
        "ssn": "2451",
        "first_name": "John",
        "last_name": "Smith",
        "phone": "2010100341"
      },
      "predefinedAmount": {"values": 30, "isEditable": false},
      "redirectUrl": "https://dev.paydala.com",
      "isWebView": true
    }
    ''';

    final myClass = Payload.fromJson(jsonDecode(json));

    // expect(myClass.customerId, equals("..."));
    // expect(myClass.clientId, equals("6f5df04e484640e98e2310268b5dbbd4"));
    // expect(myClass.categoryId, equals(1));
    // expect(myClass.region, equals("USA"));
    // expect(myClass.timestamp, equals("2018-09-22T00:00:00Z"));

    expect(myClass.defaultUser.address.city, equals("New Jersey"));
    expect(myClass.defaultUser.address.postalCode, equals("07051"));
    expect(myClass.defaultUser.address.region, equals("New Jersey"));
    expect(myClass.defaultUser.address.address, equals("First Avenue"));
    expect(myClass.defaultUser.dob, equals("1986-02-20"));
    expect(myClass.defaultUser.email, equals("john.smith@demora.org"));
    expect(myClass.defaultUser.ssn, equals("2451"));
    expect(myClass.defaultUser.firstName, equals("John"));
    expect(myClass.defaultUser.lastName, equals("Smith"));
    expect(myClass.defaultUser.phone, equals("2010100341"));

    expect(myClass.predefinedAmount.values, equals(30));
    expect(myClass.predefinedAmount.isEditable, equals(false));

    expect(myClass.redirectUrl, equals("https://dev.paydala.com"));
    expect(myClass.isWebView, equals(true));
  });
}*/

void main() {
  group('Payload', () {
    test('fromJson() and toJson()', () {
      final json = '''
        {
          "defaultUser": {
            "address": {
              "city": "San Francisco",
              "postalCode": "94107",
              "region": "CA",
              "address": "123 Main St"
            },
            "dob": "1990-01-01",
            "email": "john@example.com",
            "ssn": "123-45-6789",
            "first_name": "John",
            "last_name": "Doe",
            "phone": "555-555-5555"
          },
          "predefinedAmount": {
            "values": 30,
            "isEditable": false
          },
          "redirectUrl": "https://dev.paydala.com",
          "isWebView": true
        }
      ''';
      final payload = Payload.fromJson(jsonDecode(json));
      expect(payload.defaultUser.address.city, 'San Francisco');
      expect(payload.predefinedAmount.values, 30);
      expect(payload.redirectUrl, 'https://dev.paydala.com');
      expect(payload.isWebView, true);

      final json2 = payload.toJson();
      final payload2 = Payload.fromJson(json2);
      expect(payload2.defaultUser.address.city, 'San Francisco');
      expect(payload2.predefinedAmount.values, 30);
      expect(payload2.redirectUrl, 'https://dev.paydala.com');
      expect(payload2.isWebView, true);
    });
  });
}
