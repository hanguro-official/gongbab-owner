abstract class CompanyMealDetailEvent {}

class LoadMealLogs extends CompanyMealDetailEvent {
  final int companyId;
  final String date;
  final String? q;
  final String? mealType;

  LoadMealLogs({required this.companyId, required this.date, this.q, this.mealType});
}

class LoadMoreMealLogs extends CompanyMealDetailEvent {
  final int companyId;
  final String date;
  final int page;
  final String? q;
  final String? mealType;

  LoadMoreMealLogs(
      {required this.companyId, required this.date, required this.page, this.q, this.mealType});
}
