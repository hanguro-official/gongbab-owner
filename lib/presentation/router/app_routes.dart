part of 'app_router.dart';

abstract class AppRoutes {
  static const String login = '/login';
  static const String dailyMealCountStatus = '/daily_meal_count_status';
  static const String companyMealDetail =
      '/company_meal_detail/:companyId/:companyName/:selectedDate';
  static const String monthlySettlement = '/monthly_settlement';
  static const String settlementManagement = '/settlement_management';
  static const String settlementRegister = '/settlement_register';
  static const String settlementDetail = '/settlement_detail/:year/:month';
  // Add other routes here
}