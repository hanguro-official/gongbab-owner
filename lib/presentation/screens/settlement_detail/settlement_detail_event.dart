sealed class SettlementDetailEvent {
  const SettlementDetailEvent();
}

class LoadSettlementDetail extends SettlementDetailEvent {
  final int year;
  final int month;

  const LoadSettlementDetail({required this.year, required this.month});
}

class ConfirmSettlement extends SettlementDetailEvent {
  final int id;

  const ConfirmSettlement(this.id);
}
