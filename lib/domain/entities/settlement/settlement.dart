class SettlementItem {
  final int companyId;
  final String companyName;
  final int unitPrice;
  final int mealCount;
  final int supplyAmount;

  SettlementItem({
    required this.companyId,
    required this.companyName,
    required this.unitPrice,
    required this.mealCount,
    required this.supplyAmount,
  });
}

class Settlement {
  final int id;
  final int year;
  final int month;
  final String status;
  final int? companyCount;
  final List<SettlementItem>? items;
  final int totalSupplyAmount;
  final String createdAt;
  final String? confirmedAt;

  Settlement({
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
}
