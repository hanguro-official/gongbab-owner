// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_dashboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyDashboardCompanyModel _$DailyDashboardCompanyModelFromJson(
        Map<String, dynamic> json) =>
    DailyDashboardCompanyModel(
      companyId: (json['companyId'] as num).toInt(),
      companyName: json['companyName'] as String,
      meals: (json['meals'] as num).toInt(),
    );

Map<String, dynamic> _$DailyDashboardCompanyModelToJson(
        DailyDashboardCompanyModel instance) =>
    <String, dynamic>{
      'companyId': instance.companyId,
      'companyName': instance.companyName,
      'meals': instance.meals,
    };

DailyDashboardByMealTypeModel _$DailyDashboardByMealTypeModelFromJson(
        Map<String, dynamic> json) =>
    DailyDashboardByMealTypeModel(
      additionalProp1: (json['BREAKFAST'] as num).toInt(),
      additionalProp2: (json['LUNCH'] as num).toInt(),
      additionalProp3: (json['DINNER'] as num).toInt(),
    );

Map<String, dynamic> _$DailyDashboardByMealTypeModelToJson(
        DailyDashboardByMealTypeModel instance) =>
    <String, dynamic>{
      'BREAKFAST': instance.additionalProp1,
      'LUNCH': instance.additionalProp2,
      'DINNER': instance.additionalProp3,
    };

DailyDashboardModel _$DailyDashboardModelFromJson(Map<String, dynamic> json) =>
    DailyDashboardModel(
      date: json['date'] as String,
      lastUpdatedAt: json['lastUpdatedAt'] as String?,
      byMealType: DailyDashboardByMealTypeModel.fromJson(
          json['byMealType'] as Map<String, dynamic>),
      totalMeals: (json['totalMeals'] as num).toInt(),
      companies: (json['companies'] as List<dynamic>)
          .map((e) =>
              DailyDashboardCompanyModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DailyDashboardModelToJson(
        DailyDashboardModel instance) =>
    <String, dynamic>{
      'date': instance.date,
      'lastUpdatedAt': instance.lastUpdatedAt,
      'byMealType': instance.byMealType,
      'totalMeals': instance.totalMeals,
      'companies': instance.companies,
    };
