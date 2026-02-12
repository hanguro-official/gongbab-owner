import 'package:json_annotation/json_annotation.dart';

part 'common_model.g.dart';

@JsonSerializable()
class CommonModel {
  final String success;
  final Map<String, dynamic> data;

  CommonModel({
    required this.success,
    required this.data,
  });

  factory CommonModel.fromJson(Map<String, dynamic> json) => _$CommonModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommonModelToJson(this);
}
