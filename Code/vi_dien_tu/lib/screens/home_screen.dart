import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:vi_dien_tu/screens/expenses/add_expense_screen.dart';
import 'package:vi_dien_tu/screens/settings/settings_screen.dart';
import 'package:vi_dien_tu/widgets/expense_list.dart';
import 'package:vi_dien_tu/screens/expenses/statistics_screen.dart';
import 'package:vi_dien_tu/screens/calendar/calendar_screen.dart';
import 'package:vi_dien_tu/screens/wallet/wallet_screen.dart';
import 'package:vi_dien_tu/screens/transfer/transfer_screen.dart';
import 'package:vi_dien_tu/screens/transfer/wallet_transfer_screen.dart';
import 'package:vi_dien_tu/screens/services/bill_payment_screen.dart';
import 'package:vi_dien_tu/screens/services/mobile_topup_screen.dart';
import 'package:vi_dien_tu/screens/services/data_package_screen.dart';
import 'package:vi_dien_tu/screens/services/movie_tickets_screen.dart';
import 'package:vi_dien_tu/screens/services/travel_screen.dart';
import 'package:vi_dien_tu/screens/qr/qr_scanner_screen.dart';
import 'package:vi_dien_tu/screens/finance/stocks_screen.dart';
import 'package:vi_dien_tu/screens/finance/loans_screen.dart';
import 'package:vi_dien_tu/screens/finance/credit_wallet_screen.dart';
import 'package:vi_dien_tu/screens/games/quiz_arena_screen.dart';
import 'package:vi_dien_tu/screens/games/lucky_bag_screen.dart';
import 'package:vi_dien_tu/providers/wallet_provider.dart';
import 'package:vi_dien_tu/providers/expense_provider.dart';
import 'package:vi_dien_tu/providers/settings_provider.dart';
import 'package:vi_dien_tu/utils/translations.dart';

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

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

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
      backgroundColor: const Color(
          0xFFFFF8DC), // màu kem kem nhẹ nhàng
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          _buildMoMoHomePage(),
          const WalletScreen(),
          const TransferScreen(),
          const StatisticsScreen(),
          _buildMoreScreen(),
        ],
      ),
      bottomNavigationBar:
          Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor:
                const Color(0xffef3c7b),
            unselectedItemColor: Colors.grey,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Iconsax.home),
                label: 'MoMo',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Iconsax.gift),
                label: settings.isEnglish
                    ? 'Wallet'
                    : 'Ví',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Iconsax.scan_barcode),
                label: 'QR',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Iconsax.clock),
                label: settings.isEnglish
                    ? 'History'
                    : 'Lịch sử GD',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Iconsax.user),
                label: settings.isEnglish
                    ? 'Me'
                    : 'Tôi',
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMoMoHomePage() {
    return Consumer3<WalletProvider,
        ExpenseProvider, SettingsProvider>(
      builder: (context, walletProvider,
          expenseProvider, settings, child) {
        return Scaffold(
          backgroundColor: const Color(
              0xFFFFF8DC), // Vietnamese rice field inspired
          appBar: _buildMoMoAppBar(settings),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
                horizontal: 16),
            child: Stack(
              children: [
                // Background decorative elements
                Positioned(
                  top: 50,
                  right: 20,
                  child: Opacity(
                    opacity: 0.1,
                    child: Icon(
                      Icons.local_florist,
                      size: 80,
                      color: Colors.red[800],
                    ),
                  ),
                ),
                Positioned(
                  top: 200,
                  left: 10,
                  child: Opacity(
                    opacity: 0.1,
                    child: Icon(
                      Icons.star,
                      size: 60,
                      color: Colors.yellow[700],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 100,
                  right: 30,
                  child: Opacity(
                    opacity: 0.1,
                    child: Icon(
                      Icons.local_florist,
                      size: 70,
                      color: Colors.red[800],
                    ),
                  ),
                ),
                // Main content
                Column(
                  children: [
                    _buildSearchBar(settings),
                    const SizedBox(height: 16),
                    _buildMainActions(settings),
                    const SizedBox(height: 20),
                    _buildWalletInfo(
                        walletProvider, settings),
                    const SizedBox(height: 24),
                    _buildFinancialCenter(
                        settings),
                    const SizedBox(height: 8),
                    _buildServiceGrid(settings),
                    const SizedBox(height: 24),
                    _buildRecentTransactions(
                        expenseProvider,
                        settings),
                    const SizedBox(height: 16),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildMoMoAppBar(
      SettingsProvider settings) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFDA020E),
              Color(0xFFFFCD00)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Vào hình ngôi sao vàng
            Positioned(
              top: 30,
              left: 20,
              child: Icon(
                Icons.star,
                color: Colors.yellow[300],
                size: 20,
              ),
            ),
            Positioned(
              top: 45,
              right: 30,
              child: Icon(
                Icons.star,
                color: Colors.yellow[300],
                size: 16,
              ),
            ),
            Positioned(
              top: 25,
              right: 80,
              child: Icon(
                Icons.star,
                color: Colors.yellow[300],
                size: 18,
              ),
            ),
          ],
        ),
      ),
      title: Row(
        children: [
          // Cờ Việt Nam mini
          Container(
            width: 32,
            height: 20,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(4),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFDA020E),
                  Color(0xFFDA020E)
                ],
                stops: [0.5, 0.5],
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.star,
                color: Colors.yellow,
                size: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${Translations.get('hello', settings.isEnglish)} 🇻🇳',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Text(
                  'Nguyễn Minh Dương',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius:
                BorderRadius.circular(20),
          ),
          child: IconButton(
            icon: const Icon(Icons.notifications,
                color: Colors.white),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(
      SettingsProvider settings) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: 16),
      child: TextField(
        decoration: InputDecoration(
          hintText: settings.isEnglish
              ? 'Search contacts to transfer'
              : 'Tìm tên danh bạ chuyển',
          border: InputBorder.none,
          icon: const Icon(Icons.search),
        ),
      ),
    );
  }

  Widget _buildMainActions(
      SettingsProvider settings) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceAround,
      children: [
        _MoMoMainAction(
          icon: Iconsax.import,
          label: settings.isEnglish
              ? 'Top up/Withdraw'
              : 'Nạp/Rút',
          onTap: () => _onItemTapped(1),
        ),
        _MoMoMainAction(
          icon: Iconsax.receive_square,
          label: settings.isEnglish
              ? 'Receive Money'
              : 'Nhận tiền',
          onTap: () => _onItemTapped(2),
        ),
        _MoMoMainAction(
          icon: Icons.qr_code,
          label: settings.isEnglish
              ? 'QR Payment'
              : 'QR Thanh toán',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const QRScannerScreen()),
            );
          },
        ),
        _MoMoMainAction(
          icon: Iconsax.wallet_1,
          label: settings.isEnglish
              ? 'Utility Wallet'
              : 'Ví tiện ích',
          onTap: () => _onItemTapped(1),
        ),
      ],
    );
  }

  Widget _buildWalletInfo(
      WalletProvider walletProvider,
      SettingsProvider settings) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFDA020E),
            Color(0xFFFF6B6B),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDA020E)
                .withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Stack(
        children: [
          // Trang trí hình sen và lá cờ
          Positioned(
            top: -10,
            right: -10,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.yellow
                    .withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.local_florist,
                color: Colors.yellow,
                size: 30,
              ),
            ),
          ),
          Positioned(
            bottom: -5,
            left: -5,
            child: Icon(
              Icons.star,
              color:
                  Colors.yellow.withOpacity(0.6),
              size: 25,
            ),
          ),
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.account_balance_wallet,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    settings.isEnglish
                        ? 'SmartWallet VN 🇻🇳'
                        : 'Ví Thông Minh VN 🇻🇳',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text(
                    'Tổng số dư:',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _formatCurrency(walletProvider
                        .totalBalance),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.yellow
                      .withOpacity(0.2),
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.verified,
                      color: Colors.yellow,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      settings.isEnglish
                          ? 'Verified Vietnamese Account'
                          : 'Tài khoản Việt Nam xác thực',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight:
                            FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialCenter(
      SettingsProvider settings) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFCD00),
            Color(0xFFFFF3A0)
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: const Color(0xFFDA020E),
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star,
            color: Color(0xFFDA020E),
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            settings.isEnglish
                ? '🇻🇳 Financial Center Vietnam'
                : '🇻🇳 Trung Tâm Tài Chính Việt Nam',
            style: const TextStyle(
              color: Color(0xFFDA020E),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.star,
            color: Color(0xFFDA020E),
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildServiceGrid(
      SettingsProvider settings) {
    final services = [
      _ServiceData(
          Iconsax.chart,
          settings.isEnglish
              ? 'Stocks'
              : 'Chứng Khoán', () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const StocksScreen()),
        );
      }),
      _ServiceData(
          Iconsax.bank,
          settings.isEnglish
              ? 'Transfer'
              : 'Chuyển tiền', () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const WalletTransferScreen()),
        );
      }),
      _ServiceData(
          Iconsax.bill,
          settings.isEnglish
              ? 'Bill Payment'
              : 'Thanh toán hóa đơn', () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const BillPaymentScreen()),
        );
      }),
      _ServiceData(
          Iconsax.mobile,
          settings.isEnglish
              ? 'Mobile Top-up'
              : 'Nạp tiền điện thoại', () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const MobileTopupScreen()),
        );
      }),
      _ServiceData(
          Iconsax.data,
          settings.isEnglish
              ? 'Data 4G/5G'
              : 'Data 4G/5G', () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const DataPackageScreen()),
        );
      }),
      _ServiceData(
          Iconsax.medal_star,
          settings.isEnglish
              ? 'Quiz Arena'
              : 'Đấu Trường Tri Thức', () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const QuizArenaScreen()),
        );
      }),
      _ServiceData(
          Iconsax.money_recive,
          settings.isEnglish
              ? 'Lucky Bag'
              : 'Túi Thần Tài', () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const LuckyBagScreen()),
        );
      }),
      _ServiceData(
          Iconsax.wallet,
          settings.isEnglish
              ? 'Credit Wallet'
              : 'Ví Trả Sau', () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const CreditWalletScreen()),
        );
      }),
      _ServiceData(
          Iconsax.home,
          settings.isEnglish
              ? 'Loans'
              : 'Khoản vay', () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const LoansScreen()),
        );
      }),
      _ServiceData(
          Iconsax.video_play,
          settings.isEnglish
              ? 'Movie Tickets'
              : 'Mua vé xem phim', () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const MovieTicketsScreen()),
        );
      }),
      _ServiceData(
          Iconsax.airplane,
          settings.isEnglish
              ? 'Travel'
              : 'Du lịch - Đi lại', () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const TravelScreen()),
        );
      }),
      _ServiceData(
          Iconsax.menu,
          settings.isEnglish
              ? 'More'
              : 'Xem thêm',
          () => _onItemTapped(4)),
    ];

    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(),
      children: services
          .map((service) => _MoMoServiceIcon(
                service.icon,
                service.label,
                onTap: service.onTap,
              ))
          .toList(),
    );
  }

  Widget _buildRecentTransactions(
      ExpenseProvider expenseProvider,
      SettingsProvider settings) {
    return Container(
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
                Text(
                  Translations.get(
                      'recent_transactions',
                      settings.isEnglish),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      _onItemTapped(3),
                  child: Text(Translations.get(
                      'view_all',
                      settings.isEnglish)),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 300,
            child: ExpenseList(isCompact: true),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const AddExpenseScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xffef3c7b),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(
                          vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  Translations.get(
                      'add_transaction',
                      settings.isEnglish),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoreScreen() {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return Scaffold(
          backgroundColor:
              const Color(0xFFFFF8DC),
          appBar: AppBar(
            title: Text(
              settings.isEnglish
                  ? '👤 Profile'
                  : '👤 Hồ Sơ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            backgroundColor:
                const Color(0xFFDA020E),
            elevation: 0,
            automaticallyImplyLeading: false,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildDeveloperInfo(),
                const SizedBox(height: 24),
                _buildMoreOption(
                    Icons.calendar_today,
                    Translations.get('calendar',
                        settings.isEnglish), () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const CalendarScreen()),
                  );
                }),
                _buildMoreOption(
                    Icons.settings,
                    Translations.get('settings',
                        settings.isEnglish), () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const SettingsScreen()),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDeveloperInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFDA020E),
            Color(0xFFFFCD00)
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.school,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                '👨🎓 Thông Tin Sinh Viên',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildDeveloperInfoRow(
              'Họ và tên:', 'Nguyễn Minh Dương'),
          _buildDeveloperInfoRow(
              'MSSV:', '23010441'),
          _buildDeveloperInfoRow(
              'Lớp:', 'LTTBDD-1-1-25(N04)'),
          _buildDeveloperInfoRow('Nhóm:',
              '2025_LTTBDD_N04_Nhom_Duong'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color:
                  Colors.white.withOpacity(0.2),
              borderRadius:
                  BorderRadius.circular(20),
            ),
            child: const Text(
              '🇻🇳 SmartWallet Developer',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeveloperInfoRow(
      String label, String value) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
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

  String _formatCurrency(double amount) {
    return '${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ';
  }
}

class _MoMoMainAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MoMoMainAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor:
                const Color(0xfffff0f5),
            child: Icon(icon,
                color: const Color(0xffef3c7b)),
          ),
          const SizedBox(height: 6),
          Text(label,
              style:
                  const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class _MoMoServiceIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _MoMoServiceIcon(this.icon, this.label,
      {this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFDA020E),
                  Color(0xFFFF6B6B),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFDA020E)
                      .withOpacity(0.3),
                  spreadRadius: 0,
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                Positioned(
                  top: 2,
                  right: 2,
                  child: Icon(
                    Icons.star,
                    color: Colors.yellow
                        .withOpacity(0.8),
                    size: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF2C3E50),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceData {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  _ServiceData(this.icon, this.label, this.onTap);
}
