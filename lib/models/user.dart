// package:ezpay_test/models/User.dart

class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final int role; // 0 for customer, 1 for merchant/admin

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'role': role,
    };
  }

  // Create/Register a new user
  static Future<User> createUser(
    String name,
    String email,
    String password,
    int role,
  ) async {
    // Simulate a network call (CHANGE IF USE DB)
    await Future.delayed(Duration(seconds: 1));
    return User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      password: password,
      role: role,
    );
  }
}
