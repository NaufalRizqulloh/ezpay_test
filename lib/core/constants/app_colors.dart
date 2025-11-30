// lib/core/constants/app_colors.dart

import 'package:flutter/material.dart';

class AppColors {
  // Material Colors Swatch
  static const MaterialColor primarySwatch =
      MaterialColor(0xFF1E88E5, <int, Color>{
        50: Color(0xFFE3F2FD),
        100: Color(0xFFBBDEFB),
        200: Color(0xFF90CAF9),
        300: Color(0xFF64B5F6),
        400: Color(0xFF42A5F5),
        500: Color(0xFF2196F3),
        600: Color(0xFF1E88E5),
        700: Color(0xFF1976D2),
        800: Color(0xFF1565C0),
        900: Color(0xFF0D47A1),
      });

  // Primary colors
  static const Color primary = Color(0xFF1E88E5);
  static const Color primaryDark = Color(0xFF1565C0);
  static const Color primaryLight = Color(0xFF42A5F5);

  // Accent colors
  static const Color accent = Color(0xFF26A69A);
  static const Color accentLight = Color(0xFF4DB6AC);

  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA726);
  static const Color error = Color(0xFFEF5350);
  static const Color info = Color(0xFF29B6F6);

  // Neutral colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color divider = Color(0xFFE0E0E0);

  // Payment method colors
  static const Color gopay = Color(0xFF00AA13);
  static const Color dana = Color(0xFF1A8EFD);
  static const Color ovo = Color(0xFF4C3494);
  static const Color bca = Color(0xFF003F87);
  static const Color mandiri = Color(0xFF003D79);
  static const Color shopeepay = Color(0xFFEE4D2D);
}

class AppStrings {
  // App
  static const String appName = 'PaymentApp';

  // Auth
  static const String login = 'Masuk';
  static const String register = 'Daftar';
  static const String logout = 'Keluar';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Konfirmasi Password';
  static const String name = 'Nama';
  static const String phone = 'Nomor Telepon';

  // Role
  static const String customer = 'Customer';
  static const String merchant = 'Merchant';
  static const String selectRole = 'Pilih Peran Anda';

  // Payment
  static const String scanQR = 'Scan QR';
  static const String generateQR = 'Generate QR';
  static const String amount = 'Jumlah';
  static const String paymentMethod = 'Metode Pembayaran';
  static const String payNow = 'Bayar Sekarang';
  static const String waitingPayment = 'Menunggu Pembayaran';
  static const String paymentSuccess = 'Pembayaran Berhasil';
  static const String paymentFailed = 'Pembayaran Gagal';

  // Transaction
  static const String transactionHistory = 'Riwayat Transaksi';
  static const String noTransactions = 'Belum ada transaksi';

  // Validation
  static const String fieldRequired = 'Field ini wajib diisi';
  static const String emailInvalid = 'Email tidak valid';
  static const String passwordTooShort = 'Password minimal 6 karakter';
  static const String passwordNotMatch = 'Password tidak cocok';
}
