import 'package:cash_in_group/core/model.dart';

class User extends Model<User> {
  User(this.name, this.id);

  final String name;
  final String id;

  @override
  User fromJson(Map<String, Object> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  Map<String, Object> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
