import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vi_dien_tu/providers/wallet_provider.dart';
import 'package:vi_dien_tu/providers/settings_provider.dart';
import 'package:vi_dien_tu/models/wallet.dart';
import 'package:vi_dien_tu/screens/wallet/add_wallet_screen.dart';
import 'package:vi_dien_tu/screens/transfer/wallet_transfer_screen.dart';
import 'package:vi_dien_tu/screens/expenses/statistics_screen.dart';
import 'package:vi_dien_tu/utils/translations.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() =>
      _WalletScreenState();
}

class _WalletScreenState
    extends State<WalletScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      context
          .read<WalletProvider>()
          .fetchWallets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8DC),
      body: Consumer<WalletProvider>(
        builder:
            (context, walletProvider, child) {
          if (walletProvider.wallets.isEmpty) {
            return _buildEmptyState();
          }

          return CustomScrollView(
            slivers: [
              _buildSliverAppBar(walletProvider),
              SliverToBoxAdapter(
                  child: _buildQuickActions()),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.6,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  delegate:
                      SliverChildBuilderDelegate(
                    (context, index) {
                      final wallet =
                          walletProvider
                              .wallets[index];
                      return _buildModernWalletCard(
                          wallet, walletProvider);
                    },
                    childCount: walletProvider
                        .wallets.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const AddWalletScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: Consumer<SettingsProvider>(
          builder: (context, settings, child) {
            return Text(settings.isEnglish ? 'Add Wallet VN' : 'Thêm Ví VN');
          },
        ),
        backgroundColor: const Color(0xFFDA020E),
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildSliverAppBar(
      WalletProvider walletProvider) {
    return SliverAppBar(
      expandedHeight: 220,
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
              stops: [0.0, 0.7, 1.0],
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                // Decorative stars
                Positioned(
                  top: 30,
                  right: 30,
                  child: Icon(
                    Icons.star,
                    color: Colors.yellow
                        .withOpacity(0.6),
                    size: 25,
                  ),
                ),
                Positioned(
                  top: 60,
                  left: 40,
                  child: Icon(
                    Icons.local_florist,
                    color: Colors.yellow
                        .withOpacity(0.4),
                    size: 30,
                  ),
                ),
                Positioned(
                  bottom: 40,
                  right: 50,
                  child: Icon(
                    Icons.star,
                    color: Colors.yellow
                        .withOpacity(0.5),
                    size: 20,
                  ),
                ),
                // Main content
                Padding(
                  padding:
                      const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    mainAxisAlignment:
                        MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons
                                .account_balance_wallet,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(
                              width: 8),
                          Consumer<SettingsProvider>(
                            builder: (context, settings, child) {
                              return Text(
                                settings.isEnglish ? 'Total Assets Vietnam' : 'Tổng tài sản Việt Nam',
                                style: const TextStyle(
                                  color:
                                      Colors.white70,
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight.w500,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatCurrency(
                            walletProvider
                                .totalBalance),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets
                            .symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white
                              .withOpacity(0.2),
                          borderRadius:
                              BorderRadius
                                  .circular(12),
                        ),
                        child: Consumer<SettingsProvider>(
                          builder: (context, settings, child) {
                            return Text(
                              settings.isEnglish 
                                ? '${walletProvider.wallets.length} wallets • Currency: VND'
                                : '${walletProvider.wallets.length} ví • Đơn vị: VNĐ',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight:
                                    FontWeight.w500,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Consumer<SettingsProvider>(
              builder: (context, settings, child) {
                return _buildActionButton(
                  icon: Icons.swap_horiz,
                  label: settings.isEnglish ? 'Transfer' : 'Chuyển ví',
                  color: Colors.blue,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WalletTransferScreen(),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Consumer<SettingsProvider>(
              builder: (context, settings, child) {
                return _buildActionButton(
                  icon: Icons.history,
                  label: settings.isEnglish ? 'History' : 'Lịch sử',
                  color: Colors.orange,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StatisticsScreen(),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Consumer<SettingsProvider>(
              builder: (context, settings, child) {
                return _buildActionButton(
                  icon: Icons.analytics,
                  label: settings.isEnglish ? 'Reports' : 'Báo cáo',
                  color: Colors.purple,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StatisticsScreen(),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernWalletCard(Wallet wallet,
      WalletProvider walletProvider) {
    final isSelected =
        walletProvider.selectedWallet?.id ==
            wallet.id;

    return GestureDetector(
      onTap: () {
        walletProvider.selectWallet(wallet);
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(int.parse(wallet.color
                  .replaceFirst('#', '0xFF'))),
              Color(int.parse(wallet.color
                      .replaceFirst('#', '0xFF')))
                  .withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Color(int.parse(wallet.color
                      .replaceFirst('#', '0xFF')))
                  .withOpacity(0.3),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: isSelected
              ? Border.all(
                  color: Colors.white, width: 2)
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                children: [
                  Icon(
                    _getWalletIcon(wallet.type),
                    color: Colors.white,
                    size: 24,
                  ),
                  if (wallet.isDefault)
                    Container(
                      padding: const EdgeInsets
                          .symmetric(
                          horizontal: 6,
                          vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white
                            .withOpacity(0.2),
                        borderRadius:
                            BorderRadius.circular(
                                8),
                      ),
                      child: Consumer<SettingsProvider>(
                        builder: (context, settings, child) {
                          return Text(
                            settings.isEnglish ? 'Default' : 'Mặc định',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight:
                                  FontWeight.w500,
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
              const Spacer(),
              Text(
                wallet.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                _formatCurrency(wallet.balance),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _getWalletTypeText(wallet.type),
                style: TextStyle(
                  color: Colors.white
                      .withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons
                  .account_balance_wallet_outlined,
              size: 60,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          Consumer<SettingsProvider>(
            builder: (context, settings, child) {
              return Column(
                children: [
                  Text(
                    Translations.get('no_wallets', settings.isEnglish),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    Translations.get('create_first_wallet', settings.isEnglish),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const AddWalletScreen()),
              );
            },
            icon: const Icon(Icons.add),
            label: Consumer<SettingsProvider>(
              builder: (context, settings, child) {
                return Text(Translations.get('add_wallet', settings.isEnglish));
              },
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xffef3c7b),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getWalletIcon(String type) {
    switch (type) {
      case 'cash':
        return Icons.account_balance_wallet;
      case 'bank':
        return Icons.account_balance;
      case 'credit':
        return Icons.credit_card;
      case 'savings':
        return Icons.savings;
      default:
        return Icons.account_balance_wallet;
    }
  }

  String _getWalletTypeText(String type) {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    if (settings.isEnglish) {
      switch (type) {
        case 'cash':
          return 'Cash';
        case 'bank':
          return 'Bank Account';
        case 'credit':
          return 'Credit Card';
        case 'savings':
          return 'Savings Account';
        default:
          return 'Other';
      }
    } else {
      switch (type) {
        case 'cash':
          return 'Tiền mặt';
        case 'bank':
          return 'Tài khoản ngân hàng';
        case 'credit':
          return 'Thẻ tín dụng';
        case 'savings':
          return 'Tài khoản tiết kiệm';
        default:
          return 'Khác';
      }
    }
  }

  String _formatCurrency(double amount) {
    return '${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ';
  }
}
