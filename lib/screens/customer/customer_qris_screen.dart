// package:ezpay_test/screens/customer/customer_home_screen.dart

import 'package:flutter/material.dart';
import 'package:ezpay_test/components/box_decoration.dart';
import 'package:ezpay_test/constants/app_colors.dart';

class CustomerQrisScreen extends StatefulWidget {
  @override
  _CustomerQrisScreenState createState() => _CustomerQrisScreenState();
}

class _CustomerQrisScreenState extends State<CustomerQrisScreen> {
  void _scanQris() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => CustomerQrisScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Home', style: TextStyle(color: Colors.white)),
        backgroundColor:
            AppColors.primary, // Assuming AppColors.primaryColor exists
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Container(
            width: 400,
            height: 100,
            decoration: appBoxDecoration(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Total Balance", style: TextStyle(color: Colors.black)),
                Text("Rp. 1.000.000", style: TextStyle(color: Colors.black)),
              ],
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // ElevatedButton(
              //   onPressed: _processLogin,
              //   style: ElevatedButton.styleFrom(
              //     fixedSize: Size(1000, 48),
              //     backgroundColor: AppColors.primary,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(16),
              //     ),
              //   ),
              //   child: Text(
              //     'Continue   >',
              //     style: TextStyle(fontSize: 16, color: Colors.white),
              //   ),
              // ),
              Container(
                width: 120,
                height: 100,
                decoration: appBoxDecoration(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Manual Payment",
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              Container(
                width: 120,
                height: 100,
                decoration: appBoxDecoration(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Add Wallet", style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
