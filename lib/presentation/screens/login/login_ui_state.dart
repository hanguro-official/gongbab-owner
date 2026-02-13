
import '../../../domain/entities/auth/login_entity.dart';
import 'login_event.dart';

abstract class LoginUiState {}

class Initial extends LoginUiState {}

class Loading extends LoginUiState {}

class Success extends LoginUiState {
  final LoginEntity loginEntity;

  Success(this.loginEntity);
}

// Represents business logic failures (e.g., INVALID_ADMIN_CODE)
class Failure extends LoginUiState {
  final LoginEvent event; // Holds ShowAlertDialog

  Failure(this.event);
}

// Represents general system/network errors
class GeneralError extends LoginUiState {
  final LoginEvent event; // Holds ShowSnackBar

  GeneralError(this.event);
}