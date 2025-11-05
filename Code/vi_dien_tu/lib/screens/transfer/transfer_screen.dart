import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vi_dien_tu/providers/wallet_provider.dart';
import 'package:vi_dien_tu/providers/transaction_provider.dart';
import 'package:vi_dien_tu/models/transaction.dart';
import 'package:vi_dien_tu/services/transfer_service.dart';
import 'package:vi_dien_tu/services/qr_service.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() =>
      _TransferScreenState();
}

class _TransferScreenState
    extends State<TransferScreen> {
  final _formKey = GlobalKey<FormState>();
  final _recipientController =
      TextEditingController();
  final _amountController =
      TextEditingController();
  final _descriptionController =
      TextEditingController();

  String _transferType = 'phone';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8DC),
      appBar: AppBar(
        title: const Text('🇻🇳 Chuyển Tiền Việt Nam'),
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
        builder:
            (context, walletProvider, child) {
          if (walletProvider.selectedWallet ==
              null) {
            return _buildNoWalletState();
          }

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildWalletSelector(
                      walletProvider),
                  const SizedBox(height: 20),
                  _buildTransferTypeSelector(),
                  const SizedBox(height: 20),
                  _buildTransferForm(),
                  const SizedBox(height: 20),
                  _buildAmountSuggestions(),
                  const SizedBox(height: 30),
                  _buildTransferButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNoWalletState() {
    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Chưa có ví nào',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Vui lòng thêm ví để sử dụng tính năng này',
            style: TextStyle(
                color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletSelector(
      WalletProvider walletProvider) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(int.parse(walletProvider
                .selectedWallet!.color
                .replaceFirst('#', '0xFF'))),
            Color(int.parse(walletProvider
                    .selectedWallet!.color
                    .replaceFirst('#', '0xFF')))
                .withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(int.parse(walletProvider
                    .selectedWallet!.color
                    .replaceFirst('#', '0xFF')))
                .withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Từ ví',
                style: TextStyle(
                  color: Color.fromARGB(
                      255, 241, 241, 241),
                  fontSize: 14,
                ),
              ),
              GestureDetector(
                onTap: () => _showWalletSelector(
                    context, walletProvider),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white
                        .withOpacity(0.2),
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Đổi ví',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                _getWalletIcon(walletProvider
                    .selectedWallet!.type),
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      walletProvider
                          .selectedWallet!.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Số dư: ${_formatCurrency(walletProvider.selectedWallet!.balance)}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
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

  Widget _buildTransferTypeSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: 16),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            'Chuyển đến',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTransferTypeCard(
                    'phone',
                    'Số điện thoại',
                    Icons.phone_android),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTransferTypeCard(
                    'account',
                    'Số tài khoản',
                    Icons.account_balance),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTransferTypeCard(
                    'qr',
                    'Quét QR',
                    Icons.qr_code_scanner),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransferTypeCard(
      String type, String label, IconData icon) {
    final isSelected = _transferType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          _transferType = type;
        });
        if (type == 'qr') {
          _scanQR();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xffef3c7b)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xffef3c7b)
                : Colors.grey[300]!,
            width: 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: const Color(0xffef3c7b)
                    .withOpacity(0.3),
                spreadRadius: 0,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Colors.white
                  : Colors.grey[600],
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : Colors.grey[700],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransferForm() {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: 16),
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
        children: [
          if (_transferType != 'qr') ...[
            TextFormField(
              controller: _recipientController,
              decoration: InputDecoration(
                labelText:
                    _transferType == 'phone'
                        ? 'Số điện thoại'
                        : 'Số tài khoản',
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                prefixIcon: Icon(
                  _transferType == 'phone'
                      ? Icons.phone
                      : Icons.account_balance,
                ),
                suffixIcon: IconButton(
                  icon:
                      const Icon(Icons.contacts),
                  onPressed: () {},
                ),
              ),
              keyboardType:
                  _transferType == 'phone'
                      ? TextInputType.phone
                      : TextInputType.number,
              validator: (value) {
                if (value == null ||
                    value.isEmpty) {
                  return 'Vui lòng nhập thông tin người nhận';
                }
                if (_transferType == 'phone' &&
                    !RegExp(r'^[0-9]{10,11}$')
                        .hasMatch(value)) {
                  return 'Số điện thoại không hợp lệ';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
          ],
          TextFormField(
            controller: _amountController,
            decoration: InputDecoration(
              labelText: 'Số tiền',
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(12),
              ),
              prefixIcon:
                  const Icon(Icons.attach_money),
              suffixText: 'VND',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null ||
                  value.isEmpty) {
                return 'Vui lòng nhập số tiền';
              }
              final amount =
                  double.tryParse(value);
              if (amount == null || amount <= 0) {
                return 'Số tiền không hợp lệ';
              }
              
              // Check wallet balance
              final walletProvider = context.read<WalletProvider>();
              if (walletProvider.selectedWallet != null && 
                  amount > walletProvider.selectedWallet!.balance) {
                return 'Số dư không đủ';
              }
              
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'Nội dung chuyển tiền',
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(12),
              ),
              prefixIcon:
                  const Icon(Icons.message),
            ),
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildAmountSuggestions() {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: 16),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            'Số tiền gợi ý',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              100000,
              200000,
              500000,
              1000000,
              2000000,
              5000000
            ]
                .map((amount) =>
                    _buildAmountChip(amount))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountChip(int amount) {
    return GestureDetector(
      onTap: () {
        _amountController.text =
            amount.toString();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: Colors.grey[300]!),
        ),
        child: Text(
          _formatCurrency(amount.toDouble()),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
      ),
    );
  }

  Widget _buildTransferButton() {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: 16),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: (_isLoading || 
                   context.watch<WalletProvider>().selectedWallet == null) 
                   ? null : _transfer,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              const Color(0xffef3c7b),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
              vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor:
                      AlwaysStoppedAnimation<
                          Color>(Colors.white),
                ),
              )
            : const Text(
                'Chuyển tiền',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  void _showWalletSelector(BuildContext context,
      WalletProvider walletProvider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin:
                    const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius:
                      BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'Chọn ví',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ...walletProvider.wallets
                        .map((wallet) {
                      return Container(
                        margin:
                            const EdgeInsets.only(
                                bottom: 12),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius
                                  .circular(12),
                          border: Border.all(
                              color: Colors
                                  .grey[200]!),
                        ),
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets
                                  .all(16),
                          leading: Container(
                            width: 48,
                            height: 48,
                            decoration:
                                BoxDecoration(
                              gradient:
                                  LinearGradient(
                                colors: [
                                  Color(int.parse(wallet
                                      .color
                                      .replaceFirst(
                                          '#',
                                          '0xFF'))),
                                  Color(int.parse(wallet
                                          .color
                                          .replaceFirst(
                                              '#',
                                              '0xFF')))
                                      .withOpacity(
                                          0.8),
                                ],
                              ),
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                          12),
                            ),
                            child: Icon(
                              _getWalletIcon(
                                  wallet.type),
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          title: Text(
                            wallet.name,
                            style: const TextStyle(
                                fontWeight:
                                    FontWeight
                                        .w600),
                          ),
                          subtitle: Text(
                            _formatCurrency(
                                wallet.balance),
                            style: TextStyle(
                              color: wallet
                                          .balance >=
                                      0
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight:
                                  FontWeight.w500,
                            ),
                          ),
                          trailing: walletProvider
                                      .selectedWallet
                                      ?.id ==
                                  wallet.id
                              ? const Icon(
                                  Icons
                                      .check_circle,
                                  color:
                                      Colors.teal)
                              : null,
                          onTap: () {
                            walletProvider
                                .selectWallet(
                                    wallet);
                            Navigator.pop(
                                context);
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

  Future<void> _scanQR() async {
    await Future.delayed(
        const Duration(seconds: 1));

    final qrData =
        QRService.decodeQR('mock_qr_code');
    if (qrData != null &&
        qrData['type'] == 'payment') {
      _recipientController.text =
          qrData['recipientInfo'] ?? '';
      _amountController.text =
          qrData['amount']?.toString() ?? '';
      _descriptionController.text =
          qrData['description'] ?? '';
    }
  }

  Future<void> _transfer() async {
    print('Transfer button pressed');
    
    if (!_formKey.currentState!.validate()) {
      print('Form validation failed');
      return;
    }

    print('Starting transfer process');
    setState(() {
      _isLoading = true;
    });

    try {
      final walletProvider =
          context.read<WalletProvider>();
      final transactionProvider =
          context.read<TransactionProvider>();

      final transaction = Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: 'payment',
        amount:
            double.parse(_amountController.text),
        fromWalletId:
            walletProvider.selectedWallet!.id,
        recipientInfo: _recipientController.text,
        recipientName: _recipientController.text.isNotEmpty ? _recipientController.text : 'Người nhận',
        description:
            _descriptionController.text.isEmpty
                ? 'Chuyển tiền'
                : _descriptionController.text,
        createdAt: DateTime.now(),
        status: 'completed',
        transactionCode: 'PAY${DateTime.now().millisecondsSinceEpoch}',
        fee: 0.0,
      );

      print('Creating transaction: ${transaction.toJson()}');
      await transactionProvider
          .createTransaction(transaction);

      final newBalance =
          walletProvider.selectedWallet!.balance -
              transaction.amount;
      print('Updating wallet balance from ${walletProvider.selectedWallet!.balance} to $newBalance');
      await walletProvider.updateWalletBalance(
        walletProvider.selectedWallet!.id,
        newBalance,
      );
      print('Transfer completed successfully');

      if (mounted) {
        // Clear form
        _recipientController.clear();
        _amountController.clear();
        _descriptionController.clear();
        
        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
              content:
                  Text('Chuyển tiền thành công'),
              backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      print('Transfer error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text('Lỗi: $e'),
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
    _recipientController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
