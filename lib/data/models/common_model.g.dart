// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommonModel _$CommonModelFromJson(Map<String, dynamic> json) => CommonModel(
      success: json['success'] as bool,
      error: json['data'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$CommonModelToJson(CommonModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.error,
    };
