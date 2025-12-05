// package:ezpay_test/models/transaction.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Transaction {
  final int id;
  final String merchantId;
  final String merchantName;
  final double amount;
  final String paymentMethod;
  final String transactionID;
  final String note;
  final String qrData;
  final bool isPaid;
  final String paidBy;
  final int timeCreated;
  final int? timePaid;

  // Static list (mockup only, CHANGE IF USE DB)
  static List<Transaction> transactions = [];
  static const String _storageKey = 'ezpay_transactions';

  // Add transaction to the static list (RUN ONCE)
  void addToList() {
    transactions.add(this);
  }

  Transaction({
    required this.id,
    required this.merchantId,
    required this.merchantName,
    required this.amount,
    required this.paymentMethod,
    required this.transactionID,
    required this.note,
    required this.qrData,
    required this.isPaid,
    required this.paidBy,
    required this.timeCreated,
    this.timePaid,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      merchantId: json['merchantId'],
      merchantName: json['merchantName'],
      amount: json['amount'],
      paymentMethod: json['paymentMethod'],
      transactionID: json['transactionID'],
      note: json['note'],
      qrData: json['qrData'],
      isPaid: json['isPaid'],
      paidBy: json['paidBy'],
      timeCreated: int.parse(json['timeCreated']),
      timePaid: json['timePaid'] != null ? int.parse(json['timePaid']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'merchantId': merchantId,
      'merchantName': merchantName,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'transactionID': transactionID,
      'note': note,
      'qrData': qrData,
      'isPaid': isPaid,
      'paidBy': paidBy,
      'timeCreated': timeCreated,
      'timePaid': timePaid,
    };
  }

  // Load transactionfrom storage
  static Future<void> loadTransactionsFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      transactions = jsonList
          .map((json) => Transaction.fromJson(json))
          .toList();
    }
  }

  // Save transaction to storage
  static Future<void> saveTransactionsToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(
      transactions.map((user) => user.toJson()).toList(),
    );
    await prefs.setString(_storageKey, jsonString);
  }

  // Create a new transaction
  static Future<Transaction> createTransaction(
    String merchantId,
    String merchantName,
    double amount,
    String note,
    String transactionId,
    String qrData,
  ) async {
    // Simulate a network call (CHANGE IF USE DB)
    await Future.delayed(Duration(seconds: 1));
    final newTransaction = Transaction(
      id: transactions.isNotEmpty ? transactions.last.id + 1 : 1,
      merchantId: merchantId,
      merchantName: merchantName,
      amount: amount,
      paymentMethod: '',
      transactionID: transactionId,
      note: note,
      qrData: qrData,
      isPaid: false,
      paidBy: '',
      timeCreated: DateTime.now().millisecondsSinceEpoch,
      timePaid: null,
    );

    transactions.add(newTransaction);
    await saveTransactionsToStorage();
    print('Transaction created: ${newTransaction.toJson()}');
    return newTransaction;
  }

  // Update transaction upon succesfull transaction
  static Future<void> markTransactionAsPaid(
    String transactionId,
    String paidBy,
    String paymentMethod,
  ) async {
    print(transactionId);
    final transaction = transactions.firstWhere(
      (trx) => trx.transactionID == transactionId,
      orElse: () => throw Exception('Transaction not found'),
    );

    final updatedTransaction = Transaction(
      id: transaction.id,
      merchantId: transaction.merchantId,
      merchantName: transaction.merchantName,
      amount: transaction.amount,
      paymentMethod: paymentMethod,
      transactionID: transaction.transactionID,
      note: transaction.note,
      qrData: transaction.qrData,
      isPaid: true,
      paidBy: paidBy,
      timeCreated: transaction.timeCreated,
      timePaid: DateTime.now().millisecondsSinceEpoch,
    );

    final index = transactions.indexOf(transaction);
    transactions[index] = updatedTransaction;
    await saveTransactionsToStorage();
    print('Transaction updated as paid: ${updatedTransaction.toJson()}');
  }

  // For testing (do not activate)
  static void clearAll() {
    transactions.clear();
  }
}
