class User {
  User({required this.name, required this.id, required this.email});

  final String name;
  final String email;
  final String id;

  static User fromJson(Map<String, Object> json) {
    return User(
      name: json['name'] as String,
      id: json['id'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, Object> toJson() {
    return {
      'name': name,
      'id': id,
      'email': email,
    };
  }
}
