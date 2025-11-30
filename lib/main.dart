// package:ezpay_test/main.dart

import 'package:flutter/material.dart';

import 'package:ezpay_test/core/constants/app_colors.dart';

import 'package:ezpay_test/screens/login.dart';
import 'package:ezpay_test/screens/customer/customer_home_screen.dart';
import 'package:ezpay_test/screens/merchant/merchant_home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyApp> {
  // EXAMPLE LOGIN SESSION, PLEASE CHANGE IN THE FUTURE
  final int login = 0;
  final int role = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: AppColors.primarySwatch),
      home: FutureBuilder(
        future: _loadSession(),
        builder: (context, snapshot) {
          late final List<int> session = snapshot.data ?? [0, 0];
          late Widget result;
          if (snapshot.connectionState == ConnectionState.waiting) {
            result = Scaffold(body: Center(child: CircularProgressIndicator()));
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (session[login] == 1) {
                if (session[role] == 1) {
                  // Admin Session

                  // FOR TESTING PURPOSES
                  // result = Scaffold(
                  //   body: Center(child: Text('Welcome Admin User')),
                  // );
                  result = MerchantHomeScreen();
                } else {
                  // Regular Customer Session

                  // FOR TESTING PURPOSES
                  // result = Scaffold(
                  //   body: Center(child: Text('Welcome Regular User')),
                  // );
                  result = CustomerHomeScreen();
                }
              } else {
                // FOR TESTING PURPOSES
                // result = Scaffold(body: Center(child: Text('Please Log In')));
                result = LoginPage();
              }
            } else {
              return Container(child: Text('Error..'));
            }
          }
          return result;
        },
      ),
    );
  }

  // EXAMPLE LOGIN SESSION, PLEASE CHANGE IN THE FUTURE
  Future _loadSession() async {
    // Simulate loading session data
    await Future.delayed(Duration(seconds: 1));
    return [role, login];
  }
}
