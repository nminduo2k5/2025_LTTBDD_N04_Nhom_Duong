import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:vi_dien_tu/providers/expense_provider.dart';
import 'package:vi_dien_tu/providers/wallet_provider.dart';
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
      backgroundColor: Colors.grey[50],
      body: Consumer2<ExpenseProvider,
          WalletProvider>(
        builder: (context, expenseProvider,
            walletProvider, child) {
          return CustomScrollView(
            slivers: [
              _buildSliverAppBar(expenseProvider,
                  walletProvider),
              SliverToBoxAdapter(
                  child: _buildPeriodSelector()),
              SliverToBoxAdapter(
                  child: _buildOverviewCards(
                      expenseProvider,
                      walletProvider)),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 400,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildCategoryChart(
                          expenseProvider),
                      _buildTrendChart(
                          expenseProvider),
                      _buildComparisonChart(
                          expenseProvider),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                  child: _buildInsights(
                      expenseProvider)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSliverAppBar(
      ExpenseProvider expenseProvider,
      WalletProvider walletProvider) {
    final totalIncome = expenseProvider.expenses
        .where((e) => e.type == 'Thu nhập')
        .fold(0.0,
            (sum, e) => sum + e.amount.abs());
    final totalExpense = expenseProvider.expenses
        .where((e) => e.type == 'Chi tiêu')
        .fold(0.0,
            (sum, e) => sum + e.amount.abs());

    return SliverAppBar(
      expandedHeight: 100,
      floating: false,
      pinned: true,
      backgroundColor: Colors.deepPurple,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.deepPurple,
                Colors.purpleAccent
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
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
        tabs: const [
          Tab(text: 'Danh mục'),
          Tab(text: 'Xu hướng'),
          Tab(text: 'So sánh'),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          Text(
            'Thời gian:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildPeriodChip(
                      'week', 'Tuần'),
                  _buildPeriodChip(
                      'month', 'Tháng'),
                  _buildPeriodChip(
                      'quarter', 'Quý'),
                  _buildPeriodChip('year', 'Năm'),
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
      WalletProvider walletProvider) {
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
            child: _buildOverviewCard(
              'Số dư hiện tại',
              _formatCurrency(
                  walletProvider.totalBalance),
              Icons.account_balance_wallet,
              Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildOverviewCard(
              'Lợi nhuận',
              '${balance >= 0 ? '+' : ''}${_formatCurrency(balance)}',
              Icons.trending_up,
              balance >= 0
                  ? Colors.green
                  : Colors.red,
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

  Widget _buildCategoryChart(
      ExpenseProvider expenseProvider) {
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
          const Text(
            'Chi tiêu theo danh mục',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
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
            const Expanded(
              child: Center(
                child: Text('Chưa có dữ liệu'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTrendChart(
      ExpenseProvider expenseProvider) {
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
      child: const Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            'Xu hướng chi tiêu',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Text('Đang phát triển...'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonChart(
      ExpenseProvider expenseProvider) {
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
      child: const Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            'So sánh thời gian',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Text('Đang phát triển...'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsights(
      ExpenseProvider expenseProvider) {
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
          const Text(
            'Nhận xét thông minh',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildInsightItem(
            Icons.lightbulb_outline,
            'Gợi ý tiết kiệm',
            'Bạn có thể tiết kiệm 15% bằng cách giảm chi tiêu ăn uống',
            Colors.orange,
          ),
          const SizedBox(height: 12),
          _buildInsightItem(
            Icons.trending_up,
            'Xu hướng tăng',
            'Chi tiêu của bạn tăng 8% so với tháng trước',
            Colors.red,
          ),
          const SizedBox(height: 12),
          _buildInsightItem(
            Icons.star_outline,
            'Thành tựu',
            'Bạn đã đạt mục tiêu tiết kiệm tháng này!',
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
