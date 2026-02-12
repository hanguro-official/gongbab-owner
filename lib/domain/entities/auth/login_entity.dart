import 'package:equatable/equatable.dart';
import 'package:gongbab_owner/domain/entities/auth/restaurant_entity.dart';

class LoginEntity extends Equatable {
  final String accessToken;
  final String refreshToken;
  final RestaurantEntity? restaurant;
  final String? kioskCode;

  const LoginEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.restaurant,
    this.kioskCode,
  });

  @override
  List<Object?> get props => [accessToken, refreshToken, restaurant, kioskCode];
}
