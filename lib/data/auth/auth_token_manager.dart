import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class AuthTokenManager {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _restaurantIdKey = 'restaurant_id';
  static const String _kioskCodeKey = 'kiosk_code';

  final SharedPreferences _sharedPreferences;

  AuthTokenManager(this._sharedPreferences);

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _sharedPreferences.setString(_accessTokenKey, accessToken);
    await _sharedPreferences.setString(_refreshTokenKey, refreshToken);
  }

  Future<void> saveRestaurantInfo(int restaurantId, String kioskCode) async {
    await _sharedPreferences.setInt(_restaurantIdKey, restaurantId);
    await _sharedPreferences.setString(_kioskCodeKey, kioskCode);
  }

  String? getAccessToken() {
    return _sharedPreferences.getString(_accessTokenKey);
  }

  String? getRefreshToken() {
    return _sharedPreferences.getString(_refreshTokenKey);
  }

  int? getRestaurantId() {
    return _sharedPreferences.getInt(_restaurantIdKey);
  }

  String? getKioskCode() {
    return _sharedPreferences.getString(_kioskCodeKey);
  }

  Future<void> clearTokens() async {
    await _sharedPreferences.remove(_accessTokenKey);
    await _sharedPreferences.remove(_refreshTokenKey);
    await _sharedPreferences.remove(_restaurantIdKey);
    await _sharedPreferences.remove(_kioskCodeKey);
  }
}
