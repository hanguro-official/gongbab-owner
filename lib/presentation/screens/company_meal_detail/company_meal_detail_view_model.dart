import 'package:flutter/foundation.dart';
import 'package:gongbab_owner/data/auth/auth_token_manager.dart';
import 'package:gongbab_owner/domain/entities/meal_log/meal_log.dart';
import 'package:gongbab_owner/domain/usecases/get_meal_logs_usecase.dart';
import 'package:gongbab_owner/presentation/screens/company_meal_detail/company_meal_detail_event.dart';
import 'package:gongbab_owner/presentation/screens/company_meal_detail/company_meal_detail_ui_state.dart';
import 'package:injectable/injectable.dart';

import 'company_meal_detail_screen.dart'; // Import MealType enum

@injectable
class CompanyMealDetailViewModel extends ChangeNotifier {
  final AuthTokenManager _authTokenManager;
  final GetMealLogsUseCase _getMealLogsUseCase;

  CompanyMealDetailUiState _uiState = Initial();

  CompanyMealDetailUiState get uiState => _uiState;

  String? _currentSearchQuery;
  MealType _currentMealType = MealType.all;

  CompanyMealDetailViewModel(
    this._authTokenManager,
    this._getMealLogsUseCase,
  );

  void onEvent(CompanyMealDetailEvent event) {
    if (event is LoadMealLogs) {
      _currentSearchQuery = event.q;
      _currentMealType = event.mealType != null
          ? MealType.values.firstWhere((e) => e.toString() == 'MealType.${event.mealType!.toLowerCase()}')
          : MealType.all;

      _loadMealLogs(
        companyId: event.companyId,
        date: event.date,
        page: 1,
        isLoadMore: false,
      );
    } else if (event is LoadMoreMealLogs) {
      _loadMealLogs(
        companyId: event.companyId,
        date: event.date,
        page: event.page,
        isLoadMore: true,
      );
    }
  }

  Future<void> _loadMealLogs({
    required int companyId,
    required String date,
    required int page,
    bool isLoadMore = false,
  }) async {
    if (isLoadMore) {
      if (_uiState is Success) {
        _uiState = (_uiState as Success).copyWith(isLoadingMore: true);
        notifyListeners();
      }
    } else {
      _uiState = Loading();
      notifyListeners();
    }

    final String? restaurantId = _authTokenManager.getRestaurantId()?.toString();

    if (restaurantId == null) {
      _uiState = Error('Restaurant ID not found. Please log in again.');
      notifyListeners();
      return;
    }

    // Convert MealType enum to string expected by UseCase
    String mealTypeParam = _currentMealType == MealType.all
        ? 'ALL'
        : _currentMealType.toString().split('.').last.toUpperCase();

    final result = await _getMealLogsUseCase.execute(
      restaurantId: restaurantId,
      companyId: companyId.toString(),
      date: date,
      page: page,
      pageSize: 20,
      q: _currentSearchQuery,
      mealType: mealTypeParam,
    );

    result.when(
      success: (newMealLog) {
        if (isLoadMore && _uiState is Success) {
          final currentMealLog = (_uiState as Success).mealLog;
          final allItems = [...currentMealLog.items, ...newMealLog.items];
          final updatedMealLog = MealLog(
            date: newMealLog.date,
            company: newMealLog.company,
            totalCount: newMealLog.totalCount,
            items: allItems,
          );
          _uiState = Success(updatedMealLog, isLoadingMore: false);
        } else {
          _uiState = Success(newMealLog);
        }
        notifyListeners();
      },
      failure: (success, error) {
        if (isLoadMore && _uiState is Success) {
          _uiState = (_uiState as Success).copyWith(isLoadingMore: false);
        } else {
          _uiState = Error(error?['message'] ?? 'Unknown error');
        }
        notifyListeners();
      },
      error: (message) {
        if (isLoadMore && _uiState is Success) {
          _uiState = (_uiState as Success).copyWith(isLoadingMore: false);
        } else {
          _uiState = Error(message);
        }
        notifyListeners();
      },
    );
  }
}
