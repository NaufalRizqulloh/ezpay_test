// package:ezpay_test/screens/merchant/transaction_history_screen.dart

import 'package:flutter/material.dart';
import 'package:ezpay_test/constants/app_colors.dart';

class TransactionHistoryScreen extends StatefulWidget {
  final List<Map<String, dynamic>> transactions;

  const TransactionHistoryScreen({Key? key, required this.transactions})
    : super(key: key);

  @override
  _TransactionHistoryScreenState createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  String selectedFilter = 'All';
  final List<String> filters = ['All', 'Today', 'This Week', 'This Month'];

  // Extended dummy transactions
  List<Map<String, dynamic>> allTransactions = [];

  @override
  void initState() {
    super.initState();
    _generateDummyTransactions();
  }

  void _generateDummyTransactions() {
    allTransactions = [
      {
        'customer': 'Ahmad R.',
        'amount': 50000.0,
        'time': '2 min ago',
        'date': DateTime.now().subtract(Duration(minutes: 2)),
        'status': 'success',
        'paymentMethod': 'GoPay',
        'transactionId': 'TRX20241201001',
      },
      {
        'customer': 'Siti M.',
        'amount': 125000.0,
        'time': '15 min ago',
        'date': DateTime.now().subtract(Duration(minutes: 15)),
        'status': 'success',
        'paymentMethod': 'OVO',
        'transactionId': 'TRX20241201002',
      },
      {
        'customer': 'Budi S.',
        'amount': 75000.0,
        'time': '1 hour ago',
        'date': DateTime.now().subtract(Duration(hours: 1)),
        'status': 'success',
        'paymentMethod': 'ShopeePay',
        'transactionId': 'TRX20241201003',
      },
      {
        'customer': 'Dewi K.',
        'amount': 200000.0,
        'time': '2 hours ago',
        'date': DateTime.now().subtract(Duration(hours: 2)),
        'status': 'success',
        'paymentMethod': 'BCA',
        'transactionId': 'TRX20241201004',
      },
      {
        'customer': 'Eko P.',
        'amount': 45000.0,
        'time': '3 hours ago',
        'date': DateTime.now().subtract(Duration(hours: 3)),
        'status': 'success',
        'paymentMethod': 'GoPay',
        'transactionId': 'TRX20241201005',
      },
      {
        'customer': 'Rina W.',
        'amount': 150000.0,
        'time': 'Yesterday',
        'date': DateTime.now().subtract(Duration(days: 1)),
        'status': 'success',
        'paymentMethod': 'OVO',
        'transactionId': 'TRX20241130001',
      },
      {
        'customer': 'Joko T.',
        'amount': 90000.0,
        'time': 'Yesterday',
        'date': DateTime.now().subtract(Duration(days: 1)),
        'status': 'success',
        'paymentMethod': 'ShopeePay',
        'transactionId': 'TRX20241130002',
      },
      {
        'customer': 'Ani S.',
        'amount': 65000.0,
        'time': '2 days ago',
        'date': DateTime.now().subtract(Duration(days: 2)),
        'status': 'success',
        'paymentMethod': 'GoPay',
        'transactionId': 'TRX20241129001',
      },
    ];
  }

  List<Map<String, dynamic>> get filteredTransactions {
    if (selectedFilter == 'All') {
      return allTransactions;
    } else if (selectedFilter == 'Today') {
      return allTransactions
          .where(
            (t) =>
                t['date'].day == DateTime.now().day &&
                t['date'].month == DateTime.now().month,
          )
          .toList();
    } else if (selectedFilter == 'This Week') {
      final now = DateTime.now();
      final weekAgo = now.subtract(Duration(days: 7));
      return allTransactions.where((t) => t['date'].isAfter(weekAgo)).toList();
    } else {
      final now = DateTime.now();
      return allTransactions
          .where(
            (t) => t['date'].month == now.month && t['date'].year == now.year,
          )
          .toList();
    }
  }

  double get totalAmount {
    return filteredTransactions.fold(
      0.0,
      (sum, transaction) => sum + transaction['amount'],
    );
  }

  String _formatCurrency(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  Color _getPaymentMethodColor(String method) {
    switch (method) {
      case 'GoPay':
        return Color(0xFF00AA13);
      case 'OVO':
        return Color(0xFF4C3494);
      case 'BCA':
        return Color(0xFF0066AE);
      case 'ShopeePay':
        return Color(0xFFEE4D2D);
      default:
        return Colors.grey;
    }
  }

  void _showTransactionDetail(Map<String, dynamic> transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 24),
            Center(
              child: Icon(Icons.check_circle, color: Colors.green, size: 64),
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                'Payment Success',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: 24),
            _buildDetailRow('Transaction ID', transaction['transactionId']),
            _buildDetailRow('Customer', transaction['customer']),
            _buildDetailRow('Amount', _formatCurrency(transaction['amount'])),
            _buildDetailRow('Payment Method', transaction['paymentMethod']),
            _buildDetailRow('Date & Time', transaction['time']),
            _buildDetailRow('Status', 'Success'),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Close',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Transaction History',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Summary Card
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Revenue',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    Text(
                      _formatCurrency(totalAmount),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${filteredTransactions.length}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Transactions',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Filter Buttons
          Container(
            height: 50,
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              itemBuilder: (context, index) {
                final filter = filters[index];
                final isSelected = selectedFilter == filter;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedFilter = filter;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 8),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      filter,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 16),

          // Transaction List
          Expanded(
            child: filteredTransactions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No transactions found',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction = filteredTransactions[index];
                      return _buildTransactionCard(transaction);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> transaction) {
    return GestureDetector(
      onTap: () => _showTransactionDetail(transaction),
      child: Container(
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
                color: _getPaymentMethodColor(
                  transaction['paymentMethod'],
                ).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.account_balance_wallet,
                color: _getPaymentMethodColor(transaction['paymentMethod']),
                size: 24,
              ),
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
                  Row(
                    children: [
                      Text(
                        transaction['paymentMethod'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text('•', style: TextStyle(color: Colors.grey[400])),
                      SizedBox(width: 8),
                      Text(
                        transaction['time'],
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatCurrency(transaction['amount']),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: 4),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Success',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
