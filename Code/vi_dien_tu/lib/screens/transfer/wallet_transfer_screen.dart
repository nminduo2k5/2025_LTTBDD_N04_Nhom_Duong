import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vi_dien_tu/providers/wallet_provider.dart';
import 'package:vi_dien_tu/providers/transaction_provider.dart';
import 'package:vi_dien_tu/providers/settings_provider.dart';
import 'package:vi_dien_tu/models/wallet.dart';
import 'package:vi_dien_tu/services/transfer_service.dart';
import 'package:vi_dien_tu/utils/translations.dart';

class WalletTransferScreen extends StatefulWidget {
  const WalletTransferScreen({super.key});

  @override
  State<WalletTransferScreen> createState() => _WalletTransferScreenState();
}

class _WalletTransferScreenState extends State<WalletTransferScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  Wallet? _fromWallet;
  Wallet? _toWallet;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8DC),
      appBar: AppBar(
        title: Consumer<SettingsProvider>(
          builder: (context, settings, child) {
            return Text(settings.isEnglish ? '🇻🇳 Transfer Between Wallets' : '🇻🇳 Chuyển tiền giữa ví');
          },
        ),
        backgroundColor: const Color(0xFFDA020E),
        elevation: 0,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFDA020E), Color(0xFFFF6B6B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Consumer<WalletProvider>(
        builder: (context, walletProvider, child) {
          if (walletProvider.wallets.length < 2) {
            return _buildInsufficientWalletsState();
          }

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer<SettingsProvider>(
                    builder: (context, settings, child) {
                      return Column(
                        children: [
                          _buildWalletSelector(
                            Translations.get('from_wallet', settings.isEnglish), 
                            _fromWallet, 
                            walletProvider, 
                            true
                          ),
                          const SizedBox(height: 20),
                          _buildWalletSelector(
                            Translations.get('to_wallet', settings.isEnglish), 
                            _toWallet, 
                            walletProvider, 
                            false
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildAmountInput(),
                  const SizedBox(height: 20),
                  _buildDescriptionInput(),
                  const SizedBox(height: 30),
                  _buildTransferButton(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInsufficientWalletsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Consumer<SettingsProvider>(
            builder: (context, settings, child) {
              return Column(
                children: [
                  Text(
                    settings.isEnglish ? 'Need at least 2 wallets' : 'Cần ít nhất 2 ví',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    settings.isEnglish 
                      ? 'Please create more wallets to use this feature'
                      : 'Vui lòng tạo thêm ví để sử dụng tính năng này',
                    style: TextStyle(color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWalletSelector(String title, Wallet? selectedWallet, 
      WalletProvider walletProvider, bool isFromWallet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => _showWalletPicker(walletProvider, isFromWallet),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: selectedWallet == null
                ? Row(
                    children: [
                      Icon(Icons.add, color: Colors.grey[600]),
                      const SizedBox(width: 12),
                      Consumer<SettingsProvider>(
                        builder: (context, settings, child) {
                          return Text(
                            settings.isEnglish ? 'Select Wallet' : 'Chọn ví',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          );
                        },
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color(int.parse(selectedWallet.color.replaceFirst('#', '0xFF'))),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _getWalletIcon(selectedWallet.type),
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedWallet.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              _formatCurrency(selectedWallet.balance),
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Consumer<SettingsProvider>(
          builder: (context, settings, child) {
            return Text(
              Translations.get('amount', settings.isEnglish),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: Provider.of<SettingsProvider>(context).isEnglish ? 'Enter amount' : 'Nhập số tiền',
            prefixIcon: const Icon(Icons.attach_money),
            suffixText: 'VND',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Vui lòng nhập số tiền';
            }
            final amount = double.tryParse(value);
            if (amount == null || amount <= 0) {
              return 'Số tiền không hợp lệ';
            }
            if (_fromWallet != null && amount > _fromWallet!.balance) {
              return 'Số dư không đủ';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDescriptionInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Consumer<SettingsProvider>(
          builder: (context, settings, child) {
            return Text(
              settings.isEnglish ? 'Description (optional)' : 'Nội dung (tùy chọn)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _descriptionController,
          decoration: InputDecoration(
            hintText: Provider.of<SettingsProvider>(context).isEnglish ? 'Enter transfer description' : 'Nhập nội dung chuyển tiền',
            prefixIcon: const Icon(Icons.message),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildTransferButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading || _fromWallet == null || _toWallet == null 
            ? null 
            : _performTransfer,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFDA020E),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Consumer<SettingsProvider>(
                builder: (context, settings, child) {
                  return Text(
                    Translations.get('transfer_money', settings.isEnglish),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              ),
      ),
    );
  }

  void _showWalletPicker(WalletProvider walletProvider, bool isFromWallet) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Consumer<SettingsProvider>(
                      builder: (context, settings, child) {
                        return Text(
                          isFromWallet 
                            ? (settings.isEnglish ? 'Select Source Wallet' : 'Chọn ví nguồn')
                            : (settings.isEnglish ? 'Select Destination Wallet' : 'Chọn ví đích'),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    ...walletProvider.wallets
                        .where((wallet) => isFromWallet 
                            ? wallet.id != _toWallet?.id 
                            : wallet.id != _fromWallet?.id)
                        .map((wallet) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Color(int.parse(wallet.color.replaceFirst('#', '0xFF'))),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _getWalletIcon(wallet.type),
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          title: Text(
                            wallet.name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            _formatCurrency(wallet.balance),
                            style: TextStyle(
                              color: wallet.balance >= 0 ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              if (isFromWallet) {
                                _fromWallet = wallet;
                              } else {
                                _toWallet = wallet;
                              }
                            });
                            Navigator.pop(context);
                          },
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _performTransfer() async {
    if (!_formKey.currentState!.validate()) return;
    if (_fromWallet == null || _toWallet == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final amount = double.parse(_amountController.text);
      final description = _descriptionController.text.isEmpty 
          ? 'Chuyển tiền giữa ví' 
          : _descriptionController.text;

      await TransferService.transferMoney(
        fromWalletId: _fromWallet!.id,
        toWalletId: _toWallet!.id,
        amount: amount,
        description: description,
        recipientName: _toWallet!.name,
      );

      // Refresh providers
      final walletProvider = context.read<WalletProvider>();
      final transactionProvider = context.read<TransactionProvider>();
      
      await walletProvider.fetchWallets();
      await transactionProvider.fetchTransactions();

      if (mounted) {
        Navigator.pop(context);
        final settings = Provider.of<SettingsProvider>(context, listen: false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(Translations.get('transfer_success', settings.isEnglish)),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final settings = Provider.of<SettingsProvider>(context, listen: false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(settings.isEnglish ? 'Error: $e' : 'Lỗi: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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

  String _formatCurrency(double amount) {
    return '${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ';
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}