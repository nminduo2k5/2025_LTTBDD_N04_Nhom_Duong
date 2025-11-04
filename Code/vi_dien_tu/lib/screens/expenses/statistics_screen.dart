import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:vi_dien_tu/providers/expense_provider.dart';
import 'package:vi_dien_tu/providers/wallet_provider.dart';
import 'package:vi_dien_tu/providers/settings_provider.dart';
import 'package:vi_dien_tu/utils/translations.dart';
import 'package:intl/intl.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() =>
      _StatisticsScreenState();
}

class _StatisticsScreenState
    extends State<StatisticsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'month';

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<PieChartSectionData> _getSections(
      Map<String, double> data) {
    final List<Color> colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.yellow,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.brown,
      Colors.grey,
      Colors.cyan,
      Colors.amber,
      Colors.lime,
      Colors.deepOrange,
      Colors.deepPurple,
    ];
    return data.entries.map((entry) {
      final index =
          data.keys.toList().indexOf(entry.key);
      final color = colors[index % colors.length];
      return PieChartSectionData(
        color: color,
        value: entry.value.abs(),
        title: '',
        radius: 80,
        showTitle: false,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8DC),
      body: Consumer3<ExpenseProvider,
          WalletProvider, SettingsProvider>(
        builder: (context, expenseProvider,
            walletProvider, settings, child) {
          return CustomScrollView(
            slivers: [
              _buildSliverAppBar(expenseProvider,
                  walletProvider, settings),
              SliverToBoxAdapter(
                  child: _buildPeriodSelector(settings)),
              SliverToBoxAdapter(
                  child: _buildOverviewCards(
                      expenseProvider,
                      walletProvider, settings)),
              // Danh sách giao dịch
              SliverToBoxAdapter(
                child: _buildTransactionsList(
                    expenseProvider, settings),
              ),
              // Biểu đồ chi tiêu
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 400,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildCategoryChart(
                          expenseProvider, settings),
                      _buildTrendChart(
                          expenseProvider, settings),
                      _buildComparisonChart(
                          expenseProvider, settings),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                  child: _buildInsights(
                      expenseProvider, settings)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSliverAppBar(
      ExpenseProvider expenseProvider,
      WalletProvider walletProvider,
      SettingsProvider settings) {
    final totalIncome = expenseProvider.expenses
        .where((e) => e.type == 'Thu nhập')
        .fold(0.0,
            (sum, e) => sum + e.amount.abs());
    final totalExpense = expenseProvider.expenses
        .where((e) => e.type == 'Chi tiêu')
        .fold(0.0,
            (sum, e) => sum + e.amount.abs());

    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: const Color(0xFFDA020E),
      flexibleSpace: FlexibleSpaceBar(
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
              stops: [0.0, 0.6, 1.0],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                mainAxisAlignment:
                    MainAxisAlignment.end,
                children: [],
              ),
            ),
          ),
        ),
      ),
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: Colors.white,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        tabs: [
          Tab(text: Provider.of<SettingsProvider>(context).isEnglish ? 'Categories' : 'Danh mục'),
          Tab(text: Provider.of<SettingsProvider>(context).isEnglish ? 'Trends' : 'Xu hướng'),
          Tab(text: Provider.of<SettingsProvider>(context).isEnglish ? 'Compare' : 'So sánh'),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector(SettingsProvider settings) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          Consumer<SettingsProvider>(
            builder: (context, settings, child) {
              return Text(
                settings.isEnglish ? 'Period:' : 'Thời gian:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              );
            },
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Consumer<SettingsProvider>(
                    builder: (context, settings, child) {
                      return Row(
                        children: [
                          _buildPeriodChip(
                              'week', settings.isEnglish ? 'Week' : 'Tuần'),
                          _buildPeriodChip(
                              'month', settings.isEnglish ? 'Month' : 'Tháng'),
                          _buildPeriodChip(
                              'quarter', settings.isEnglish ? 'Quarter' : 'Quý'),
                          _buildPeriodChip('year', settings.isEnglish ? 'Year' : 'Năm'),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodChip(
      String period, String label) {
    final isSelected = _selectedPeriod == period;

    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedPeriod = period;
          });
        },
        backgroundColor: Colors.white,
        selectedColor:
            Colors.deepPurple.withOpacity(0.2),
        checkmarkColor: Colors.deepPurple,
      ),
    );
  }

  Widget _buildOverviewCards(
      ExpenseProvider expenseProvider,
      WalletProvider walletProvider,
      SettingsProvider settings) {
    final totalIncome = expenseProvider.expenses
        .where((e) => e.type == 'Thu nhập')
        .fold(0.0,
            (sum, e) => sum + e.amount.abs());
    final totalExpense = expenseProvider.expenses
        .where((e) => e.type == 'Chi tiêu')
        .fold(0.0,
            (sum, e) => sum + e.amount.abs());
    final balance = totalIncome - totalExpense;

    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Consumer<SettingsProvider>(
              builder: (context, settings, child) {
                return _buildOverviewCard(
                  settings.isEnglish ? 'Current Balance' : 'Số dư hiện tại',
                  _formatCurrency(
                      walletProvider.totalBalance),
                  Icons.account_balance_wallet,
                  Colors.blue,
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Consumer<SettingsProvider>(
              builder: (context, settings, child) {
                return _buildOverviewCard(
                  settings.isEnglish ? 'Profit' : 'Lợi nhuận',
                  '${balance >= 0 ? '+' : ''}${_formatCurrency(balance)}',
                  Icons.trending_up,
                  balance >= 0
                      ? Colors.green
                      : Colors.red,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard(String title,
      String value, IconData icon, Color color) {
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
        crossAxisAlignment:
            CrossAxisAlignment.start,
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

  Widget _buildTransactionsList(
      ExpenseProvider expenseProvider,
      SettingsProvider settings) {
    final recentTransactions = expenseProvider.expenses
        .take(10)
        .toList();

    return Container(
      margin: const EdgeInsets.all(16),
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
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  settings.isEnglish ? 'Recent Transactions' : 'Giao dịch gần đây',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  settings.isEnglish ? 'View All' : 'Xem tất cả',
                  style: TextStyle(
                    color: Colors.blue[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (recentTransactions.isNotEmpty)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentTransactions.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: Colors.grey[200],
              ),
              itemBuilder: (context, index) {
                final expense = recentTransactions[index];
                final isIncome = expense.type == 'Thu nhập';
                final color = isIncome ? Colors.green : Colors.red;
                
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getCategoryIcon(expense.category),
                      color: color,
                      size: 24,
                    ),
                  ),
                  title: Text(
                    expense.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        expense.category,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy').format(expense.date),
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  trailing: Text(
                    '${isIncome ? '+' : '-'}${_formatCurrency(expense.amount.abs())}',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                );
              },
            )
          else
            Padding(
              padding: const EdgeInsets.all(40),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.receipt_long,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      settings.isEnglish ? 'No transactions yet' : 'Chưa có giao dịch nào',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'ăn uống':
        return Icons.restaurant;
      case 'di chuyển':
        return Icons.directions_car;
      case 'nhà cửa':
        return Icons.home;
      case 'sức khỏe':
        return Icons.local_hospital;
      case 'giải trí':
        return Icons.movie;
      case 'quần áo':
        return Icons.shopping_bag;
      case 'giáo dục':
        return Icons.school;
      case 'du lịch':
        return Icons.flight;
      case 'lương':
        return Icons.work;
      case 'thưởng':
        return Icons.card_giftcard;
      case 'bán hàng':
        return Icons.store;
      case 'đầu tư':
        return Icons.trending_up;
      default:
        return Icons.category;
    }
  }

  Widget _buildCategoryChart(
      ExpenseProvider expenseProvider,
      SettingsProvider settings) {
    final categoryExpenses = <String, double>{};

    for (var expense
        in expenseProvider.expenses) {
      if (expense.type == 'Chi tiêu') {
        categoryExpenses[expense.category] =
            (categoryExpenses[expense.category] ??
                    0) +
                expense.amount.abs();
      }
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Consumer<SettingsProvider>(
            builder: (context, settings, child) {
              return Text(
                settings.isEnglish ? 'Expenses by Category' : 'Chi tiêu theo danh mục',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          if (categoryExpenses.isNotEmpty)
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: _getSections(
                      categoryExpenses),
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            )
          else
            Expanded(
              child: Center(
                child: Consumer<SettingsProvider>(
                  builder: (context, settings, child) {
                    return Text(settings.isEnglish ? 'No data available' : 'Chưa có dữ liệu');
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTrendChart(
      ExpenseProvider expenseProvider,
      SettingsProvider settings) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            settings.isEnglish ? 'Spending Trends' : 'Xu hướng chi tiêu',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Text(settings.isEnglish ? 'Coming soon...' : 'Đang phát triển...'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonChart(
      ExpenseProvider expenseProvider,
      SettingsProvider settings) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            settings.isEnglish ? 'Time Comparison' : 'So sánh thời gian',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Text(settings.isEnglish ? 'Coming soon...' : 'Đang phát triển...'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsights(
      ExpenseProvider expenseProvider,
      SettingsProvider settings) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            settings.isEnglish ? 'Smart Insights' : 'Nhận xét thông minh',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildInsightItem(
            Icons.lightbulb_outline,
            settings.isEnglish ? 'Saving Tips' : 'Gợi ý tiết kiệm',
            settings.isEnglish 
              ? 'You can save 15% by reducing food expenses'
              : 'Bạn có thể tiết kiệm 15% bằng cách giảm chi tiêu ăn uống',
            Colors.orange,
          ),
          const SizedBox(height: 12),
          _buildInsightItem(
            Icons.trending_up,
            settings.isEnglish ? 'Increasing Trend' : 'Xu hướng tăng',
            settings.isEnglish 
              ? 'Your spending increased 8% compared to last month'
              : 'Chi tiêu của bạn tăng 8% so với tháng trước',
            Colors.red,
          ),
          const SizedBox(height: 12),
          _buildInsightItem(
            Icons.star_outline,
            settings.isEnglish ? 'Achievement' : 'Thành tựu',
            settings.isEnglish 
              ? 'You achieved your savings goal this month!'
              : 'Bạn đã đạt mục tiêu tiết kiệm tháng này!',
            Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildInsightItem(
      IconData icon,
      String title,
      String description,
      Color color) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius:
                BorderRadius.circular(10),
          ),
          child:
              Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatCurrency(double amount) {
    return '${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ';
  }
}
