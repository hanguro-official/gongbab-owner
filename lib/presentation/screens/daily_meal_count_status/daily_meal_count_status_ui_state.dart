import 'package:gongbab_owner/domain/entities/dashboard/daily_dashboard.dart';

abstract class DailyMealCountStatusUiState {}

class Initial extends DailyMealCountStatusUiState {
}

class Loading extends DailyMealCountStatusUiState {

}

class Success extends DailyMealCountStatusUiState {
  final List<DailyDashboardCompany> companies;
  final String? lastUpdateTime;

  Success(this.companies, this.lastUpdateTime);
}

class Error extends DailyMealCountStatusUiState {
  final String message;

  Error(this.message);
}
