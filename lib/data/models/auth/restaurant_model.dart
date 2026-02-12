import 'package:json_annotation/json_annotation.dart';
import 'package:gongbab_owner/domain/entities/auth/restaurant_entity.dart';

part 'restaurant_model.g.dart';

@JsonSerializable()
class RestaurantModel {
  final int id;
  final String name;

  RestaurantModel({
    required this.id,
    required this.name,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) => _$RestaurantModelFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantModelToJson(this);

  RestaurantEntity toEntity() {
    return RestaurantEntity(
      id: id,
      name: name,
    );
  }
}
