import 'package:gongbab_owner/domain/entities/dashboard/daily_dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'daily_dashboard_model.g.dart';

@JsonSerializable()
class DailyDashboardCompanyModel {
  final int companyId;
  final String companyName;
  final int meals;

  DailyDashboardCompanyModel({
    required this.companyId,
    required this.companyName,
    required this.meals,
  });

  factory DailyDashboardCompanyModel.fromJson(Map<String, dynamic> json) =>
      _$DailyDashboardCompanyModelFromJson(json);

  Map<String, dynamic> toJson() => _$DailyDashboardCompanyModelToJson(this);

  DailyDashboardCompany toDomain() {
    return DailyDashboardCompany(
      companyId: companyId,
      companyName: companyName,
      meals: meals,
    );
  }
}

@JsonSerializable()
class DailyDashboardByMealTypeModel {
  @JsonKey(name: 'BREAKFAST')
  final int additionalProp1;
  @JsonKey(name: 'LUNCH')
  final int additionalProp2;
  @JsonKey(name: 'DINNER')
  final int additionalProp3;

  DailyDashboardByMealTypeModel({
    required this.additionalProp1,
    required this.additionalProp2,
    required this.additionalProp3,
  });

  factory DailyDashboardByMealTypeModel.fromJson(Map<String, dynamic> json) =>
      _$DailyDashboardByMealTypeModelFromJson(json);

  Map<String, dynamic> toJson() => _$DailyDashboardByMealTypeModelToJson(this);

  DailyDashboardByMealType toDomain() {
    return DailyDashboardByMealType(
      additionalProp1: additionalProp1,
      additionalProp2: additionalProp2,
      additionalProp3: additionalProp3,
    );
  }
}

@JsonSerializable()
class DailyDashboardModel {
  final String date;
  final String? lastUpdatedAt;
  final DailyDashboardByMealTypeModel byMealType;
  final int totalMeals;
  final List<DailyDashboardCompanyModel> companies;

  DailyDashboardModel({
    required this.date,
    required this.lastUpdatedAt,
    required this.byMealType,
    required this.totalMeals,
    required this.companies,
  });

  factory DailyDashboardModel.fromJson(Map<String, dynamic> json) =>
      _$DailyDashboardModelFromJson(json);

  Map<String, dynamic> toJson() => _$DailyDashboardModelToJson(this);

  DailyDashboard toDomain() {
    return DailyDashboard(
      date: date,
      lastUpdatedAt: lastUpdatedAt,
      byMealType: byMealType.toDomain(),
      totalMeals: totalMeals,
      companies: companies.map((e) => e.toDomain()).toList(),
    );
  }
}
