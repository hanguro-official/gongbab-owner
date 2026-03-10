import 'dart:typed_data';

import 'package:gongbab_owner/data/models/settlement_model.dart';
import 'package:gongbab_owner/data/models/settlement_request_model.dart';
import 'package:gongbab_owner/data/network/api_service.dart';
import 'package:gongbab_owner/domain/entities/settlement/monthly_settlement.dart';
import 'package:gongbab_owner/domain/entities/settlement/settlement.dart';
import 'package:gongbab_owner/domain/repositories/settlement_repository.dart';
import 'package:gongbab_owner/domain/utils/result.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: SettlementRepository)
class SettlementRepositoryImpl implements SettlementRepository {
  final ApiService _apiService;

  SettlementRepositoryImpl(this._apiService);

  @override
  Future<Result<List<Settlement>>> getSettlements() async {
    final result = await _apiService.getSettlements();
    return result.when(
      success: (model) => Success(
        model.settlements.map((e) => e.toDomain()).toList(),
      ),
      failure: (success, error) => Failure(success, error),
      error: (error) => Error(error),
    );
  }

  @override
  Future<Result<Settlement>> createSettlement({
    required int year,
    required int month,
    required List<Map<String, dynamic>> items,
  }) async {
    final request = SettlementCreateRequestModel(
      year: year,
      month: month,
      items: items
          .map((e) => SettlementCreateRequestItemModel.fromJson(e))
          .toList(),
    );
    final result = await _apiService.createSettlement(request: request);
    return result.when(
      success: (model) => Success(model.toDomain()),
      failure: (success, error) => Failure(success, error),
      error: (error) => Error(error),
    );
  }

  @override
  Future<Result<Settlement>> getSettlementDetail({
    required int year,
    required int month,
  }) async {
    final result = await _apiService.getSettlementDetail(year: year, month: month);
    return result.when(
      success: (model) => Success(model.toDomain()),
      failure: (success, error) => Failure(success, error),
      error: (error) => Error(error),
    );
  }

  @override
  Future<Result<Settlement>> confirmSettlement({
    required int id,
  }) async {
    final result = await _apiService.confirmSettlement(id: id);
    return result.when(
      success: (model) => Success(model.toDomain()),
      failure: (success, error) => Failure(success, error),
      error: (error) => Error(error),
    );
  }

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
