import 'dart:typed_data';

import 'package:gongbab_owner/data/network/api_service.dart';
import 'package:gongbab_owner/domain/entities/settlement/monthly_settlement.dart';
import 'package:gongbab_owner/domain/repositories/settlement_repository.dart';
import 'package:gongbab_owner/domain/utils/result.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: SettlementRepository)
class SettlementRepositoryImpl implements SettlementRepository {
  final ApiService _apiService;

  SettlementRepositoryImpl(this._apiService);

  @override
  Future<Result<MonthlySettlement>> getMonthlySettlement({
    required String restaurantId,
    required String month,
  }) async {
    final result = await _apiService.getMonthlySettlement(
        restaurantId: restaurantId, month: month);
    return result.when(
      success: (model) => Success(model.toDomain()),
      failure: (success, error) => Failure(success, error),
      error: (error) => Error(error),
    );
  }

  @override
  Future<Result<Uint8List>> exportMonthlySettlement({
    required String restaurantId,
    required String month,
  }) async {
    final result = await _apiService.exportMonthlySettlement(
        restaurantId: restaurantId, month: month);
    return result.when(
      success: (data) => Success(data),
      failure: (success, error) => Failure(success, error),
      error: (error) => Error(error),
    );
  }
}
