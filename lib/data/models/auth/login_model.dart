import 'package:gongbab_owner/data/models/auth/restaurant_model.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/auth/login_entity.dart';

part 'login_model.g.dart';

@JsonSerializable()
class LoginModel {
  final String accessToken;
  final String refreshToken;
  final RestaurantModel? restaurant;
  final String? kioskCode;

  LoginModel({
    required this.accessToken,
    required this.refreshToken,
    this.restaurant,
    this.kioskCode,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => _$LoginModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginModelToJson(this);

  LoginEntity toEntity() {
    return LoginEntity(
      accessToken: accessToken,
      refreshToken: refreshToken,
      restaurant: restaurant?.toEntity(),
      kioskCode: kioskCode,
    );
  }
}
