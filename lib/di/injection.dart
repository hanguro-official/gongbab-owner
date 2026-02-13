import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:gongbab_owner/di/injection.config.dart';
import 'package:gongbab_owner/domain/repositories/dashboard_repository.dart';
import 'package:gongbab_owner/domain/usecases/get_daily_dashboard_usecase.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/auth/auth_token_manager.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/login_usecase.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
Future<void> configureDependencies() async {
  await getIt.init();
}

@module
abstract class RegisterModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @lazySingleton
  LoginUseCase loginUseCase(AuthRepository repository, AuthTokenManager authTokenManager) {
    return LoginUseCase(repository, authTokenManager);
  }

  @lazySingleton
  GetDailyDashboardUseCase getDailyDashboardUseCase(DashboardRepository repository) {
    return GetDailyDashboardUseCase(repository);
  }

  @lazySingleton // Provide Dio instance
  Dio get dio => Dio();
}