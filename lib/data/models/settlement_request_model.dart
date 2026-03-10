import 'package:json_annotation/json_annotation.dart';

part 'settlement_request_model.g.dart';

@JsonSerializable()
class SettlementCreateRequestItemModel {
  final String companyName;
  final int unitPrice;
  final int mealCount;

  SettlementCreateRequestItemModel({
    required this.companyName,
    required this.unitPrice,
    required this.mealCount,
  });

  factory SettlementCreateRequestItemModel.fromJson(Map<String, dynamic> json) =>
      _$SettlementCreateRequestItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$SettlementCreateRequestItemModelToJson(this);
}

@JsonSerializable()
class SettlementCreateRequestModel {
  final int year;
  final int month;
  final List<SettlementCreateRequestItemModel> items;

  SettlementCreateRequestModel({
    required this.year,
    required this.month,
    required this.items,
  });

  factory SettlementCreateRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SettlementCreateRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$SettlementCreateRequestModelToJson(this);
}
