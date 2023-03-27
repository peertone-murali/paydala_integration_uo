import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'payload.g.dart';

@JsonSerializable(explicitToJson: true)
class Payload {
  String requestId;
  String customerId;
  DefaultUser defaultUser;
  PredefinedAmount predefinedAmount;
  String redirectUrl;
  bool isWebView;
  UserFlow userFlow;

  Payload(
      {required this.requestId,
      required this.customerId,
      required this.defaultUser,
      required this.predefinedAmount,
      required this.redirectUrl,
      required this.isWebView,
      required this.userFlow});

  factory Payload.fromJson(Map<String, dynamic> json) =>
      _$PayloadFromJson(json);

  Map<String, dynamic> toJson() => _$PayloadToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UserFlow {
  final bool guestOnly;

  UserFlow({required this.guestOnly});

  factory UserFlow.fromJson(Map<String, dynamic> json) =>
      _$UserFlowFromJson(json);

  Map<String, dynamic> toJson() => _$UserFlowToJson(this);
}

@JsonSerializable(explicitToJson: true)
class DefaultUser {
  Address address;
  String dob;
  String email;
  String ssn;

  @JsonKey(name: 'first_name')
  String firstName;

  @JsonKey(name: 'last_name')
  String lastName;
  String phone;

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
  String city;
  String postalCode;
  String region;
  String address;

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
    "isWebView": true,
    "userFlow": {
      "guestOnly": true
    }
}
''';

Payload createPayload() {
  Map<String, dynamic> payloadMap = jsonDecode(payloadJson);
  var payload = Payload.fromJson(payloadMap);
  return payload;
}

String getJsonString(Payload payload) {
  return jsonEncode(payload);
}
