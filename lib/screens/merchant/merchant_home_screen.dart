// package:ezpay_test/screens/merchant/merchant_home_screen.dart

import 'package:flutter/material.dart';

import 'package:ezpay_test/core/constants/app_colors.dart';

class MerchantHomeScreen extends StatefulWidget {
  @override
  _MerchantHomeScreenState createState() => _MerchantHomeScreenState();
}

class _MerchantHomeScreenState extends State<MerchantHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Merchant Home'),
        backgroundColor:
            AppColors.primary, // Assuming AppColors.primaryColor exists
      ),
      body: Center(
        child: Text(
          "You're a merchant",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
