import 'package:gongbab_owner/domain/entities/settlement/monthly_settlement.dart';
import 'package:gongbab_owner/domain/repositories/settlement_repository.dart';
import 'package:gongbab_owner/domain/utils/result.dart';

class GetMonthlySettlementUseCase {
  final SettlementRepository _settlementRepository;

  GetMonthlySettlementUseCase(this._settlementRepository);

  Future<Result<MonthlySettlement>> execute({
    required String restaurantId,
    required String month,
  }) {
    return _settlementRepository.getMonthlySettlement(
      restaurantId: restaurantId,
      month: month,
    );
  }
}
