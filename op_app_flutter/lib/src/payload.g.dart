// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payload _$PayloadFromJson(Map<String, dynamic> json) => Payload(
      defaultUser:
          DefaultUser.fromJson(json['defaultUser'] as Map<String, dynamic>),
      predefinedAmount: PredefinedAmount.fromJson(
          json['predefinedAmount'] as Map<String, dynamic>),
      redirectUrl: json['redirectUrl'] as String,
      isWebView: json['isWebView'] as bool,
    );

Map<String, dynamic> _$PayloadToJson(Payload instance) => <String, dynamic>{
      'defaultUser': instance.defaultUser.toJson(),
      'predefinedAmount': instance.predefinedAmount.toJson(),
      'redirectUrl': instance.redirectUrl,
      'isWebView': instance.isWebView,
    };

DefaultUser _$DefaultUserFromJson(Map<String, dynamic> json) => DefaultUser(
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
      dob: json['dob'] as String,
      email: json['email'] as String,
      ssn: json['ssn'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      phone: json['phone'] as String,
    );

Map<String, dynamic> _$DefaultUserToJson(DefaultUser instance) =>
    <String, dynamic>{
      'address': instance.address.toJson(),
      'dob': instance.dob,
      'email': instance.email,
      'ssn': instance.ssn,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'phone': instance.phone,
    };

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
      city: json['city'] as String,
      postalCode: json['postalCode'] as String,
      region: json['region'] as String,
      address: json['address'] as String,
    );

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'city': instance.city,
      'postalCode': instance.postalCode,
      'region': instance.region,
      'address': instance.address,
    };

PredefinedAmount _$PredefinedAmountFromJson(Map<String, dynamic> json) =>
    PredefinedAmount(
      values: (json['values'] as num).toDouble(),
      isEditable: json['isEditable'] as bool,
    );

Map<String, dynamic> _$PredefinedAmountToJson(PredefinedAmount instance) =>
    <String, dynamic>{
      'values': instance.values,
      'isEditable': instance.isEditable,
    };
