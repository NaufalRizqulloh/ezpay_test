// package:ezpay_test/screens/login.dart

import 'package:flutter/material.dart';

import 'package:ezpay_test/constants/app_colors.dart';

import 'package:ezpay_test/screens/register.dart';
import 'package:ezpay_test/screens/customer/customer_home_screen.dart';
import 'package:ezpay_test/screens/merchant/merchant_home_screen.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _isOtpMode = false; // tracks current step

  // DEBUGGING ONLY
  void _showCredentials(phoneNumber) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('phoneNumber: $phoneNumber'),
        action: SnackBarAction(label: 'Close', onPressed: () {}),
      ),
    );
  }

  void _processLogin() {
    if (!_isOtpMode) {
      // first step: phone input -> validate and switch to OTP mode
      final raw = _phoneController.text.trim();
      if (raw.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter your phone number')),
        );
        return;
      }

      // here you would send OTP to +62 + raw
      // _showCredentials('+62$raw'); // testing only

      setState(() {
        _isOtpMode = true;
      });
      return;
    } else {
      // second step: OTP input -> verify then navigate
      final otp = _otpController.text.trim();
      if (otp.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Please enter the OTP')));
        return;
      }

      // Fake verification for demo: allow 'merchant' to go to merchant screen
      if (_phoneController.text.trim() == 'merchant') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MerchantHomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => CustomerHomeScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        padding: EdgeInsets.all(16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/main_logo.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'EzPay',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Enter your phone number to log in',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 24),

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),

                        padding: EdgeInsets.all(24),
                        child: AnimatedSwitcher(
                          duration: Duration(milliseconds: 300),
                          child: _isOtpMode
                              ? Column(
                                  key: ValueKey('otp'),
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Please input your 6 digit One-Time Password (OTP) code.',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '+62 ${_phoneController.text.trim()}',
                                        ),

                                        TextButton(
                                          onPressed: () {
                                            setState(() => _isOtpMode = false);
                                          },
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets
                                                .zero, // remove internal padding
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap, // remove tap target padding
                                          ),
                                          child: Text('Change Phone Number'),
                                        ),
                                      ],
                                    ),

                                    TextField(
                                      autofocus: true,
                                      controller: _otpController,
                                      keyboardType: TextInputType.number,
                                      maxLength: 6,
                                      decoration: InputDecoration(
                                        hintText: '6-digit code',
                                        border: OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        counterText: '',
                                      ),
                                    ),

                                    SizedBox(height: 24),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: _processLogin,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.primary,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                            ),
                                            child: Text(
                                              'Verify',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('Didn\'t receive the code?'),
                                        TextButton(
                                          onPressed: () {
                                            // resend OTP logic here
                                          },
                                          child: Text(
                                            'Resend',
                                            style: TextStyle(
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : Column(
                                  key: ValueKey('phone'),
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Phone Number',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    SizedBox(height: 8),

                                    TextField(
                                      autofocus: true,
                                      controller: _phoneController,
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        hintText: '812345678',
                                        prefixIconConstraints: BoxConstraints(
                                          minWidth: 0,
                                          minHeight: 0,
                                        ),
                                        prefixIcon: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 16.0,
                                            right: 8.0,
                                          ),
                                          child: Text(
                                            '+62',
                                            style: TextStyle(
                                              color: AppColors.textPrimary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        border: OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: 24),
                                    ElevatedButton(
                                      onPressed: _processLogin,
                                      style: ElevatedButton.styleFrom(
                                        fixedSize: Size(1000, 48),
                                        backgroundColor: AppColors.primary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        'Continue   >',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('Belum punya akun?'),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => RegisterPage(),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            'Daftar',
                                            style: TextStyle(
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
