abstract class MonthlySettlementEvent {}

class LoadMonthlySettlement extends MonthlySettlementEvent {
  final String month;

  LoadMonthlySettlement({required this.month});
}

class ExportMonthlySettlement extends MonthlySettlementEvent {
  final String month;

  ExportMonthlySettlement({required this.month});
}
