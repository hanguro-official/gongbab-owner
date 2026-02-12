import 'package:equatable/equatable.dart';

class RestaurantEntity extends Equatable {
  final int id;
  final String name;

  const RestaurantEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
