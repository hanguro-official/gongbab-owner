import 'package:gongbab_owner/domain/repositories/settlement_repository.dart';
import 'package:gongbab_owner/domain/utils/result.dart';

import '../entities/settlement/settlement.dart';

class GetSettlementsUseCase {
  final SettlementRepository _repository;

  GetSettlementsUseCase(this._repository);

  Future<Result<List<Settlement>>> execute() async {
    return _repository.getSettlements();
  }
}
