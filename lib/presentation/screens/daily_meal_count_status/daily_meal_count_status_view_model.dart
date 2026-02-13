import 'package:flutter/foundation.dart';
import 'package:gongbab_owner/domain/usecases/get_daily_dashboard_usecase.dart';
import 'package:gongbab_owner/presentation/screens/daily_meal_count_status/daily_meal_count_status_event.dart';
import 'package:gongbab_owner/presentation/screens/daily_meal_count_status/daily_meal_count_status_ui_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class DailyMealCountStatusViewModel extends ChangeNotifier {
  final GetDailyDashboardUseCase _getDailyDashboardUseCase;

  DailyMealCountStatusUiState _uiState = const Initial();
  DailyMealCountStatusUiState get uiState => _uiState;

  DailyMealCountStatusViewModel(this._getDailyDashboardUseCase);

  void onEvent(DailyMealCountStatusEvent event) {
    if (event is LoadDailyDashboard) {
      _loadDailyDashboard(
        restaurantId: event.restaurantId,
        date: event.date,
      );
    }
  }

  Future<void> _loadDailyDashboard({
    required String restaurantId,
    required String date,
  }) async {
    _uiState = const Loading();
    notifyListeners();

    final result = await _getDailyDashboardUseCase.execute(
      restaurantId: restaurantId,
      date: date,
    );

    result.when(
      success: (dashboard) {
        _uiState = Success(dashboard.companies, DateTime.now());
        notifyListeners();
      },
      failure: (success, error) {
        _uiState = Error(error?['message'] ?? 'Unknown error');
        notifyListeners();
      },
      error: (message) {
        _uiState = Error(message);
        notifyListeners();
      },
    );
  }
}
