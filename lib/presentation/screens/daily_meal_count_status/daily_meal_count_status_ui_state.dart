import 'package:gongbab_owner/domain/entities/dashboard/daily_dashboard.dart';

abstract class DailyMealCountStatusUiState {}

class Initial extends DailyMealCountStatusUiState {
  const Initial();
}

class Loading extends DailyMealCountStatusUiState {
  const Loading();
}

class Success extends DailyMealCountStatusUiState {
  final List<DailyDashboardCompany> companies;
  final DateTime lastUpdateTime;

  const Success(this.companies, this.lastUpdateTime);
}

class Error extends DailyMealCountStatusUiState {
  final String message;
  const Error(this.message);
}
