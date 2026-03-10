import 'dart:typed_data';

import 'package:gongbab_owner/domain/entities/settlement/monthly_settlement.dart';
import 'package:gongbab_owner/domain/entities/settlement/settlement.dart';
import 'package:gongbab_owner/domain/utils/result.dart';

abstract class SettlementRepository {
  Future<Result<List<Settlement>>> getSettlements();

  Future<Result<Settlement>> createSettlement({
    required int year,
    required int month,
    required List<Map<String, dynamic>> items,
  });

  Future<Result<Settlement>> getSettlementDetail({
    required int year,
    required int month,
  });

  Future<Result<Settlement>> confirmSettlement({
    required int id,
  });

  Future<Result<MonthlySettlement>> getMonthlySettlement({
    required String restaurantId,
    required String month,
  });

  Future<Result<Uint8List>> exportMonthlySettlement({
    required String restaurantId,
    required String month,
  });
}
