import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vi_dien_tu/screens/expenses/add_expense_screen.dart';
import 'package:vi_dien_tu/screens/settings/settings_screen.dart';
import 'package:vi_dien_tu/widgets/expense_list.dart';
import 'package:vi_dien_tu/screens/expenses/statistics_screen.dart';
import 'package:vi_dien_tu/screens/calendar/calendar_screen.dart';
import 'package:vi_dien_tu/screens/wallet/wallet_screen.dart';
import 'package:vi_dien_tu/screens/transfer/transfer_screen.dart';
import 'package:vi_dien_tu/providers/wallet_provider.dart';
import 'package:vi_dien_tu/providers/expense_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() =>
      _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late PageController _pageController;
  late AnimationController
      _fabAnimationController;

  final List<_TabInfo> _tabs = [
    _TabInfo(Icons.home_outlined, Icons.home,
        'Trang chủ', Colors.blue),
    _TabInfo(
        Icons.account_balance_wallet_outlined,
        Icons.account_balance_wallet,
        'Ví',
        Colors.green),
    _TabInfo(
        Icons.swap_horiz_outlined,
        Icons.swap_horiz,
        'Chuyển tiền',
        Colors.orange),
    _TabInfo(
        Icons.bar_chart_outlined,
        Icons.bar_chart,
        'Thống kê',
        Colors.purple),
    _TabInfo(Icons.more_horiz, Icons.more_horiz,
        'Khác', Colors.grey),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimationController.forward();

    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      context
          .read<WalletProvider>()
          .fetchWallets();
      context
          .read<ExpenseProvider>()
          .fetchExpenses();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          _buildDashboard(),
          const WalletScreen(),
          const TransferScreen(),
          const StatisticsScreen(),
          _buildMoreScreen(),
        ],
      ),
      bottomNavigationBar:
          _buildCustomBottomNav(),
      floatingActionButton: _selectedIndex == 0
          ? ScaleTransition(
              scale: _fabAnimationController,
              child:
                  FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const AddExpenseScreen()),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Thêm'),
                backgroundColor: Colors.teal,
              ),
            )
          : null,
    );
  }

  Widget _buildDashboard() {
    return Consumer2<WalletProvider,
        ExpenseProvider>(
      builder: (context, walletProvider,
          expenseProvider, child) {
        return CustomScrollView(
          slivers: [
            _buildSliverAppBar(walletProvider),
            SliverToBoxAdapter(
                child: _buildQuickActions()),
            SliverToBoxAdapter(
                child: _buildRecentTransactions(
                    expenseProvider)),
          ],
        );
      },
    );
  }

  Widget _buildSliverAppBar(
      WalletProvider walletProvider) {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF667eea),
                Color(0xFF764ba2)
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
                children: [
                  const Text(
                    'Xin chào!',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tổng tài sản',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    _formatCurrency(walletProvider
                        .totalBalance),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      _QuickAction(Icons.send, 'Chuyển tiền',
          Colors.blue, () => _onItemTapped(2)),
      _QuickAction(Icons.qr_code_scanner,
          'Quét QR', Colors.green, () {}),
      _QuickAction(Icons.receipt, 'Hóa đơn',
          Colors.orange, () {}),
      _QuickAction(Icons.more_horiz, 'Thêm',
          Colors.purple, () {}),
    ];

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Thao tác nhanh',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceAround,
            children: actions
                .map((action) =>
                    _buildActionButton(action))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(_QuickAction action) {
    return GestureDetector(
      onTap: action.onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color:
                  action.color.withOpacity(0.1),
              borderRadius:
                  BorderRadius.circular(20),
            ),
            child: Icon(
              action.icon,
              color: action.color,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            action.label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions(
      ExpenseProvider expenseProvider) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Giao dịch gần đây',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      _onItemTapped(3),
                  child: const Text('Xem tất cả'),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 300,
            child: ExpenseList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMoreScreen() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 60),
          _buildMoreOption(
              Icons.calendar_today, 'Lịch', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const CalendarScreen()),
            );
          }),
          _buildMoreOption(
              Icons.settings, 'Cài đặt', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const SettingsScreen()),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMoreOption(IconData icon,
      String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius:
                BorderRadius.circular(12),
          ),
          child:
              Icon(icon, color: Colors.grey[600]),
        ),
        title: Text(title),
        trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildCustomBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceAround,
            children: _tabs
                .asMap()
                .entries
                .map((entry) {
              final index = entry.key;
              final tab = entry.value;
              final isSelected =
                  _selectedIndex == index;

              return GestureDetector(
                onTap: () => _onItemTapped(index),
                child: AnimatedContainer(
                  duration: const Duration(
                      milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? tab.color
                            .withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize:
                        MainAxisSize.min,
                    children: [
                      Icon(
                        isSelected
                            ? tab.selectedIcon
                            : tab.icon,
                        color: isSelected
                            ? tab.color
                            : Colors.grey,
                        size: 24,
                      ),
                      if (isSelected) ...[
                        const SizedBox(width: 8),
                        Text(
                          tab.label,
                          style: TextStyle(
                            color: tab.color,
                            fontWeight:
                                FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  String _formatCurrency(double amount) {
    return '${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ';
  }
}

class _TabInfo {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final Color color;

  _TabInfo(this.icon, this.selectedIcon,
      this.label, this.color);
}

class _QuickAction {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  _QuickAction(this.icon, this.label, this.color,
      this.onTap);
}
