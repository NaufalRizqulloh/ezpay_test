// package:ezpay_test/factory/userFactory.dart

import 'package:ezpay_test/models/user.dart';

class UserFactory {
  // Generate mock users and populate the User._users list
  static Future<void> initializeMockUsers() async {
    // Load existing users from storage first
    await User.loadUsersFromStorage();

    // Only add mock users if list is empty (first launch)
    if (User.users.isEmpty) {
      User(
        id: 1,
        name: 'John Doe',
        phoneNumber: '+62812345678',
        email: 'john@example.com',
        password: 'password123',
        otp: '123456',
        role: 0, // customer
      ).addToList();

      User(
        id: 2,
        name: 'Jane Smith',
        phoneNumber: '+62887654321',
        email: 'jane@example.com',
        password: 'password123',
        otp: '654321',
        role: 0, // customer
      ).addToList();

      // Mock merchant/admin user
      User(
        id: 3,
        name: 'Admin User',
        phoneNumber: '+62676767',
        email: 'admin@example.com',
        password: 'admin123',
        otp: '677667',
        role: 1, // merchant/admin
      ).addToList();

      User(
        id: 4,
        name: 'Merchant Store',
        phoneNumber: '+62898765432',
        email: 'merchant@example.com',
        password: 'merchant123',
        otp: '987654',
        role: 1, // merchant
      ).addToList();

      // Save the mock users to storage
      await User.saveUsersToStorage();
    }
  }
}
