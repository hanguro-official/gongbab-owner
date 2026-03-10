import 'package:gongbab_owner/domain/entities/settlement/settlement.dart';
import 'package:gongbab_owner/domain/repositories/settlement_repository.dart';
import 'package:gongbab_owner/domain/utils/result.dart';

class ConfirmSettlementUseCase {
  final SettlementRepository _repository;

  ConfirmSettlementUseCase(this._repository);

  Future<Result<Settlement>> execute({
    required int id,
  }) async {
    return _repository.confirmSettlement(id: id);
  }
}
