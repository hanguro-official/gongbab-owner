// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settlement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettlementItemModel _$SettlementItemModelFromJson(Map<String, dynamic> json) =>
    SettlementItemModel(
      companyId: (json['companyId'] as num).toInt(),
      companyName: json['companyName'] as String,
      unitPrice: (json['unitPrice'] as num).toInt(),
      mealCount: (json['mealCount'] as num).toInt(),
      supplyAmount: (json['supplyAmount'] as num).toInt(),
    );

Map<String, dynamic> _$SettlementItemModelToJson(
        SettlementItemModel instance) =>
    <String, dynamic>{
      'companyId': instance.companyId,
      'companyName': instance.companyName,
      'unitPrice': instance.unitPrice,
      'mealCount': instance.mealCount,
      'supplyAmount': instance.supplyAmount,
    };

SettlementModel _$SettlementModelFromJson(Map<String, dynamic> json) =>
    SettlementModel(
      id: (json['id'] as num).toInt(),
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num).toInt(),
      status: json['status'] as String,
      companyCount: (json['companyCount'] as num?)?.toInt(),
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => SettlementItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalSupplyAmount: (json['totalSupplyAmount'] as num).toInt(),
      createdAt: json['createdAt'] as String,
      confirmedAt: json['confirmedAt'] as String?,
    );

Map<String, dynamic> _$SettlementModelToJson(SettlementModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'year': instance.year,
      'month': instance.month,
      'status': instance.status,
      'companyCount': instance.companyCount,
      'items': instance.items,
      'totalSupplyAmount': instance.totalSupplyAmount,
      'createdAt': instance.createdAt,
      'confirmedAt': instance.confirmedAt,
    };

SettlementListResponseModel _$SettlementListResponseModelFromJson(
        Map<String, dynamic> json) =>
    SettlementListResponseModel(
      settlements: (json['settlements'] as List<dynamic>)
          .map((e) => SettlementModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SettlementListResponseModelToJson(
        SettlementListResponseModel instance) =>
    <String, dynamic>{
      'settlements': instance.settlements,
    };
