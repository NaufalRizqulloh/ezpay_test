// package:ezpay_test/services/transaction_manager.dart

class TransactionManager {
  static final TransactionManager _instance = TransactionManager._internal();
  factory TransactionManager() => _instance;
  TransactionManager._internal();

  // Store transactions in memory
  final List<Map<String, dynamic>> _transactions = [];

  // Listeners for real-time updates
  final List<Function()> _listeners = [];

  List<Map<String, dynamic>> get transactions =>
      List.unmodifiable(_transactions);

  void addTransaction({
    required String merchantId,
    required String merchantName,
    required String customer,
    required double amount,
    required String paymentMethod,
    required String transactionId,
    String? note,
  }) {
    final transaction = {
      'merchant_id': merchantId,
      'merchant_name': merchantName,
      'customer': customer,
      'amount': amount,
      'payment_method': paymentMethod,
      'transaction_id': transactionId,
      'note': note ?? '',
      'time': _getRelativeTime(DateTime.now()),
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'status': 'success',
    };

    _transactions.insert(0, transaction); // Add to beginning
    _notifyListeners();
  }

  List<Map<String, dynamic>> getMerchantTransactions(String merchantId) {
    return _transactions.where((t) => t['merchant_id'] == merchantId).toList();
  }

  // Get today's revenue for a merchant
  double getTodayRevenue(String merchantId) {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final startTimestamp = startOfDay.millisecondsSinceEpoch;

    return _transactions
        .where(
          (t) =>
              t['merchant_id'] == merchantId &&
              t['timestamp'] >= startTimestamp,
        )
        .fold(0.0, (sum, t) => sum + t['amount']);
  }

  // Get today's transaction count for a merchant
  int getTodayTransactionCount(String merchantId) {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final startTimestamp = startOfDay.millisecondsSinceEpoch;

    return _transactions
        .where(
          (t) =>
              t['merchant_id'] == merchantId &&
              t['timestamp'] >= startTimestamp,
        )
        .length;
  }

  // Get monthly revenue for a merchant
  double getMonthlyRevenue(String merchantId) {
    final today = DateTime.now();
    final startOfMonth = DateTime(today.year, today.month, 1);
    final startTimestamp = startOfMonth.millisecondsSinceEpoch;

    return _transactions
        .where(
          (t) =>
              t['merchant_id'] == merchantId &&
              t['timestamp'] >= startTimestamp,
        )
        .fold(0.0, (sum, t) => sum + t['amount']);
  }

  // Get monthly transaction count for a merchant
  int getMonthlyTransactionCount(String merchantId) {
    final today = DateTime.now();
    final startOfMonth = DateTime(today.year, today.month, 1);
    final startTimestamp = startOfMonth.millisecondsSinceEpoch;

    return _transactions
        .where(
          (t) =>
              t['merchant_id'] == merchantId &&
              t['timestamp'] >= startTimestamp,
        )
        .length;
  }

  // Add listener for real-time updates
  void addListener(Function() listener) {
    _listeners.add(listener);
  }

  // Remove listener
  void removeListener(Function() listener) {
    _listeners.remove(listener);
  }

  // Notify all listeners
  void _notifyListeners() {
    for (var listener in _listeners) {
      listener();
    }
  }

  String _getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  // Initialize with dummy data (optional)
  void initializeDummyData() {
    if (_transactions.isEmpty) {
      _transactions.addAll([
        {
          'merchant_id': 'MERCHANT001',
          'merchant_name': 'Warung Makan Sederhana',
          'customer': 'Ahmad R.',
          'amount': 50000.0,
          'payment_method': 'GoPay',
          'transaction_id':
              'TRX${DateTime.now().millisecondsSinceEpoch - 120000}',
          'note': 'Nasi Goreng',
          'time': '2 min ago',
          'timestamp': DateTime.now().millisecondsSinceEpoch - 120000,
          'status': 'success',
        },
        {
          'merchant_id': 'MERCHANT001',
          'merchant_name': 'Warung Makan Sederhana',
          'customer': 'Siti M.',
          'amount': 125000.0,
          'payment_method': 'OVO',
          'transaction_id':
              'TRX${DateTime.now().millisecondsSinceEpoch - 900000}',
          'note': 'Paket Ayam Penyet',
          'time': '15 min ago',
          'timestamp': DateTime.now().millisecondsSinceEpoch - 900000,
          'status': 'success',
        },
        {
          'merchant_id': 'MERCHANT001',
          'merchant_name': 'Warung Makan Sederhana',
          'customer': 'Budi S.',
          'amount': 75000.0,
          'payment_method': 'BCA',
          'transaction_id':
              'TRX${DateTime.now().millisecondsSinceEpoch - 3600000}',
          'note': 'Mie Ayam',
          'time': '1 hour ago',
          'timestamp': DateTime.now().millisecondsSinceEpoch - 3600000,
          'status': 'success',
        },
        {
          'merchant_id': 'MERCHANT001',
          'merchant_name': 'Warung Makan Sederhana',
          'customer': 'Dewi K.',
          'amount': 200000.0,
          'payment_method': 'ShopeePay',
          'transaction_id':
              'TRX${DateTime.now().millisecondsSinceEpoch - 7200000}',
          'note': 'Catering',
          'time': '2 hours ago',
          'timestamp': DateTime.now().millisecondsSinceEpoch - 7200000,
          'status': 'success',
        },
      ]);
    }
  }

  // Clear all transactions (for testing)
  void clearTransactions() {
    _transactions.clear();
    _notifyListeners();
  }
}
