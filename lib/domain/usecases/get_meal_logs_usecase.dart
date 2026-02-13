import 'package:gongbab_owner/domain/entities/meal_log/meal_log.dart';
import 'package:gongbab_owner/domain/repositories/meal_log_repository.dart';
import 'package:gongbab_owner/domain/utils/result.dart';

class GetMealLogsUseCase {
  final MealLogRepository _mealLogRepository;

  GetMealLogsUseCase(this._mealLogRepository);

  Future<Result<MealLog>> execute({
    required String restaurantId,
    required String companyId,
    required String date,
    String mealType = 'ALL',
    String? q,
    int page = 1,
    int pageSize = 20,
  }) {
    return _mealLogRepository.getMealLogs(
      restaurantId: restaurantId,
      companyId: companyId,
      date: date,
      mealType: mealType,
      q: q,
      page: page,
      pageSize: pageSize,
    );
  }
}
