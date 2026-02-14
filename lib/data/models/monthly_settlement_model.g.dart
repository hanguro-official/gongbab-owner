// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_settlement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MonthlySettlementCompanyModel _$MonthlySettlementCompanyModelFromJson(
        Map<String, dynamic> json) =>
    MonthlySettlementCompanyModel(
      companyId: (json['companyId'] as num).toInt(),
      companyName: json['companyName'] as String,
      meals: (json['meals'] as num).toInt(),
      unitPrice: (json['unitPrice'] as num).toInt(),
      amount: (json['amount'] as num).toInt(),
    );

Map<String, dynamic> _$MonthlySettlementCompanyModelToJson(
        MonthlySettlementCompanyModel instance) =>
    <String, dynamic>{
      'companyId': instance.companyId,
      'companyName': instance.companyName,
      'meals': instance.meals,
      'unitPrice': instance.unitPrice,
      'amount': instance.amount,
    };

MonthlySettlementModel _$MonthlySettlementModelFromJson(
        Map<String, dynamic> json) =>
    MonthlySettlementModel(
      month: json['month'] as String,
      totalMeals: (json['totalMeals'] as num).toInt(),
      totalAmount: (json['totalAmount'] as num).toInt(),
      companies: (json['companies'] as List<dynamic>)
          .map((e) =>
              MonthlySettlementCompanyModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      generatedAt: json['generatedAt'] as String?,
    );

Map<String, dynamic> _$MonthlySettlementModelToJson(
        MonthlySettlementModel instance) =>
    <String, dynamic>{
      'month': instance.month,
      'totalMeals': instance.totalMeals,
      'totalAmount': instance.totalAmount,
      'companies': instance.companies,
      'generatedAt': instance.generatedAt,
    };
