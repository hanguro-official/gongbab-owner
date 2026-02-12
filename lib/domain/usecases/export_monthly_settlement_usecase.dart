import 'dart:typed_data';

import 'package:gongbab_owner/domain/repositories/settlement_repository.dart';
import 'package:gongbab_owner/domain/utils/result.dart';
import 'package:injectable/injectable.dart';

@injectable
class ExportMonthlySettlementUseCase {
  final SettlementRepository _settlementRepository;

  ExportMonthlySettlementUseCase(this._settlementRepository);

  Future<Result<Uint8List>> execute({
    required String restaurantId,
    required String month,
  }) {
    return _settlementRepository.exportMonthlySettlement(
      restaurantId: restaurantId,
      month: month,
    );
  }
}
