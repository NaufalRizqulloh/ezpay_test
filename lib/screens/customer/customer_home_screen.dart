// package:ezpay_test/screens/customer/customer_home_screen.dart

import 'package:flutter/material.dart';

import 'package:ezpay_test/core/constants/app_colors.dart';

class CustomerHomeScreen extends StatefulWidget {
  @override
  _CustomerHomeScreenState createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Home'),
        backgroundColor:
            AppColors.primary, // Assuming AppColors.primaryColor exists
      ),
      body: Center(
        child: Text(
          "You're a customer",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
