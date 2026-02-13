import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../data/auth/auth_token_manager.dart';
import '../../../data/device/device_info_service.dart';
import '../../../domain/usecases/login_usecase.dart';
import 'login_event.dart';
import 'login_ui_state.dart';

@injectable
class LoginViewModel extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final AuthTokenManager _authTokenManager;
  final DeviceInfoService _deviceInfoService;

  LoginUiState _uiState = Initial();

  LoginUiState get uiState => _uiState;

  LoginViewModel(this._loginUseCase, this._authTokenManager, this._deviceInfoService);

  Future<void> onEvent(LoginEvent event) async {
    if (event is LoginButtonPressed) {
      _uiState = Loading();
      notifyListeners();

      final deviceId = await _deviceInfoService.getDeviceId();

      final result = await _loginUseCase.execute(
        code: event.code.toUpperCase(),
        deviceType: 'OWNER_APP',
        deviceId: deviceId,
      );

      result.when(
        success: (loginEntity) async {
          if (loginEntity.restaurant != null) {
            await _authTokenManager.saveRestaurantInfo(
              loginEntity.restaurant!.id,
              loginEntity.kioskCode ?? 'UNDEFINED_KIOSK_CODE',
            );
          }
          _uiState = Success(loginEntity);
          notifyListeners();
        },
        failure: (bool success, Map<String, dynamic>? error) {
          final errorCode = error?['code'] as String?;

          if (errorCode == 'VALIDATION_ERROR') {
            _uiState = Failure(ShowAlertDialog( // Changed to Failure
              title: '로그인 실패',
              content: '코드 형식이 올바르지 않습니다',
              rightButtonText: '확인',
              onRightButtonPressed: () {}, // Handled by screen to pop
            ));
          } else if (errorCode == 'INVALID_ADMIN_CODE') {
            _uiState = Failure(ShowAlertDialog( // Changed to Failure
              title: '로그인 실패',
              content: '관리자 코드를 확인한 후 다시 로그인해주세요',
              rightButtonText: '확인',
              onRightButtonPressed: () {}, // Handled by screen to pop
            ));
          } else {
            _uiState = Failure(ShowAlertDialog( // Changed to Failure
              title: '로그인 실패',
              content: '알 수 없는 오류가 발생했습니다.', // Use errorMessage
              rightButtonText: '확인',
              onRightButtonPressed: () {}, // Handled by screen to pop
            ));
          }
          notifyListeners();
        },
        error: (message) {
          _uiState = GeneralError(ShowSnackBar(message: message)); // Changed to GeneralError
          notifyListeners();
        },
      );
    }
  }

  void resetState() {
    _uiState = Initial();
    notifyListeners();
  }
}

