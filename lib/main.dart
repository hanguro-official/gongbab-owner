import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gongbab_owner/presentation/router/app_router.dart';

import 'di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = getIt<AppRouter>().router;
    return ScreenUtilInit(
      designSize: const Size(360, 690), // 디자인 시안의 가로, 세로 크기
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          routerConfig: router,
          title: 'Gongbab Owner',
          theme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: const Color(0xFF1a1f2e),
            scaffoldBackgroundColor: const Color(0xFF1a1f2e),
            fontFamily: 'Pretendard', //
          ),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}