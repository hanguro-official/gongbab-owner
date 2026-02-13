abstract class DailyMealCountStatusEvent {
  const DailyMealCountStatusEvent();
}

class LoadDailyDashboard extends DailyMealCountStatusEvent {
  final String date;

  const LoadDailyDashboard({
    required this.date,
  });
}
