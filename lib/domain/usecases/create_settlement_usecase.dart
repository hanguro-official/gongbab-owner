import 'package:gongbab_owner/domain/entities/settlement/settlement.dart';
import 'package:gongbab_owner/domain/repositories/settlement_repository.dart';
import 'package:gongbab_owner/domain/utils/result.dart';

class CreateSettlementUseCase {
  final SettlementRepository _repository;

  CreateSettlementUseCase(this._repository);

  Future<Result<Settlement>> execute({
    required int year,
    required int month,
    required List<Map<String, dynamic>> items,
  }) async {
    return _repository.createSettlement(
      year: year,
      month: month,
      items: items,
    );
  }
}
