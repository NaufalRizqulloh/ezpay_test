// package:ezpay_test/services/wallet_manager.dart

class WalletManager {
  static final WalletManager _instance = WalletManager._internal();
  factory WalletManager() => _instance;
  WalletManager._internal();

  // Customer wallets
  final Map<String, Map<String, dynamic>> _customerWallets = {
    'gopay': {
      'id': 'gopay',
      'name': 'GoPay',
      'balance': 250000.0,
      'color': 0xFF00AA13,
      'icon': 'account_balance_wallet',
    },
    'ovo': {
      'id': 'ovo',
      'name': 'OVO',
      'balance': 150000.0,
      'color': 0xFF4C3494,
      'icon': 'account_balance_wallet',
    },
    'bca': {
      'id': 'bca',
      'name': 'BCA',
      'balance': 500000.0,
      'color': 0xFF0066AE,
      'icon': 'account_balance',
    },
    'shopeepay': {
      'id': 'shopeepay',
      'name': 'ShopeePay',
      'balance': 100000.0,
      'color': 0xFFEE4D2D,
      'icon': 'shopping_bag',
    },
  };

  // Merchant balances (keyed by merchant_id)
  final Map<String, double> _merchantBalances = {
    'MERCHANT001': 5000000.0, // Starting balance for Warung Makan Sederhana
  };

  // Listeners for wallet updates
  final List<Function()> _listeners = [];

  // Get all customer wallets
  List<Map<String, dynamic>> getCustomerWallets() {
    return _customerWallets.values.toList();
  }

  // Get specific wallet
  Map<String, dynamic>? getWallet(String walletId) {
    return _customerWallets[walletId];
  }

  // Get wallet balance
  double getWalletBalance(String walletId) {
    return _customerWallets[walletId]?['balance'] ?? 0.0;
  }

  // Get merchant balance
  double getMerchantBalance(String merchantId) {
    return _merchantBalances[merchantId] ?? 0.0;
  }

  // Process payment: deduct from customer wallet, add to merchant balance
  bool processPayment({
    required String walletId,
    required String merchantId,
    required double amount,
  }) {
    // Validate wallet exists
    if (!_customerWallets.containsKey(walletId)) {
      return false;
    }

    // Check sufficient balance
    final currentBalance = _customerWallets[walletId]!['balance'];
    if (currentBalance < amount) {
      return false;
    }

    // Deduct from customer wallet
    _customerWallets[walletId]!['balance'] = currentBalance - amount;

    // Add to merchant balance
    _merchantBalances[merchantId] =
        (_merchantBalances[merchantId] ?? 0.0) + amount;

    // Notify listeners
    _notifyListeners();

    return true;
  }

  // Top up wallet (for testing purposes)
  void topUpWallet(String walletId, double amount) {
    if (_customerWallets.containsKey(walletId)) {
      _customerWallets[walletId]!['balance'] =
          _customerWallets[walletId]!['balance'] + amount;
      _notifyListeners();
    }
  }

  // Add new wallet
  void addWallet({
    required String id,
    required String name,
    required double initialBalance,
    required int color,
    required String icon,
  }) {
    _customerWallets[id] = {
      'id': id,
      'name': name,
      'balance': initialBalance,
      'color': color,
      'icon': icon,
    };
    _notifyListeners();
  }

  // Initialize merchant if not exists
  void initializeMerchant(String merchantId, {double initialBalance = 0.0}) {
    if (!_merchantBalances.containsKey(merchantId)) {
      _merchantBalances[merchantId] = initialBalance;
    }
  }

  // Get total customer balance
  double getTotalCustomerBalance() {
    return _customerWallets.values.fold(
      0.0,
      (sum, wallet) => sum + wallet['balance'],
    );
  }

  // Add listener
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

  // Reset to default balances (for testing)
  void resetBalances() {
    _customerWallets['gopay']!['balance'] = 250000.0;
    _customerWallets['ovo']!['balance'] = 150000.0;
    _customerWallets['bca']!['balance'] = 500000.0;
    _customerWallets['shopeepay']!['balance'] = 100000.0;
    _merchantBalances['MERCHANT001'] = 5000000.0;
    _notifyListeners();
  }

  // Get transaction summary
  Map<String, dynamic> getTransactionSummary({
    required String walletId,
    required String merchantId,
    required double amount,
  }) {
    final wallet = _customerWallets[walletId];
    final currentBalance = wallet?['balance'] ?? 0.0;
    final newBalance = currentBalance - amount;
    final merchantBalance = _merchantBalances[merchantId] ?? 0.0;
    final newMerchantBalance = merchantBalance + amount;

    return {
      'wallet_name': wallet?['name'] ?? 'Unknown',
      'current_balance': currentBalance,
      'new_balance': newBalance,
      'merchant_current_balance': merchantBalance,
      'merchant_new_balance': newMerchantBalance,
      'amount': amount,
      'has_sufficient_balance': currentBalance >= amount,
    };
  }
}
