import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:vi_dien_tu/providers/expense_provider.dart';
import 'package:vi_dien_tu/providers/settings_provider.dart';
import 'package:vi_dien_tu/services/database_service.dart';
import 'package:vi_dien_tu/services/api_service.dart';
import 'package:vi_dien_tu/models/transaction.dart';
import 'package:vi_dien_tu/models/expense.dart';
import 'package:vi_dien_tu/screens/expenses/statistics_screen.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<Transaction> _transactions = [];
  List<Expense> _apiExpenses = [];
  List<Expense> _dbExpenses = [];
  bool _isLoading = true;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadAllData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAllData() async {
    try {
      final transactions = await DatabaseService.getTransactions();
      final apiExpenses = await _apiService.getAllExpenses();
      final dbExpenses = await DatabaseService.getExpenses();
      
      setState(() {
        _transactions = transactions;
        _apiExpenses = apiExpenses;
        _dbExpenses = dbExpenses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8DC),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return CustomScrollView(
            slivers: [
              _buildSliverAppBar(settings),
              SliverToBoxAdapter(child: _buildOverviewCards(settings)),
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: const Color(0xFFDA020E),
                    labelColor: const Color(0xFFDA020E),
                    unselectedLabelColor: Colors.grey,
                    isScrollable: true,
                    tabs: [
                      Tab(text: settings.isEnglish ? 'All' : 'Tất cả'),
                      Tab(text: settings.isEnglish ? 'Transfers' : 'Chuyển tiền'),
                      Tab(text: settings.isEnglish ? 'Expenses' : 'Chi tiêu'),
                      Tab(text: settings.isEnglish ? 'Statistics' : 'Thống kê'),
                    ],
                  ),
                ),
              ),
              SliverFillRemaining(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildAllTransactions(settings),
                    _buildTransferHistory(settings),
                    _buildExpenseHistory(settings),
                    const StatisticsScreen(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSliverAppBar(SettingsProvider settings) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: const Color(0xFFDA020E),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          settings.isEnglish ? 'Transaction History' : 'Lịch sử giao dịch',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFDA020E),
                Color(0xFFFF6B6B),
                Color(0xFFFFCD00),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      automaticallyImplyLeading: false,
    );
  }

  Widget _buildOverviewCards(SettingsProvider settings) {
    if (_isLoading) return const SizedBox();

    final totalTransactions = _transactions.length + _apiExpenses.length + _dbExpenses.length;
    final totalIncome = (_apiExpenses + _dbExpenses)
        .where((e) => e.type == 'Thu nhập')
        .fold(0.0, (sum, e) => sum + e.amount.abs());
    final totalExpense = (_apiExpenses + _dbExpenses)
        .where((e) => e.type == 'Chi tiêu')
        .fold(0.0, (sum, e) => sum + e.amount.abs());

    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildOverviewCard(
              settings.isEnglish ? 'Total Transactions' : 'Tổng giao dịch',
              totalTransactions.toString(),
              Icons.receipt_long,
              Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildOverviewCard(
              settings.isEnglish ? 'Net Balance' : 'Số dư ròng',
              _formatCurrency(totalIncome - totalExpense),
              Icons.account_balance,
              totalIncome >= totalExpense ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllTransactions(SettingsProvider settings) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final allItems = <Map<String, dynamic>>[];
    
    for (var transaction in _transactions) {
      allItems.add({
        'type': 'transaction',
        'data': transaction,
        'date': transaction.createdAt,
        'source': 'database',
      });
    }
    
    for (var expense in _apiExpenses) {
      allItems.add({
        'type': 'expense',
        'data': expense,
        'date': expense.date,
        'source': 'api',
      });
    }

    for (var expense in _dbExpenses) {
      allItems.add({
        'type': 'expense',
        'data': expense,
        'date': expense.date,
        'source': 'database',
      });
    }
    
    allItems.sort((a, b) => b['date'].compareTo(a['date']));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: allItems.length,
      itemBuilder: (context, index) {
        final item = allItems[index];
        if (item['type'] == 'transaction') {
          return _buildTransactionItem(item['data'] as Transaction, settings, item['source']);
        } else {
          return _buildExpenseItem(item['data'] as Expense, settings, item['source']);
        }
      },
    );
  }

  Widget _buildTransferHistory(SettingsProvider settings) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _transactions.length,
      itemBuilder: (context, index) {
        return _buildTransactionItem(_transactions[index], settings, 'database');
      },
    );
  }

  Widget _buildExpenseHistory(SettingsProvider settings) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final allExpenses = [..._apiExpenses, ..._dbExpenses];
    allExpenses.sort((a, b) => b.date.compareTo(a.date));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: allExpenses.length,
      itemBuilder: (context, index) {
        final expense = allExpenses[index];
        final source = _apiExpenses.contains(expense) ? 'api' : 'database';
        return _buildExpenseItem(expense, settings, source);
      },
    );
  }

  Widget _buildTransactionItem(Transaction transaction, SettingsProvider settings, String source) {
    IconData icon;
    Color color;
    String title;

    switch (transaction.type) {
      case 'transfer':
        icon = Icons.swap_horiz;
        color = Colors.blue;
        title = settings.isEnglish ? 'Transfer' : 'Chuyển tiền';
        break;
      case 'payment':
        icon = Icons.payment;
        color = Colors.red;
        title = settings.isEnglish ? 'Payment' : 'Thanh toán';
        break;
      case 'receive':
        icon = Icons.call_received;
        color = Colors.green;
        title = settings.isEnglish ? 'Received' : 'Nhận tiền';
        break;
      default:
        icon = Icons.account_balance_wallet;
        color = Colors.grey;
        title = transaction.type;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: source == 'api' ? Colors.orange.withOpacity(0.3) : Colors.blue.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Row(
          children: [
            Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: source == 'api' ? Colors.orange : Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                source.toUpperCase(),
                style: const TextStyle(color: Colors.white, fontSize: 8),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(transaction.recipientName ?? ''),
            Text(transaction.description ?? ''),
            Text(DateFormat('dd/MM/yyyy HH:mm').format(transaction.createdAt)),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${transaction.type == 'receive' ? '+' : '-'}${_formatCurrency(transaction.amount)}',
              style: TextStyle(
                color: transaction.type == 'receive' ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (transaction.fee != null && transaction.fee! > 0)
              Text('Phí: ${_formatCurrency(transaction.fee!)}', style: const TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseItem(Expense expense, SettingsProvider settings, String source) {
    final isIncome = expense.type == 'Thu nhập';
    final color = isIncome ? Colors.green : Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: source == 'api' ? Colors.orange.withOpacity(0.3) : Colors.blue.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(_getCategoryIcon(expense.category), color: color, size: 24),
        ),
        title: Row(
          children: [
            Expanded(child: Text(expense.title, style: const TextStyle(fontWeight: FontWeight.w600))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: source == 'api' ? Colors.orange : Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                source.toUpperCase(),
                style: const TextStyle(color: Colors.white, fontSize: 8),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(expense.category),
            Text(expense.description ?? ''),
            Text(DateFormat('dd/MM/yyyy').format(expense.date)),
          ],
        ),
        trailing: Text(
          '${isIncome ? '+' : '-'}${_formatCurrency(expense.amount.abs())}',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'ăn uống': return Icons.restaurant;
      case 'di chuyển': return Icons.directions_car;
      case 'nhà cửa': return Icons.home;
      case 'sức khỏe': return Icons.local_hospital;
      case 'giải trí': return Icons.movie;
      case 'quần áo': return Icons.shopping_bag;
      case 'giáo dục': return Icons.school;
      case 'du lịch': return Icons.flight;
      case 'lương': return Icons.work;
      default: return Icons.category;
    }
  }

  String _formatCurrency(double amount) {
    return '${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ';
  }
}