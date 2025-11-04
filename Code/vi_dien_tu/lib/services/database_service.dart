import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vi_dien_tu/models/wallet.dart';
import 'package:vi_dien_tu/models/expense.dart';
import 'package:vi_dien_tu/models/transaction.dart';
import 'package:vi_dien_tu/models/user.dart';

class DatabaseService {
  static const String _walletsKey = 'wallets';
  static const String _expensesKey = 'expenses';
  static const String _transactionsKey =
      'transactions';
  static const String _currentUserKey =
      'current_user';

  // Quản lý người dùng
  static Future<void> saveCurrentUser(
      User user) async {
    final prefs =
        await SharedPreferences.getInstance();
    await prefs.setString(_currentUserKey,
        jsonEncode(user.toJson()));
  }

  static Future<User?> getCurrentUser() async {
    final prefs =
        await SharedPreferences.getInstance();
    final userJson =
        prefs.getString(_currentUserKey);
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  static Future<void> clearCurrentUser() async {
    final prefs =
        await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }

  // Ví
  static Future<void> saveWallets(
      List<Wallet> wallets) async {
    final prefs =
        await SharedPreferences.getInstance();
    final walletsJson =
        wallets.map((w) => w.toJson()).toList();
    await prefs.setString(
        _walletsKey, jsonEncode(walletsJson));
  }

  static Future<List<Wallet>> getWallets() async {
    final prefs =
        await SharedPreferences.getInstance();
    final walletsJson =
        prefs.getString(_walletsKey);
    if (walletsJson != null) {
      final List<dynamic> decoded =
          jsonDecode(walletsJson);
      return decoded
          .map((w) => Wallet.fromJson(w))
          .toList();
    }
    // Trả về ví mẫu nếu không có
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

  // Chi tiêu
  static Future<void> saveExpenses(
      List<Expense> expenses) async {
    final prefs =
        await SharedPreferences.getInstance();
    final expensesJson =
        expenses.map((e) => e.toMap()).toList();
    await prefs.setString(
        _expensesKey, jsonEncode(expensesJson));
  }

  static Future<List<Expense>>
      getExpenses() async {
    final prefs =
        await SharedPreferences.getInstance();
    final expensesJson =
        prefs.getString(_expensesKey);
    if (expensesJson != null) {
      final List<dynamic> decoded =
          jsonDecode(expensesJson);
      return decoded
          .map((e) => Expense.fromMap(e))
          .toList();
    }
    // Trả về chi tiêu mẫu nếu không có
    return _getSampleExpenses();
  }

  static List<Expense> _getSampleExpenses() {
    final now = DateTime.now();
    return [
      // Thu nhập
      Expense(
        id: 'db_1',
        title: 'Lương tháng 1',
        amount: 15000000,
        category: 'Lương',
        date:
            now.subtract(const Duration(days: 2)),
        description: 'Lương tháng 1/2024',
        type: 'Thu nhập',
      ),
      Expense(
        id: 'db_2',
        title: 'Thưởng KPI',
        amount: 3000000,
        category: 'Thưởng',
        date:
            now.subtract(const Duration(days: 7)),
        description: 'Thưởng đạt KPI quý 4',
        type: 'Thu nhập',
      ),

      // Chi tiêu - Ăn uống
      Expense(
        id: 'db_3',
        title: 'Ăn trưa',
        amount: -50000,
        category: 'Ăn uống',
        date:
            now.subtract(const Duration(days: 1)),
        description: 'Cơm trưa công ty',
        type: 'Chi tiêu',
      ),
      Expense(
        id: 'db_4',
        title: 'Bánh mì sáng',
        amount: -25000,
        category: 'Ăn uống',
        date: now
            .subtract(const Duration(hours: 8)),
        description: 'Bánh mì thịt nướng',
        type: 'Chi tiêu',
      ),

      // Chi tiêu - Phương tiện
      Expense(
        id: 'db_5',
        title: 'Xăng xe',
        amount: -200000,
        category: 'Phương tiện',
        date: now,
        description: 'Đổ xăng xe máy',
        type: 'Chi tiêu',
      ),
      Expense(
        id: 'db_6',
        title: 'Grab',
        amount: -85000,
        category: 'Phương tiện',
        date:
            now.subtract(const Duration(days: 3)),
        description: 'Grab về nhà',
        type: 'Chi tiêu',
      ),

      // Chi tiêu - Nhà cửa
      Expense(
        id: 'db_7',
        title: 'Tiền nhà',
        amount: -3000000,
        category: 'Nhà cửa',
        date:
            now.subtract(const Duration(days: 1)),
        description: 'Tiền thuê nhà tháng 1',
        type: 'Chi tiêu',
      ),
      Expense(
        id: 'db_8',
        title: 'Tiền điện',
        amount: -450000,
        category: 'Nhà cửa',
        date:
            now.subtract(const Duration(days: 5)),
        description: 'Hóa đơn điện tháng 12',
        type: 'Chi tiêu',
      ),

      // Chi tiêu - Giải trí
      Expense(
        id: 'db_9',
        title: 'Xem phim',
        amount: -120000,
        category: 'Giải trí',
        date:
            now.subtract(const Duration(days: 4)),
        description: 'Vé xem phim CGV',
        type: 'Chi tiêu',
      ),
      Expense(
        id: 'db_10',
        title: 'Game online',
        amount: -200000,
        category: 'Giải trí',
        date: now
            .subtract(const Duration(days: 10)),
        description: 'Nạp thẻ game',
        type: 'Chi tiêu',
      ),
    ];
  }

  // Giao dịch
  static Future<void> saveTransactions(
      List<Transaction> transactions) async {
    final prefs =
        await SharedPreferences.getInstance();
    final transactionsJson = transactions
        .map((t) => t.toJson())
        .toList();
    await prefs.setString(_transactionsKey,
        jsonEncode(transactionsJson));
  }

  static Future<List<Transaction>>
      getTransactions() async {
    final prefs =
        await SharedPreferences.getInstance();
    final transactionsJson =
        prefs.getString(_transactionsKey);
    if (transactionsJson != null) {
      final List<dynamic> decoded =
          jsonDecode(transactionsJson);
      return decoded
          .map((t) => Transaction.fromJson(t))
          .toList();
    }
    // Trả về giao dịch mẫu nếu không có
    return _getSampleTransactions();
  }

  static List<Transaction>
      _getSampleTransactions() {
    final now = DateTime.now();
    return [
      // Hôm nay
      Transaction(
        id: 'tx_1',
        type: 'payment',
        amount: 25000,
        fromWalletId: '1',
        recipientName: 'Bánh mì Huỳnh Hoa',
        description: 'Bánh mì và cà phê sáng',
        createdAt: now
            .subtract(const Duration(hours: 2)),
        status: 'completed',
        transactionCode:
            'PAY${now.millisecondsSinceEpoch}001',
        fee: 0.0,
      ),
      Transaction(
        id: 'tx_2',
        type: 'payment',
        amount: 45000,
        fromWalletId: '2',
        recipientName: 'Cơm Tấm Sài Gòn',
        description: 'Cơm trưa văn phòng',
        createdAt: now
            .subtract(const Duration(hours: 4)),
        status: 'completed',
        transactionCode:
            'PAY${now.millisecondsSinceEpoch}002',
        fee: 1000.0,
      ),
      Transaction(
        id: 'tx_3',
        type: 'transfer',
        amount: 500000,
        fromWalletId: '2',
        toWalletId: '1',
        recipientName: 'Ví tiền mặt',
        description: 'Rút tiền mặt ATM',
        createdAt: now
            .subtract(const Duration(hours: 6)),
        status: 'completed',
        transactionCode:
            'TF${now.millisecondsSinceEpoch}003',
        fee: 3300.0,
      ),

      // Hôm qua
      Transaction(
        id: 'tx_4',
        type: 'payment',
        amount: 150000,
        fromWalletId: '1',
        recipientName: 'Xăng dầu Petrolimex',
        description: 'Đổ xăng xe máy',
        createdAt: now.subtract(
            const Duration(days: 1, hours: 2)),
        status: 'completed',
        transactionCode:
            'PAY${now.millisecondsSinceEpoch}004',
        fee: 0.0,
      ),
      Transaction(
        id: 'tx_5',
        type: 'payment',
        amount: 85000,
        fromWalletId: '2',
        recipientName: 'Grab',
        recipientInfo: '0987654321',
        description: 'Grab về nhà muộn',
        createdAt: now.subtract(
            const Duration(days: 1, hours: 8)),
        status: 'completed',
        transactionCode:
            'PAY${now.millisecondsSinceEpoch}005',
        fee: 2000.0,
      ),

      // 2 ngày trước
      Transaction(
        id: 'tx_6',
        type: 'payment',
        amount: 350000,
        fromWalletId: '3',
        recipientName: 'Nhà hàng Món Huế',
        description: 'Tiệc công ty cuối năm',
        createdAt: now.subtract(
            const Duration(days: 2, hours: 3)),
        status: 'completed',
        transactionCode:
            'PAY${now.millisecondsSinceEpoch}006',
        fee: 0.0,
      ),

      // 3 ngày trước
      Transaction(
        id: 'tx_7',
        type: 'receive',
        amount: 8500000,
        fromWalletId: '2',
        toWalletId: '2',
        recipientName: 'Công ty ABC',
        description: 'Lương tháng 12/2024',
        createdAt:
            now.subtract(const Duration(days: 3)),
        status: 'completed',
        transactionCode:
            'REC${now.millisecondsSinceEpoch}007',
        fee: 0.0,
      ),

      // 4 ngày trước
      Transaction(
        id: 'tx_8',
        type: 'payment',
        amount: 300000,
        fromWalletId: '2',
        recipientName: 'Bệnh viện Đa khoa',
        description: 'Khám tổng quát định kỳ',
        createdAt: now.subtract(
            const Duration(days: 4, hours: 5)),
        status: 'completed',
        transactionCode:
            'PAY${now.millisecondsSinceEpoch}008',
        fee: 0.0,
      ),

      // 5 ngày trước
      Transaction(
        id: 'tx_9',
        type: 'payment',
        amount: 450000,
        fromWalletId: '2',
        recipientName: 'EVN HCMC',
        description: 'Hóa đơn tiền điện tháng 12',
        createdAt:
            now.subtract(const Duration(days: 5)),
        status: 'completed',
        transactionCode:
            'PAY${now.millisecondsSinceEpoch}009',
        fee: 0.0,
      ),

      // 6 ngày trước
      Transaction(
        id: 'tx_10',
        type: 'payment',
        amount: 120000,
        fromWalletId: '1',
        recipientName: 'SAWACO',
        description: 'Hóa đơn tiền nước tháng 12',
        createdAt:
            now.subtract(const Duration(days: 6)),
        status: 'completed',
        transactionCode:
            'PAY${now.millisecondsSinceEpoch}010',
        fee: 0.0,
      ),

      // 1 tuần trước
      Transaction(
        id: 'tx_11',
        type: 'payment',
        amount: 85000,
        fromWalletId: '1',
        recipientName: 'Nhà thuốc Long Châu',
        description: 'Mua thuốc cảm cúm',
        createdAt:
            now.subtract(const Duration(days: 7)),
        status: 'completed',
        transactionCode:
            'PAY${now.millisecondsSinceEpoch}011',
        fee: 0.0,
      ),
      Transaction(
        id: 'tx_12',
        type: 'receive',
        amount: 2000000,
        fromWalletId: '2',
        toWalletId: '2',
        recipientName: 'Khách hàng XYZ',
        description: 'Freelance thiết kế website',
        createdAt:
            now.subtract(const Duration(days: 8)),
        status: 'completed',
        transactionCode:
            'REC${now.millisecondsSinceEpoch}012',
        fee: 0.0,
      ),
    ];
  }

  // Xóa tất cả dữ liệu
  static Future<void> clearAllData() async {
    final prefs =
        await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
