import 'package:gongbab_owner/domain/entities/settlement/settlement.dart';

sealed class SettlementDetailUiState {
  const SettlementDetailUiState();
}

class SettlementDetailInitial extends SettlementDetailUiState {
  const SettlementDetailInitial();
}

class SettlementDetailLoading extends SettlementDetailUiState {
  const SettlementDetailLoading();
}

class SettlementDetailSuccess extends SettlementDetailUiState {
  final Settlement settlement;

  const SettlementDetailSuccess(this.settlement);
}

class SettlementDetailError extends SettlementDetailUiState {
  final String message;

  const SettlementDetailError(this.message);
}
