class MonthlySettlementCompany {
  final int companyId;
  final String companyName;
  final int meals;
  final int unitPrice;
  final int amount;

  MonthlySettlementCompany({
    required this.companyId,
    required this.companyName,
    required this.meals,
    required this.unitPrice,
    required this.amount,
  });
}

class MonthlySettlement {
  final String month;
  final int totalMeals;
  final int totalAmount;
  final List<MonthlySettlementCompany> companies;
  final String? generatedAt;

  MonthlySettlement({
    required this.month,
    required this.totalMeals,
    required this.totalAmount,
    required this.companies,
    required this.generatedAt,
  });
}
