import 'package:gongbab_owner/data/network/api_service.dart';
import 'package:gongbab_owner/domain/entities/auth/login_entity.dart'; // Import new entity
import 'package:gongbab_owner/domain/repositories/auth_repository.dart';
import 'package:gongbab_owner/domain/utils/result.dart';
import 'package:injectable/injectable.dart'; // injectable 임포트

@LazySingleton(as: AuthRepository) // AuthRepository 인터페이스의 구현체로 지연 로딩 싱글톤 등록
class AuthRepositoryImpl implements AuthRepository { // AuthRepository 인터페이스 구현
  final ApiService _apiService;

  AuthRepositoryImpl(this._apiService);

  @override
  Future<Result<LoginEntity>> login({
    required String code,
    required String deviceType,
    required String deviceId,
  }) async {
    final result = await _apiService.login(
      code: code,
      deviceType: deviceType,
      deviceId: deviceId,
    );
    return result.when(
      success: (model) => Result.success(model.toEntity()),
      failure: (success, error) => Result.failure(success, error),
      error: (error) => Result.error(error),
    );
  }
}
