import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gongbab_owner/presentation/screens/company_meal_detail/company_meal_detail_screen.dart';
import 'package:gongbab_owner/presentation/screens/daily_meal_count_status/daily_meal_count_status_screen.dart';
import 'package:gongbab_owner/presentation/screens/login/login_screen.dart';
import 'package:gongbab_owner/presentation/screens/monthly_settlement/monthly_settlement_screen.dart';
import 'package:gongbab_owner/presentation/screens/settlement_detail/settlement_detail_screen.dart';
import 'package:gongbab_owner/presentation/screens/settlement_management/settlement_management_screen.dart';
import 'package:gongbab_owner/presentation/screens/settlement_register/settlement_register_screen.dart';
import 'package:injectable/injectable.dart';

import '../../data/auth/auth_token_manager.dart';

part 'app_routes.dart';

@singleton
class AppRouter {
  final AuthTokenManager _authTokenManager;
  late final GoRouter router;

  AppRouter(this._authTokenManager) {
    router = GoRouter(
      refreshListenable: _authTokenManager,
      routes: <RouteBase>[
        GoRoute(
          path: AppRoutes.login,
          builder: (BuildContext context, GoRouterState state) {
            return const PopScope(
              canPop: false, // Prevent system back for login screen
              child: LoginScreen(),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.dailyMealCountStatus,
          builder: (BuildContext context, GoRouterState state) {
            return const PopScope(
              canPop: false, // Prevent system back for main dashboard
              child: DailyMealCountStatusScreen(),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.companyMealDetail,
          builder: (BuildContext context, GoRouterState state) {
            final companyId =
                int.tryParse(state.pathParameters['companyId'] ?? '');
            final companyName = state.pathParameters['companyName'];
            final selectedDate =
                DateTime.tryParse(state.pathParameters['selectedDate'] ?? '');

            if (companyId == null ||
                companyName == null ||
                selectedDate == null) {
              // This is a failsafe. In a real app, you might want a dedicated error screen.
              return const Scaffold(
                body: Center(
                  child: Text('Error: Missing route parameters.'),
                ),
              );
            }

            return PopScope(
              canPop: false, // Prevent system back for detail screen
              child: CompanyMealDetailScreen(
                companyId: companyId,
                companyName: companyName,
                selectedDate: selectedDate,
              ),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.monthlySettlement,
          builder: (BuildContext context, GoRouterState state) {
            return const PopScope(
              canPop: false, // Prevent system back for settlement screen
              child: MonthlySettlementScreen(),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.settlementManagement,
          builder: (BuildContext context, GoRouterState state) {
            return const PopScope(
              canPop: false, // Prevent system back for settlement screen
              child: SettlementManagementScreen(),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.settlementDetail,
          builder: (BuildContext context, GoRouterState state) {
            final year = int.tryParse(state.pathParameters['year'] ?? '');
            final month = int.tryParse(state.pathParameters['month'] ?? '');

            if (year == null || month == null) {
              // This is a failsafe. In a real app, you might want a dedicated error screen.
              return const Scaffold(
                body: Center(
                  child: Text('Error: Missing route parameters.'),
                ),
              );
            }

            return PopScope(
              canPop: false, // Prevent system back for settlement screen
              child: SettlementDetailScreen(year: year, month: month),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.settlementRegister,
          builder: (BuildContext context, GoRouterState state) {
            return const PopScope(
              canPop: false, // Prevent system back for settlement screen
              child: SettlementRegisterScreen(),
            );
          },
        ),
      ],
      redirect: (BuildContext context, GoRouterState state) =>
          redirectLogic(context, state),
    );
  }

  @visibleForTesting // Make it visible for testing
  String? redirectLogic(BuildContext context, GoRouterState state) {
    final loggedIn = _authTokenManager.getAccessToken() != null &&
        _authTokenManager.getRefreshToken() != null;
    final loggingIn = state.matchedLocation == AppRoutes.login;
    final currentPath = state.matchedLocation; // Get the current path

    // if the user is not logged in, they need to login
    if (!loggedIn) {
      return loggingIn ? null : AppRoutes.login;
    }

    // if the user is logged in but still on the login page, send them to
    // the home page
    if (loggingIn) {
      return AppRoutes.dailyMealCountStatus;
    }

    // If logged in and not on the login page, and the token was just refreshed,
    // we want to stay on the current page.
    // This is the crucial part to prevent unwanted navigation after a successful refresh.
    if (loggedIn && !loggingIn) {
      return currentPath; // Stay on the current path
    }

    // Fallback: no need to redirect at all (should ideally not be reached with the above logic)
    return null;
  }
}
