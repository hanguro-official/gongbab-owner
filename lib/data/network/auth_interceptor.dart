import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../auth/auth_token_manager.dart';
import '../models/auth/login_model.dart';

@injectable
class AuthInterceptor extends Interceptor {
  final AuthTokenManager _authTokenManager;
  final Dio _dio;

  AuthInterceptor(this._authTokenManager, this._dio);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final accessToken = _authTokenManager.getAccessToken();
    if (accessToken != null && !options.path.contains('/auth/refresh')) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;

    // If the refresh token request itself failed and if it's a 401 (refresh token invalid)
    if (err.requestOptions.path.contains('/auth/refresh') &&
        statusCode == 401) {
      await _authTokenManager.clearTokens();
      return handler
          .next(err); // Propagate the error, router will handle navigation
    }

    // Handle 401 (access token invalid)
    if (statusCode == 401) {
      try {
        final refreshToken = _authTokenManager.getRefreshToken();
        if (refreshToken == null) {
          await _authTokenManager.clearTokens();
          return handler.next(err); // No refresh token, propagate error
        }

        // Attempt to refresh token
        final response = await _dio.post(
          '/api/v1/auth/refresh',
          data: {'refreshToken': refreshToken},
        );

        final loginModel = LoginModel.fromJson(response.data);

        await _authTokenManager.saveTokens(
          loginModel.accessToken,
          loginModel.refreshToken,
        );

        // Retry the original request with new access token
        final newAccessToken = _authTokenManager.getAccessToken();
        err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

        // Create a new request with the updated headers
        final retryResponse = await _dio.fetch(err.requestOptions);
        handler.resolve(retryResponse); // Resolve with the new response
      } catch (e) {
        // If refresh fails for any reason, clear tokens and propagate original error
        await _authTokenManager.clearTokens();
        handler.next(err);
      }
    } else {
      super.onError(err, handler); // For other errors, just pass them through
    }
  }
}
