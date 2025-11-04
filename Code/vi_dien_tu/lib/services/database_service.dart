import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vi_dien_tu/models/wallet.dart';
import 'package:vi_dien_tu/models/expense.dart';
import 'package:vi_dien_tu/models/transaction.dart';
import 'package:vi_dien_tu/models/user.dart';

class DatabaseService {
  static const String _walletsKey = 'wallets';
  static const String _expensesKey = 'expenses';
  static const String _transactionsKey = 'transactions';
  static const String _currentUserKey = 'current_user';

  // User Management
  static Future<void> saveCurrentUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserKey, jsonEncode(user.toJson()));
  }

  static Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_currentUserKey);
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  static Future<void> clearCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }

  // Wallets
  static Future<void> saveWallets(List<Wallet> wallets) async {
    final prefs = await SharedPreferences.getInstance();
    final walletsJson = wallets.map((w) => w.toJson()).toList();
    await prefs.setString(_walletsKey, jsonEncode(walletsJson));
  }

  static Future<List<Wallet>> getWallets() async {
    final prefs = await SharedPreferences.getInstance();
    final walletsJson = prefs.getString(_walletsKey);
    if (walletsJson != null) {
      final List<dynamic> decoded = jsonDecode(walletsJson);
      return decoded.map((w) => Wallet.fromJson(w)).toList();
    }
    // Return sample wallets if none exist
    return _getSampleWallets();
  }

  static List<Wallet> _getSampleWallets() {
    return [
      Wallet(
        id: '1',
        name: 'Ví tiền mặt',
        type: 'cash',
        balance: 2500000,
        currency: 'VND',
        isDefault: true,
        color: '#4CAF50',
        icon: 'wallet',
      ),
      Wallet(
        id: '2',
        name: 'Techcombank',
        type: 'bank',
        balance: 15000000,
        currency: 'VND',
        bankName: 'Techcombank',
        accountNumber: '1234567890',
        isDefault: false,
        color: '#2196F3',
        icon: 'bank',
      ),
      Wallet(
        id: '3',
        name: 'Thẻ tín dụng',
        type: 'credit',
        balance: 5000000,
        currency: 'VND',
        isDefault: false,
        color: '#FF9800',
        icon: 'credit_card',
      ),
    ];
  }

  // Expenses
  static Future<void> saveExpenses(List<Expense> expenses) async {
    final prefs = await SharedPreferences.getInstance();
    final expensesJson = expenses.map((e) => e.toMap()).toList();
    await prefs.setString(_expensesKey, jsonEncode(expensesJson));
  }

  static Future<List<Expense>> getExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final expensesJson = prefs.getString(_expensesKey);
    if (expensesJson != null) {
      final List<dynamic> decoded = jsonDecode(expensesJson);
      return decoded.map((e) => Expense.fromMap(e)).toList();
    }
    // Return sample expenses if none exist
    return _getSampleExpenses();
  }

  static List<Expense> _getSampleExpenses() {
    return [
      Expense(
        id: '1',
        title: 'Lương tháng 1',
        amount: 15000000,
        category: 'Lương',
        date: DateTime.now().subtract(const Duration(days: 2)),
        description: 'Lương tháng 1/2024',
        type: 'Thu nhập',
      ),
      Expense(
        id: '2',
        title: 'Ăn trưa',
        amount: -50000,
        category: 'Ăn uống',
        date: DateTime.now().subtract(const Duration(days: 1)),
        description: 'Cơm trưa công ty',
        type: 'Chi tiêu',
      ),
      Expense(
        id: '3',
        title: 'Xăng xe',
        amount: -200000,
        category: 'Phương tiện',
        date: DateTime.now(),
        description: 'Đổ xăng xe máy',
        type: 'Chi tiêu',
      ),
    ];
  }

  // Transactions
  static Future<void> saveTransactions(List<Transaction> transactions) async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsJson = transactions.map((t) => t.toJson()).toList();
    await prefs.setString(_transactionsKey, jsonEncode(transactionsJson));
  }

  static Future<List<Transaction>> getTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsJson = prefs.getString(_transactionsKey);
    if (transactionsJson != null) {
      final List<dynamic> decoded = jsonDecode(transactionsJson);
      return decoded.map((t) => Transaction.fromJson(t)).toList();
    }
    // Return sample transactions if none exist
    return _getSampleTransactions();
  }

  static List<Transaction> _getSampleTransactions() {
    return [
      Transaction(
        id: '1',
        type: 'transfer',
        amount: 500000,
        fromWalletId: '2',
        toWalletId: '1',
        recipientName: 'Ví tiền mặt',
        description: 'Rút tiền mặt',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        status: 'completed',
        transactionCode: 'TF1704067200000',
        fee: 0.0,
      ),
      Transaction(
        id: '2',
        type: 'payment',
        amount: 150000,
        fromWalletId: '1',
        recipientName: 'Grab',
        recipientInfo: '0987654321',
        description: 'Thanh toán Grab',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        status: 'completed',
        transactionCode: 'PAY1704067200001',
        fee: 2000.0,
      ),
    ];
  }

  // Clear all data
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}