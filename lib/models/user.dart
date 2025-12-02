// package:ezpay_test/models/User.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final int id;
  final String phoneNumber;
  final String name;
  final String email;
  final String password;
  final String otp;
  final int role; // 0 for customer, 1 for merchant/admin

  // Static list (mockup only, CHANGE IF USE DB)
  static List<User> users = [];
  static const String _storageKey = 'ezpay_users';

  // Add user to the static list (RUN ONCE)
  void addToList() {
    users.add(this);
  }

  User({
    required this.id,
    required this.phoneNumber,
    required this.name,
    required this.email,
    required this.password,
    required this.otp,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      password: json['password'],
      otp: json['otp'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'password': password,
      'otp': otp,
      'role': role,
    };
  }

  // Load users from storage
  static Future<void> loadUsersFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);

    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      users = jsonList.map((json) => User.fromJson(json)).toList();
    }
  }

  // Save users to storage
  static Future<void> saveUsersToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(users.map((user) => user.toJson()).toList());
    await prefs.setString(_storageKey, jsonString);
  }

  // Create/Register a new user
  static Future<User> createUser(
    String name,
    String phoneNumber,
    String email,
    String password,
    String otp,
    int role,
  ) async {
    // Simulate a network call (CHANGE IF USE DB)
    await Future.delayed(Duration(seconds: 1));
    final newUser = User(
      id: users.isNotEmpty ? users.last.id + 1 : 1,
      name: name,
      phoneNumber: phoneNumber,
      email: email,
      password: password,
      otp: otp,
      role: role,
    );

    users.add(newUser);
    await saveUsersToStorage();
    return newUser;
  }

  // Get user by phone number
  static User? getUserByPhoneNumber(String phoneNumber) {
    try {
      return users.firstWhere((user) => user.phoneNumber == phoneNumber);
    } catch (e) {
      return null;
    }
  }

  // Verify OTP based on phone number
  static bool verifyOtp(String phoneNumber, String otp) {
    User? user = getUserByPhoneNumber(phoneNumber);
    if (user != null && user.otp == otp) {
      return true;
    }
    return false;
  }

  // For testing (do not activate)
  static void clearAll() {
    users.clear();
  }
}
