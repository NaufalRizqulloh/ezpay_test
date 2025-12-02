// package:ezpay_test/screens/customer/customer_home_screen.dart

import 'package:flutter/material.dart';
import 'package:ezpay_test/components/box_decoration.dart';
import 'package:ezpay_test/constants/app_colors.dart';
import 'package:ezpay_test/screens/customer/customer_qris_screen.dart';
import 'package:ezpay_test/services/wallet_manager.dart';

class CustomerHomeScreen extends StatefulWidget {
  @override
  _CustomerHomeScreenState createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  // E-wallet data
  late WalletManager _walletManager;
  List<Map<String, dynamic>> ewallets = [];

  @override
  void initState() {
    super.initState();
    _walletManager = WalletManager();
    _walletManager.addListener(_updateWallets);
    _updateWallets();
  }

  @override
  void dispose() {
    _walletManager.removeListener(_updateWallets);
    super.dispose();
  }

  void _updateWallets() {
    setState(() {
      ewallets = _walletManager.getCustomerWallets().map((wallet) {
        return {
          'name': wallet['name'],
          'balance': wallet['balance'],
          'color': Color(wallet['color']),
          'icon': _getIconData(wallet['icon']),
        };
      }).toList();
    });
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'account_balance_wallet':
        return Icons.account_balance_wallet;
      case 'account_balance':
        return Icons.account_balance;
      case 'shopping_bag':
        return Icons.shopping_bag;
      default:
        return Icons.account_balance_wallet;
    }
  }

  // Calculate total balance
  double get totalBalance {
    return _walletManager.getTotalCustomerBalance();
  }

  // final List<Map<String, dynamic>> ewallets = [
  //   {
  //     'name': 'GoPay',
  //     'balance': 250000.0,
  //     'color': Color(0xFF00AA13),
  //     'icon': Icons.account_balance_wallet,
  //   },
  //   {
  //     'name': 'OVO',
  //     'balance': 150000.0,
  //     'color': Color(0xFF4C3494),
  //     'icon': Icons.account_balance_wallet,
  //   },
  //   {
  //     'name': 'BCA',
  //     'balance': 500000.0,
  //     'color': Color(0xFF0066AE),
  //     'icon': Icons.account_balance,
  //   },
  //   {
  //     'name': 'ShopeePay',
  //     'balance': 100000.0,
  //     'color': Color(0xFFEE4D2D),
  //     'icon': Icons.shopping_bag,
  //   },
  // ];

  // // Calculate total balance
  // double get totalBalance {
  //   return ewallets.fold(0, (sum, wallet) => sum + wallet['balance']);
  // }

  void _scanQris() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CustomerQrisScreen()),
    );
  }

  void _manualPayment() {
    // TODO: Implement manual payment
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Manual Payment - Coming Soon')));
  }

  void _addWallet() {
    // TODO: Implement add wallet
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Add Wallet - Coming Soon')));
  }

  String _formatCurrency(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'EZPAY',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.person_outline, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Total Balance Card
              Container(
                width: double.infinity,
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
                    Text(
                      'Total Balance',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      _formatCurrency(totalBalance),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildActionButton(
                    icon: Icons.qr_code_scanner,
                    label: 'Scan QRIS',
                    onTap: _scanQris,
                  ),
                  _buildActionButton(
                    icon: Icons.payment,
                    label: 'Manual Payment',
                    onTap: _manualPayment,
                  ),
                  _buildActionButton(
                    icon: Icons.add_circle_outline,
                    label: 'Add Wallet',
                    onTap: _addWallet,
                  ),
                ],
              ),

              SizedBox(height: 32),

              // My Digital Wallet Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Digital Wallets',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                ],
              ),

              SizedBox(height: 16),

              // E-Wallet List
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: ewallets.length,
                itemBuilder: (context, index) {
                  final wallet = ewallets[index];
                  return _buildWalletCard(
                    name: wallet['name'],
                    balance: wallet['balance'],
                    color: wallet['color'],
                    icon: wallet['icon'],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 110,
        padding: EdgeInsets.symmetric(vertical: 20),
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
            Icon(icon, size: 32, color: AppColors.primary),
            SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletCard({
    required String name,
    required double balance,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          // Wallet Icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          SizedBox(width: 16),
          // Wallet Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  _formatCurrency(balance),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Action Button
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}
