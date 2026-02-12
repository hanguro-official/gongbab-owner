// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginModel _$LoginModelFromJson(Map<String, dynamic> json) => LoginModel(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      restaurant: json['restaurant'] == null
          ? null
          : RestaurantModel.fromJson(
              json['restaurant'] as Map<String, dynamic>),
      kioskCode: json['kioskCode'] as String?,
    );

Map<String, dynamic> _$LoginModelToJson(LoginModel instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'restaurant': instance.restaurant,
      'kioskCode': instance.kioskCode,
    };
