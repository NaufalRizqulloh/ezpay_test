import 'package:flutter/material.dart';
import 'package:ezpay_test/constants/app_colors.dart';
import 'package:ezpay_test/models/transaction.dart';

class TransactionHistoryScreen extends StatefulWidget {
  final String userName;

  TransactionHistoryScreen({required this.userName});

  @override
  _TransactionHistoryScreenState createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  late List<Transaction> transactions;

  @override
  void initState() {
    super.initState();

    // Filter transactions for this customer
    transactions = Transaction.transactions
        .where((t) => t.paidBy == widget.userName)
        .toList();

    print("Customer Transactions: ${transactions.length}");
  }

  String _formatCurrency(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  String _formatTime(int timestampMillis) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestampMillis);
    final two = (int v) => v.toString().padLeft(2, '0');

    return '${two(date.day)}/${two(date.month)}/${date.year} '
        '${two(date.hour)}:${two(date.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          "My Transactions",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: transactions.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: transactions.length,
              itemBuilder: (context, index) =>
                  _buildTransactionCard(transactions[index]),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_outlined, size: 80, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'No transactions yet',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          SizedBox(height: 8),
          Text(
            'Your payments will appear here',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(Transaction t) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Merchant Name
          Row(
            children: [
              Icon(Icons.store, color: AppColors.primary, size: 22),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  t.merchantName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              // Status (Paid / Pending)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: t.isPaid
                      ? Colors.green.withOpacity(0.15)
                      : Colors.orange.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  t.isPaid ? "PAID" : "PENDING",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: t.isPaid ? Colors.green : Colors.orange,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          // Amount
          Text(
            _formatCurrency(t.amount),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),

          SizedBox(height: 8),

          // Date and time
          Row(
            children: [
              Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
              SizedBox(width: 6),
              Text(
                _formatTime(t.timeCreated),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),

          if (t.note.isNotEmpty) ...[
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.note_outlined, size: 14, color: Colors.grey[600]),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      t.note,
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),
            ),
          ],

          SizedBox(height: 8),
          Divider(height: 1, color: Colors.grey[300]),
          SizedBox(height: 8),

          // Transaction ID
          Text(
            "ID: ${t.transactionID}",
            style: TextStyle(fontSize: 10, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
