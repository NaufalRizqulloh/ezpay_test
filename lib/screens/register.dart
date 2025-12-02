// package:ezpay_test/screens/register.dart

import 'package:flutter/material.dart';

import 'package:ezpay_test/constants/app_colors.dart';
import 'package:ezpay_test/models/user.dart';
import 'package:ezpay_test/screens/login.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _isSMSMode = false;
  bool _isConfirmMode = false;

  // DEBUGGING ONLY
  void _showCredentials(name, phoneNumber, email, password) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'phoneNumber: $phoneNumber\n'
          'name: $name\n'
          'email: $email\n'
          'password: $password',
        ),
        action: SnackBarAction(label: 'Close', onPressed: () {}),
      ),
    );
  }

  void _processRegister() {
    if (!_isSMSMode) {
      // Check if any of them are empty
      final name = _nameController.text.trim();
      final phone = _phoneController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      if (name.isEmpty || phone.isEmpty || email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please input all the needed fields.')),
        );
        return;
      }

      // _showCredentials(name, '+62$phone', email, password); // testing only

      // Check if phone number already exists
      final existingUser = User.getUserByPhoneNumber('+62$phone');
      if (existingUser != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Phone number already registered! Please use another phone number.',
            ),
          ),
        );
        return;
      }

      setState(() {
        _isSMSMode = true;
      });
      return;
    } else if (!_isConfirmMode) {
      // SMS Verification code
      final smsCode = _smsController.text.trim();
      if (smsCode.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please input the SMS code sent to your phone.'),
          ),
        );
        return;
      }

      setState(() {
        _isConfirmMode = true;
      });
      return;
    } else {
      // Create new OTP for user
      final otpCode = _otpController.text.trim();
      if (otpCode.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please input your new OTP code for verification purposes.',
            ),
          ),
        );
        return;
      }

      // STORE INFO DATA HERE (BACK END)
      User.createUser(
        _nameController.text.trim(),
        '+62${_phoneController.text.trim()}',
        _emailController.text.trim(),
        _passwordController.text.trim(),
        otpCode,
        0, // default role: customer
      );

      // Succesfull snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'User Registered Successfully! Please login with your new account.',
          ),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()),
      );
    }
  }

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
                        'Registration Form, Please input your data to register a new account.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 24),

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
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
                          child: _isConfirmMode
                              ? Column(
                                  key: ValueKey('confirm'),
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Set Your OTP Code, this will be used for login verification.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
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
                                            setState(() => _isSMSMode = false);
                                            setState(
                                              () => _isConfirmMode = false,
                                            );
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
                                        hintText: '6-digit OTP code',
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
                                            onPressed: _processRegister,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.primary,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                            ),
                                            child: Text(
                                              'Confirm',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : _isSMSMode
                              ? Column(
                                  key: ValueKey('sms'),
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'We have sent a 6-digit code to your phone number.',
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
                                            setState(() => _isSMSMode = false);
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
                                      controller: _smsController,
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
                                            onPressed: _processRegister,
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
                                  key: ValueKey('regist_form'),
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Full Name',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    TextField(
                                      autofocus: true,
                                      controller: _nameController,
                                      decoration: InputDecoration(
                                        hintText: 'Enter your full name',
                                        border: OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: 16),
                                    Text(
                                      'Phone Number',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
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

                                    SizedBox(height: 16),
                                    Text(
                                      'Email Address',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    TextField(
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        hintText: 'Enter your email address',
                                        border: OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: 16),
                                    Text(
                                      'Password',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    TextField(
                                      controller: _passwordController,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        hintText: 'Enter your password',
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
                                      onPressed: _processRegister,
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
                                        Text('Sudah punya akun?'),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => LoginPage(),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            'Login',
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
