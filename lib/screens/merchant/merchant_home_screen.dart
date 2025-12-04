// package:ezpay_test/screens/merchant/merchant_home_screen.dart

import 'package:flutter/material.dart';
import 'package:ezpay_test/constants/app_colors.dart';
import 'package:ezpay_test/models/user.dart';
import 'package:ezpay_test/screens/merchant/generate_qr_screen.dart';
import 'package:ezpay_test/screens/merchant/transaction_history_screen.dart';
import 'package:ezpay_test/services/transaction_manager.dart';
import 'package:ezpay_test/services/wallet_manager.dart';

class MerchantHomeScreen extends StatefulWidget {
  final User? user;
  MerchantHomeScreen({Key? key, this.user}) : super(key: key);

  @override
  _MerchantHomeScreenState createState() => _MerchantHomeScreenState();
}

class _MerchantHomeScreenState extends State<MerchantHomeScreen> {
  final String merchantId = "MERCHANT001";
  final String merchantName = "Warung Makan Sederhana";

  late TransactionManager _transactionManager;
  late WalletManager _walletManager;

  List<Map<String, dynamic>> recentTransactions = [];
  double todayRevenue = 0.0;
  double monthlyRevenue = 0.0;
  int todayTransactions = 0;
  int monthlyTransactions = 0;
  double merchantBalance = 0.0;

  @override
  void initState() {
    super.initState();
    _transactionManager = TransactionManager();
    _walletManager = WalletManager();

    _transactionManager.initializeDummyData();
    _walletManager.initializeMerchant(merchantId, initialBalance: 5000000.0);

    _transactionManager.addListener(_updateData);
    _walletManager.addListener(_updateData);

    _updateData();
  }

  @override
  void dispose() {
    _transactionManager.removeListener(_updateData);
    _walletManager.removeListener(_updateData);
    super.dispose();
  }

  void _updateData() {
    setState(() {
      recentTransactions = _transactionManager
          .getMerchantTransactions(merchantId)
          .take(4)
          .toList();
      todayRevenue = _transactionManager.getTodayRevenue(merchantId);
      monthlyRevenue = _transactionManager.getMonthlyRevenue(merchantId);
      todayTransactions = _transactionManager.getTodayTransactionCount(
        merchantId,
      );
      monthlyTransactions = _transactionManager.getMonthlyTransactionCount(
        merchantId,
      );
      merchantBalance = _walletManager.getMerchantBalance(merchantId);
    });
  }

  // Recent transactions
  // final List<Map<String, dynamic>> recentTransactions = [
  //   {
  //     'customer': 'Ahmad R.',
  //     'amount': 50000.0,
  //     'time': '2 min ago',
  //     'status': 'success',
  //   },
  //   {
  //     'customer': 'Siti M.',
  //     'amount': 125000.0,
  //     'time': '15 min ago',
  //     'status': 'success',
  //   },
  //   {
  //     'customer': 'Budi S.',
  //     'amount': 75000.0,
  //     'time': '1 hour ago',
  //     'status': 'success',
  //   },
  //   {
  //     'customer': 'Dewi K.',
  //     'amount': 200000.0,
  //     'time': '2 hours ago',
  //     'status': 'success',
  //   },
  // ];

  void _generateQR() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => GenerateQRScreen()),
    );
  }

  void _viewTransactionHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TransactionHistoryScreen(merchantId: merchantId),
      ),
    );
  }

  String _formatCurrency(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    final username = widget.user?.name ?? 'Merchant';
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'EZPAY Merchant - $username',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              merchantName,
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.settings_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Revenue Summary Card
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Today\'s Revenue',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$todayTransactions transactions',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    _formatCurrency(todayRevenue),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Divider(color: Colors.white30),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'This Month',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            _formatCurrency(monthlyRevenue),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Transactions',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '$monthlyTransactions',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Add this after the Revenue Summary Card in the build method
            SizedBox(height: 16),

            // Merchant Balance Card
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.account_balance_wallet,
                      color: Colors.green,
                      size: 28,
                    ),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Merchant Balance',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 4),
                      Text(
                        _formatCurrency(merchantBalance),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Action Buttons
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      icon: Icons.qr_code_2,
                      label: 'Generate QR',
                      color: AppColors.primary,
                      onTap: _generateQR,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildActionCard(
                      icon: Icons.history,
                      label: 'History',
                      color: Colors.orange,
                      onTap: _viewTransactionHistory,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Recent Transactions Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Transactions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  TextButton(
                    onPressed: _viewTransactionHistory,
                    child: Text('See All'),
                  ),
                ],
              ),
            ),

            // Transaction List
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: recentTransactions.length,
              itemBuilder: (context, index) {
                final transaction = recentTransactions[index];
                return _buildTransactionCard(transaction);
              },
            ),

            SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _generateQR,
        backgroundColor: AppColors.primary,
        icon: Icon(Icons.qr_code_2, color: Colors.white),
        label: Text(
          'Generate QR',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> transaction) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check_circle, color: Colors.green, size: 28),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction['customer'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  transaction['time'],
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Text(
            _formatCurrency(transaction['amount']),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
