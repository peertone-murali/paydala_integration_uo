import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'payload.g.dart';

@JsonSerializable(explicitToJson: true)
class Payload {
  String requestId;
  String customerId;
  final DefaultUser defaultUser;
  final PredefinedAmount predefinedAmount;
  final String redirectUrl;
  final bool isWebView;

  Payload({
    required this.requestId,
    required this.customerId,
    required this.defaultUser,
    required this.predefinedAmount,
    required this.redirectUrl,
    required this.isWebView,
  });

  factory Payload.fromJson(Map<String, dynamic> json) =>
      _$PayloadFromJson(json);

  Map<String, dynamic> toJson() => _$PayloadToJson(this);
}

@JsonSerializable(explicitToJson: true)
class DefaultUser {
  final Address address;
  final String dob;
  final String email;
  final String ssn;

  @JsonKey(name: 'first_name')
  final String firstName;

  @JsonKey(name: 'last_name')
  final String lastName;
  final String phone;

  DefaultUser({
    required this.address,
    required this.dob,
    required this.email,
    required this.ssn,
    required this.firstName,
    required this.lastName,
    required this.phone,
  });

  factory DefaultUser.fromJson(Map<String, dynamic> json) =>
      _$DefaultUserFromJson(json);

  Map<String, dynamic> toJson() => _$DefaultUserToJson(this);
}

@JsonSerializable()
class Address {
  final String city;
  final String postalCode;
  final String region;
  final String address;

  Address({
    required this.city,
    required this.postalCode,
    required this.region,
    required this.address,
  });

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);
}

@JsonSerializable()
class PredefinedAmount {
  @JsonKey(/*fromJson: _doubleFromJson,*/ toJson: _doubleToJson)
  late double values;
  late bool isEditable;

  PredefinedAmount({
    required this.values,
    required this.isEditable,
  });

  factory PredefinedAmount.fromJson(Map<String, dynamic> json) =>
      _$PredefinedAmountFromJson(json);

  Map<String, dynamic> toJson() => _$PredefinedAmountToJson(this);
  // static double _doubleFromJson(String doubleStr) =>
  //     double.parse(doubleStr);

  static num _doubleToJson(double values) =>
      (values % 1 == 0 ? values.toInt() : values);
  // values.toString().replaceAll(RegExp(r'([.]*0)(?!.*\d)'), '');
}

// "requestId": "",
// "customerId" : "1",
// "client_id": "$CLIENT_ID",
// "category_id": 1,
// "region": "USA",
// "timestamp": "2018-09-22T00:00:00Z",

var payloadJson = '''
{
    "requestId": "",
    "customerId" : "1",
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
/*var payloadJson = '''
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
            "ssn": "6789",
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
      ''';*/
Payload createPayload() {
  Map<String, dynamic> payloadMap = jsonDecode(payloadJson);
  var payload = Payload.fromJson(payloadMap);
  return payload;
}

String getJsonString(Payload payload) {
  return jsonEncode(payload);
}
