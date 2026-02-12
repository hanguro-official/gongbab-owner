import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:gongbab_owner/di/injection.config.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

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


  @lazySingleton // Provide Dio instance
  Dio get dio => Dio();
}