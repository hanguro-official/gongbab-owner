import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gongbab_owner/presentation/screens/company_meal_detail/company_meal_detail_screen.dart';
import 'package:gongbab_owner/presentation/screens/daily_meal_count_status/daily_meal_count_status_screen.dart';
import 'package:gongbab_owner/presentation/screens/login/login_screen.dart';
import 'package:gongbab_owner/presentation/screens/monthly_settlement/monthly_settlement_screen.dart';
import 'package:injectable/injectable.dart';

import '../../data/auth/auth_token_manager.dart';

part 'app_routes.dart';

@singleton
class AppRouter {
  final AuthTokenManager _authTokenManager;
  late final GoRouter router;

  AppRouter(this._authTokenManager) {
    router = GoRouter(
      initialLocation: AppRoutes.login,
      routes: <RouteBase>[
        GoRoute(
          path: AppRoutes.login,
          builder: (BuildContext context, GoRouterState state) {
            return const LoginScreen();
          },
        ),
        GoRoute(
          path: AppRoutes.dailyMealCountStatus,
          builder: (BuildContext context, GoRouterState state) {
            return const DailyMealCountStatusScreen();
          },
        ),
        GoRoute(
          path: AppRoutes.companyMealDetail,
          builder: (BuildContext context, GoRouterState state) {
            return CompanyMealDetailScreen(
              companyName: state.pathParameters['companyName'] ?? '',
              selectedDate: state.pathParameters['email'] as DateTime? ?? DateTime.now(),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.monthlySettlement,
          builder: (BuildContext context, GoRouterState state) {
            return const MonthlySettlementScreen();
          },
        ),
      ],
      redirect: (BuildContext context, GoRouterState state) => redirectLogic(context, state),
    );
  }

  @visibleForTesting // Make it visible for testing
  String? redirectLogic(BuildContext context, GoRouterState state) {
    final accessToken = _authTokenManager.getAccessToken();
    final refreshToken = _authTokenManager.getRefreshToken();

    final loggedIn = accessToken != null && refreshToken != null;
    final goingToLogin = state.matchedLocation == AppRoutes.login;

    if (!loggedIn && !goingToLogin) {
      return AppRoutes.login;
    }
    if (loggedIn && goingToLogin) {
      return AppRoutes.dailyMealCountStatus;
    }
    return null;
  }
}