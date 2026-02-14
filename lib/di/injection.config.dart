// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../data/auth/auth_token_manager.dart' as _i702;
import '../data/device/device_info_service.dart' as _i120;
import '../data/network/api_service.dart' as _i589;
import '../data/network/app_api_client.dart' as _i133;
import '../data/network/auth_interceptor.dart' as _i803;
import '../data/repositories/auth_repository_impl.dart' as _i74;
import '../data/repositories/dashboard_repository_impl.dart' as _i585;
import '../data/repositories/meal_log_repository_impl.dart' as _i516;
import '../data/repositories/settlement_repository_impl.dart' as _i916;
import '../domain/repositories/auth_repository.dart' as _i800;
import '../domain/repositories/dashboard_repository.dart' as _i525;
import '../domain/repositories/meal_log_repository.dart' as _i637;
import '../domain/repositories/settlement_repository.dart' as _i85;
import '../domain/usecases/export_monthly_settlement_usecase.dart' as _i801;
import '../domain/usecases/get_daily_dashboard_usecase.dart' as _i413;
import '../domain/usecases/get_meal_logs_usecase.dart' as _i865;
import '../domain/usecases/get_monthly_settlement_usecase.dart' as _i351;
import '../domain/usecases/login_usecase.dart' as _i634;
import '../presentation/router/app_router.dart' as _i223;
import '../presentation/screens/company_meal_detail/company_meal_detail_view_model.dart'
    as _i23;
import '../presentation/screens/daily_meal_count_status/daily_meal_count_status_view_model.dart'
    as _i395;
import '../presentation/screens/login/login_view_model.dart' as _i568;
import '../presentation/screens/monthly_settlement/monthly_settlement_view_model.dart'
    as _i234;
import 'injection.dart' as _i464;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i120.DeviceInfoService>(() => _i120.DeviceInfoService());
    gh.lazySingleton<_i702.AuthTokenManager>(
        () => _i702.AuthTokenManager(gh<_i460.SharedPreferences>()));
    gh.factory<_i803.AuthInterceptor>(() => _i803.AuthInterceptor(
          gh<_i702.AuthTokenManager>(),
          gh<_i361.Dio>(),
        ));
    gh.singleton<_i223.AppRouter>(
        () => _i223.AppRouter(gh<_i702.AuthTokenManager>()));
    gh.singleton<_i133.AppApiClient>(() => _i133.AppApiClient(
          gh<_i702.AuthTokenManager>(),
          gh<_i361.Dio>(),
        ));
    gh.singleton<_i589.ApiService>(
        () => _i589.ApiService(gh<_i133.AppApiClient>()));
    gh.factory<_i637.MealLogRepository>(
        () => _i516.MealLogRepositoryImpl(gh<_i589.ApiService>()));
    gh.factory<_i525.DashboardRepository>(
        () => _i585.DashboardRepositoryImpl(gh<_i589.ApiService>()));
    gh.factory<_i85.SettlementRepository>(
        () => _i916.SettlementRepositoryImpl(gh<_i589.ApiService>()));
    gh.lazySingleton<_i413.GetDailyDashboardUseCase>(() => registerModule
        .getDailyDashboardUseCase(gh<_i525.DashboardRepository>()));
    gh.lazySingleton<_i800.AuthRepository>(
        () => _i74.AuthRepositoryImpl(gh<_i589.ApiService>()));
    gh.lazySingleton<_i351.GetMonthlySettlementUseCase>(() => registerModule
        .getMonthlySettlementUseCase(gh<_i85.SettlementRepository>()));
    gh.lazySingleton<_i801.ExportMonthlySettlementUseCase>(() => registerModule
        .exportMonthlySettlementUseCase(gh<_i85.SettlementRepository>()));
    gh.lazySingleton<_i634.LoginUseCase>(() => registerModule.loginUseCase(
          gh<_i800.AuthRepository>(),
          gh<_i702.AuthTokenManager>(),
        ));
    gh.factory<_i234.MonthlySettlementViewModel>(
        () => _i234.MonthlySettlementViewModel(
              gh<_i702.AuthTokenManager>(),
              gh<_i351.GetMonthlySettlementUseCase>(),
              gh<_i801.ExportMonthlySettlementUseCase>(),
            ));
    gh.factory<_i568.LoginViewModel>(() => _i568.LoginViewModel(
          gh<_i634.LoginUseCase>(),
          gh<_i702.AuthTokenManager>(),
          gh<_i120.DeviceInfoService>(),
        ));
    gh.lazySingleton<_i865.GetMealLogsUseCase>(
        () => registerModule.getMealLogsUseCase(gh<_i637.MealLogRepository>()));
    gh.factory<_i395.DailyMealCountStatusViewModel>(
        () => _i395.DailyMealCountStatusViewModel(
              gh<_i702.AuthTokenManager>(),
              gh<_i413.GetDailyDashboardUseCase>(),
            ));
    gh.factory<_i23.CompanyMealDetailViewModel>(
        () => _i23.CompanyMealDetailViewModel(
              gh<_i702.AuthTokenManager>(),
              gh<_i865.GetMealLogsUseCase>(),
            ));
    return this;
  }
}

class _$RegisterModule extends _i464.RegisterModule {}
