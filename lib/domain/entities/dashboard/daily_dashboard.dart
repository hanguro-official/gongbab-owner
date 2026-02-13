class DailyDashboardCompany {
  final int companyId;
  final String companyName;
  final int meals;

  DailyDashboardCompany({
    required this.companyId,
    required this.companyName,
    required this.meals,
  });
}

class DailyDashboardByMealType {
  final int additionalProp1;
  final int additionalProp2;
  final int additionalProp3;

  DailyDashboardByMealType({
    required this.additionalProp1,
    required this.additionalProp2,
    required this.additionalProp3,
  });
}

class DailyDashboard {
  final String date;
  final String? lastUpdatedAt;
  final DailyDashboardByMealType byMealType;
  final int totalMeals;
  final List<DailyDashboardCompany> companies;

  DailyDashboard({
    required this.date,
    required this.lastUpdatedAt,
    required this.byMealType,
    required this.totalMeals,
    required this.companies,
  });
}
