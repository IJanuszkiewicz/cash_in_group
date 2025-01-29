import 'package:cash_in_group/core/model.dart';

class User extends Model<User> {
  User(this.name, this.id);

  final String name;
  final String id;

  @override
  User fromJson(Map<String, Object> json) {
    return User(
      json['name'] as String,
      json['id'] as String,
    );
  }

  @override
  Map<String, Object> toJson() {
    return {
      'name': name,
      'id': id,
    };
  }
}
