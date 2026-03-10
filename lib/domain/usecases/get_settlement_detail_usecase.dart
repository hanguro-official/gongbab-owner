import 'package:gongbab_owner/domain/repositories/settlement_repository.dart';
import 'package:gongbab_owner/domain/utils/result.dart';

import '../entities/settlement/settlement.dart';

class GetSettlementDetailUseCase {
  final SettlementRepository _repository;

  GetSettlementDetailUseCase(this._repository);

  Future<Result<Settlement>> execute({
    required int year,
    required int month,
  }) async {
    return _repository.getSettlementDetail(year: year, month: month);
  }
}
