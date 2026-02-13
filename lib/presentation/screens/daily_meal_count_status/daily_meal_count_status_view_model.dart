import 'package:flutter/foundation.dart';
import 'package:gongbab_owner/domain/usecases/get_daily_dashboard_usecase.dart';
import 'package:gongbab_owner/presentation/screens/daily_meal_count_status/daily_meal_count_status_event.dart';
import 'package:gongbab_owner/presentation/screens/daily_meal_count_status/daily_meal_count_status_ui_state.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../../../data/auth/auth_token_manager.dart';

@injectable
class DailyMealCountStatusViewModel extends ChangeNotifier {
  final AuthTokenManager _authTokenManager;
  final GetDailyDashboardUseCase _getDailyDashboardUseCase;

  DailyMealCountStatusUiState _uiState = Initial();

  DailyMealCountStatusUiState get uiState => _uiState;

  DailyMealCountStatusViewModel(
    this._authTokenManager,
    this._getDailyDashboardUseCase,
  );

  void onEvent(DailyMealCountStatusEvent event) {
    if (event is LoadDailyDashboard) {
      _loadDailyDashboard(
        date: event.date,
      );
    }
  }

  Future<void> _loadDailyDashboard({
    required String date,
  }) async {
    _uiState = Loading();
    notifyListeners();

    final int? restaurantId = _authTokenManager.getRestaurantId();

    if (restaurantId == null) {
      _uiState = Error('Restaurant ID not found. Please log in again.');
      return;
    }

    final result = await _getDailyDashboardUseCase.execute(
      restaurantId: restaurantId,
      date: date,
    );

    result.when(
      success: (dashboard) {
        _uiState = Success(dashboard.companies, dashboard.lastUpdatedAt);
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
