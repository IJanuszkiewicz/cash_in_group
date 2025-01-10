import 'package:cash_in_group/core/model.dart';

class Group implements Model<Group> {
  final String id;
  final String name;

  Group({
    required this.id,
    required this.name,
  });

  @override
  Group fromJson(Map<String, Object> json) {
    return Group(id: json['id'] as String, name: json['name'] as String);
  }

  @override
  Map<String, Object> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
