import 'package:json_annotation/json_annotation.dart';

part 'common_model.g.dart';

@JsonSerializable()
class CommonModel {
  final bool success;
  final Map<String, dynamic> error;

  CommonModel({
    required this.success,
    required this.error,
  });

  factory CommonModel.fromJson(Map<String, dynamic> json) => _$CommonModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommonModelToJson(this);
}
