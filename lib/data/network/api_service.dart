import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:gongbab_owner/data/models/daily_dashboard_model.dart';
import 'package:gongbab_owner/data/models/meal_log_model.dart';
import 'package:gongbab_owner/data/models/monthly_settlement_model.dart';
import 'package:gongbab_owner/data/network/rest_api_client.dart';
import 'package:injectable/injectable.dart';

import '../../domain/utils/result.dart';
import '../models/auth/login_model.dart';
import 'app_api_client.dart';

@singleton
class ApiService {
  final AppApiClient _appApiClient;

  ApiService(this._appApiClient);

  // ------------auth---------------------
  Future<Result<LoginModel>> login({
    required String code,
    required String deviceType,
    required String deviceId,
  }) async {
    return _appApiClient.request(
      method: RestMethod.post,
      path: '/api/v1/auth/login',
      data: {
        'code': code,
        'deviceType': deviceType,
        'deviceId': deviceId,
      },
      fromJson: LoginModel.fromJson,
    );
  }

  // ------------------------------------

  // ------------dashboard---------------------
  Future<Result<DailyDashboardModel>> getDailyDashboard({
    required String restaurantId,
    required String date,
  }) async {
    return _appApiClient.request(
      method: RestMethod.get,
      path: '/api/v1/restaurants/$restaurantId/dashboard/daily',
      queryParameters: {
        'date': date,
      },
      fromJson: DailyDashboardModel.fromJson,
    );
  }

  // ------------meal-logs---------------------
  Future<Result<MealLogModel>> getMealLogs({
    required String restaurantId,
    required String companyId,
    required String date,
    required String mealType,
    String? q,
    int page = 1,
    int pageSize = 20,
  }) async {
    return _appApiClient.request(
      method: RestMethod.get,
      path: '/api/v1/restaurants/$restaurantId/companies/$companyId/meal-logs',
      queryParameters: {
        'date': date,
        'mealType': mealType,
        'q': q,
        'page': page,
        'pageSize': pageSize,
      },
      fromJson: MealLogModel.fromJson,
    );
  }

  // ------------settlements---------------------
  Future<Result<MonthlySettlementModel>> getMonthlySettlement({
    required String restaurantId,
    required String month,
  }) async {
    return _appApiClient.request(
      method: RestMethod.get,
      path: '/api/v1/restaurants/$restaurantId/settlements/monthly',
      queryParameters: {
        'month': month,
      },
      fromJson: MonthlySettlementModel.fromJson,
    );
  }

  Future<Result<Uint8List>> exportMonthlySettlement({
    required String restaurantId,
    required String month,
  }) async {
    return _appApiClient.requestBytes(
      method: RestMethod.get,
      path: '/api/v1/restaurants/$restaurantId/settlements/monthly/export',
      queryParameters: {
        'month': month,
      },
    );
  }
}
