import 'package:gongbab_owner/domain/entities/settlement/monthly_settlement.dart';
import 'package:json_annotation/json_annotation.dart';

part 'monthly_settlement_model.g.dart';

@JsonSerializable()
class MonthlySettlementCompanyModel {
  final int companyId;
  final String companyName;
  final int meals;
  final int unitPrice;
  final int amount;

  MonthlySettlementCompanyModel({
    required this.companyId,
    required this.companyName,
    required this.meals,
    required this.unitPrice,
    required this.amount,
  });

  factory MonthlySettlementCompanyModel.fromJson(Map<String, dynamic> json) =>
      _$MonthlySettlementCompanyModelFromJson(json);

  Map<String, dynamic> toJson() => _$MonthlySettlementCompanyModelToJson(this);

  MonthlySettlementCompany toDomain() {
    return MonthlySettlementCompany(
      companyId: companyId,
      companyName: companyName,
      meals: meals,
      unitPrice: unitPrice,
      amount: amount,
    );
  }
}

@JsonSerializable()
class MonthlySettlementModel {
  final String month;
  final int totalMeals;
  final int totalAmount;
  final List<MonthlySettlementCompanyModel> companies;
  final String? generatedAt;

  MonthlySettlementModel({
    required this.month,
    required this.totalMeals,
    required this.totalAmount,
    required this.companies,
    required this.generatedAt,
  });

  factory MonthlySettlementModel.fromJson(Map<String, dynamic> json) =>
      _$MonthlySettlementModelFromJson(json);

  Map<String, dynamic> toJson() => _$MonthlySettlementModelToJson(this);

  MonthlySettlement toDomain() {
    return MonthlySettlement(
      month: month,
      totalMeals: totalMeals,
      totalAmount: totalAmount,
      companies: companies.map((e) => e.toDomain()).toList(),
      generatedAt: generatedAt,
    );
  }
}
