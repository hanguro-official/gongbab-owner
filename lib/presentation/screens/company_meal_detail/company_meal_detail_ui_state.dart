import 'package:gongbab_owner/domain/entities/meal_log/meal_log.dart';

abstract class CompanyMealDetailUiState {}

class Initial extends CompanyMealDetailUiState {}

class Loading extends CompanyMealDetailUiState {}

class Success extends CompanyMealDetailUiState {
  final MealLog mealLog;
  final bool isLoadingMore;

  Success(this.mealLog, {this.isLoadingMore = false});

  Success copyWith({
    MealLog? mealLog,
    bool? isLoadingMore,
  }) {
    return Success(
      mealLog ?? this.mealLog,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class Error extends CompanyMealDetailUiState {
  final String message;

  Error(this.message);
}
