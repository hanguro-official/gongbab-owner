import 'dart:typed_data';

import 'package:gongbab_owner/domain/entities/settlement/monthly_settlement.dart';
import 'package:gongbab_owner/domain/utils/result.dart';

abstract class SettlementRepository {
  Future<Result<MonthlySettlement>> getMonthlySettlement({
    required String restaurantId,
    required String month,
  });

  Future<Result<Uint8List>> exportMonthlySettlement({
    required String restaurantId,
    required String month,
  });
}
