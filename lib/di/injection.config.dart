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
import '../data/network/api_service.dart' as _i589;
import '../data/network/app_api_client.dart' as _i133;
import '../data/network/auth_interceptor.dart' as _i803;
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
    gh.lazySingleton<_i702.AuthTokenManager>(
        () => _i702.AuthTokenManager(gh<_i460.SharedPreferences>()));
    gh.factory<_i803.AuthInterceptor>(() => _i803.AuthInterceptor(
          gh<_i702.AuthTokenManager>(),
          gh<_i361.Dio>(),
        ));
    gh.singleton<_i133.AppApiClient>(() => _i133.AppApiClient(
          gh<_i702.AuthTokenManager>(),
          gh<_i361.Dio>(),
        ));
    gh.singleton<_i589.ApiService>(
        () => _i589.ApiService(gh<_i133.AppApiClient>()));
    return this;
  }
}

class _$RegisterModule extends _i464.RegisterModule {}
