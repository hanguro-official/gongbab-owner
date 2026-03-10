// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settlement_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettlementCreateRequestItemModel _$SettlementCreateRequestItemModelFromJson(
        Map<String, dynamic> json) =>
    SettlementCreateRequestItemModel(
      companyName: json['companyName'] as String,
      unitPrice: (json['unitPrice'] as num).toInt(),
      mealCount: (json['mealCount'] as num).toInt(),
    );

Map<String, dynamic> _$SettlementCreateRequestItemModelToJson(
        SettlementCreateRequestItemModel instance) =>
    <String, dynamic>{
      'companyName': instance.companyName,
      'unitPrice': instance.unitPrice,
      'mealCount': instance.mealCount,
    };

SettlementCreateRequestModel _$SettlementCreateRequestModelFromJson(
        Map<String, dynamic> json) =>
    SettlementCreateRequestModel(
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num).toInt(),
      items: (json['items'] as List<dynamic>)
          .map((e) => SettlementCreateRequestItemModel.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SettlementCreateRequestModelToJson(
        SettlementCreateRequestModel instance) =>
    <String, dynamic>{
      'year': instance.year,
      'month': instance.month,
      'items': instance.items,
    };
