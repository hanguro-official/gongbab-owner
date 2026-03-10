import 'package:gongbab_owner/domain/entities/settlement/settlement.dart';
import 'package:json_annotation/json_annotation.dart';

part 'settlement_model.g.dart';

@JsonSerializable()
class SettlementItemModel {
  final int companyId;
  final String companyName;
  final int unitPrice;
  final int mealCount;
  final int supplyAmount;

  SettlementItemModel({
    required this.companyId,
    required this.companyName,
    required this.unitPrice,
    required this.mealCount,
    required this.supplyAmount,
  });

  factory SettlementItemModel.fromJson(Map<String, dynamic> json) =>
      _$SettlementItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$SettlementItemModelToJson(this);

  SettlementItem toDomain() {
    return SettlementItem(
      companyId: companyId,
      companyName: companyName,
      unitPrice: unitPrice,
      mealCount: mealCount,
      supplyAmount: supplyAmount,
    );
  }
}

@JsonSerializable()
class SettlementModel {
  final int id;
  final int year;
  final int month;
  final String status;
  final int? companyCount;
  final List<SettlementItemModel>? items;
  final int totalSupplyAmount;
  final String createdAt;
  final String? confirmedAt;

  SettlementModel({
    required this.id,
    required this.year,
    required this.month,
    required this.status,
    this.companyCount,
    this.items,
    required this.totalSupplyAmount,
    required this.createdAt,
    this.confirmedAt,
  });

  factory SettlementModel.fromJson(Map<String, dynamic> json) =>
      _$SettlementModelFromJson(json);

  Map<String, dynamic> toJson() => _$SettlementModelToJson(this);

  Settlement toDomain() {
    return Settlement(
      id: id,
      year: year,
      month: month,
      status: status,
      companyCount: companyCount,
      items: items?.map((e) => e.toDomain()).toList(),
      totalSupplyAmount: totalSupplyAmount,
      createdAt: createdAt,
      confirmedAt: confirmedAt,
    );
  }
}

@JsonSerializable()
class SettlementListResponseModel {
  final List<SettlementModel> settlements;

  SettlementListResponseModel({
    required this.settlements,
  });

  factory SettlementListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SettlementListResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$SettlementListResponseModelToJson(this);
}
