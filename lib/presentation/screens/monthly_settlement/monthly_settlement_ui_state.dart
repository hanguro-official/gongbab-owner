import 'package:gongbab_owner/domain/entities/settlement/monthly_settlement.dart';

abstract class MonthlySettlementUiState {}

class Initial extends MonthlySettlementUiState {}

class Loading extends MonthlySettlementUiState {}

class Success extends MonthlySettlementUiState {
  final MonthlySettlement monthlySettlement;

  Success(this.monthlySettlement);
}

class Exporting extends MonthlySettlementUiState {
  final MonthlySettlement monthlySettlement;

  Exporting(this.monthlySettlement);
}

class ExportSuccess extends MonthlySettlementUiState {
  final String message;
  final MonthlySettlement monthlySettlement;

  ExportSuccess(this.message, this.monthlySettlement);
}

class ExportError extends MonthlySettlementUiState {
  final String message;
  final MonthlySettlement monthlySettlement;

  ExportError(this.message, this.monthlySettlement);
}

class Error extends MonthlySettlementUiState {
  final String message;

  Error(this.message);
}