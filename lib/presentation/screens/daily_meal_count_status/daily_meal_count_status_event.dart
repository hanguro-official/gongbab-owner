abstract class DailyMealCountStatusEvent {
  const DailyMealCountStatusEvent();
}

class LoadDailyDashboard extends DailyMealCountStatusEvent {
  final String restaurantId;
  final String date;

  const LoadDailyDashboard({
    required this.restaurantId,
    required this.date,
  });
}
