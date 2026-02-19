abstract class CompanyMealDetailEvent {}

class LoadMealLogs extends CompanyMealDetailEvent {
  final int companyId;
  final String date;

  LoadMealLogs({required this.companyId, required this.date});
}

class LoadMoreMealLogs extends CompanyMealDetailEvent {
  final int companyId;
  final String date;
  final int page;

  LoadMoreMealLogs(
      {required this.companyId, required this.date, required this.page});
}
