import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vi_dien_tu/providers/wallet_provider.dart';
import 'package:vi_dien_tu/providers/settings_provider.dart';
import 'package:vi_dien_tu/models/wallet.dart';
import 'package:vi_dien_tu/utils/translations.dart';

class AddWalletScreen extends StatefulWidget {
  const AddWalletScreen({super.key});

  @override
  State<AddWalletScreen> createState() =>
      _AddWalletScreenState();
}

class _AddWalletScreenState
    extends State<AddWalletScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _balanceController =
      TextEditingController();
  final _bankNameController =
      TextEditingController();
  final _accountNumberController =
      TextEditingController();
  final _cardNumberController =
      TextEditingController();

  String _selectedType = 'cash';
  String _selectedColor = '#2196F3';
  bool _isDefault = false;
  bool _isLoading = false;

  final List<String> _walletTypes = [
    'cash',
    'bank',
    'credit',
    'savings',
  ];

  final List<String> _colors = [
    '#2196F3',
    '#4CAF50',
    '#FF9800',
    '#F44336',
    '#9C27B0',
    '#607D8B',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8DC),
      appBar: AppBar(
        title: Consumer<SettingsProvider>(
          builder: (context, settings, child) {
            return Text(Translations.get('add_wallet', settings.isEnglish));
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
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildWalletPreview(),
              const SizedBox(height: 20),
              _buildBasicInfo(),
              const SizedBox(height: 16),
              if (_selectedType == 'bank' ||
                  _selectedType == 'savings' ||
                  _selectedType == 'credit')
                _buildBankInfo(),
              const SizedBox(height: 16),
              _buildCustomization(),
              const SizedBox(height: 30),
              _buildAddButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWalletPreview() {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(int.parse(_selectedColor
                .replaceFirst('#', '0xFF'))),
            Color(int.parse(_selectedColor
                    .replaceFirst('#', '0xFF')))
                .withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(int.parse(_selectedColor
                    .replaceFirst('#', '0xFF')))
                .withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  _getWalletIconData(
                      _selectedType),
                  color: Colors.white,
                  size: 32,
                ),
                if (_isDefault)
                  Container(
                    padding: const EdgeInsets
                        .symmetric(
                        horizontal: 8,
                        vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withOpacity(0.2),
                      borderRadius:
                          BorderRadius.circular(
                              12),
                    ),
                    child: const Text(
                      'Mặc định',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight:
                            FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
            const Spacer(),
            Consumer<SettingsProvider>(
              builder: (context, settings, child) {
                return Text(
                  _nameController.text.isEmpty
                      ? Translations.get('wallet_name', settings.isEnglish)
                      : _nameController.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            Text(
              _balanceController.text.isEmpty
                  ? '0đ'
                  : _formatCurrency(
                      double.tryParse(
                              _balanceController
                                  .text) ??
                          0),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _getWalletTypeText(_selectedType),
              style: TextStyle(
                color:
                    Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfo() {
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
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Consumer<SettingsProvider>(
            builder: (context, settings, child) {
              return Text(
                settings.isEnglish ? 'Basic Information' : 'Thông tin cơ bản',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: Provider.of<SettingsProvider>(context).isEnglish ? 'Wallet Name' : 'Tên ví',
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(
                  Icons.account_balance_wallet),
            ),
            onChanged: (value) => setState(() {}),
            validator: (value) {
              if (value == null ||
                  value.isEmpty) {
                final settings = Provider.of<SettingsProvider>(context, listen: false);
                return settings.isEnglish ? 'Please enter wallet name' : 'Vui lòng nhập tên ví';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedType,
            decoration: InputDecoration(
              labelText: Provider.of<SettingsProvider>(context).isEnglish ? 'Wallet Type' : 'Loại ví',
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(12),
              ),
              prefixIcon: Icon(_getWalletIconData(
                  _selectedType)),
            ),
            items: _walletTypes.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Row(
                  children: [
                    Icon(_getWalletIconData(type),
                        size: 20),
                    const SizedBox(width: 8),
                    Text(
                        _getWalletTypeText(type)),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedType = value!;
              });
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _balanceController,
            decoration: InputDecoration(
              labelText: Provider.of<SettingsProvider>(context).isEnglish ? 'Initial Balance' : 'Số dư ban đầu',
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(12),
              ),
              prefixIcon:
                  const Icon(Icons.attach_money),
              suffixText: 'VND',
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) => setState(() {}),
            validator: (value) {
              if (value == null ||
                  value.isEmpty) {
                return 'Vui lòng nhập số dư';
              }
              if (double.tryParse(value) ==
                  null) {
                return 'Số dư không hợp lệ';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBankInfo() {
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
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            'Thông tin ngân hàng',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          if (_selectedType == 'bank' ||
              _selectedType == 'savings') ...[
            TextFormField(
              controller: _bankNameController,
              decoration: InputDecoration(
                labelText: 'Tên ngân hàng',
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(
                    Icons.account_balance),
              ),
              validator: (value) {
                if (value == null ||
                    value.isEmpty) {
                  return 'Vui lòng nhập tên ngân hàng';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller:
                  _accountNumberController,
              decoration: InputDecoration(
                labelText: 'Số tài khoản',
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                prefixIcon:
                    const Icon(Icons.credit_card),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null ||
                    value.isEmpty) {
                  return 'Vui lòng nhập số tài khoản';
                }
                return null;
              },
            ),
          ] else if (_selectedType ==
              'credit') ...[
            TextFormField(
              controller: _bankNameController,
              decoration: InputDecoration(
                labelText: 'Ngân hàng phát hành',
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(
                    Icons.account_balance),
              ),
              validator: (value) {
                if (value == null ||
                    value.isEmpty) {
                  return 'Vui lòng nhập ngân hàng phát hành';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _cardNumberController,
              decoration: InputDecoration(
                labelText: 'Số thẻ (4 số cuối)',
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                prefixIcon:
                    const Icon(Icons.credit_card),
              ),
              maxLength: 4,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null ||
                    value.isEmpty) {
                  return 'Vui lòng nhập 4 số cuối của thẻ';
                }
                if (value.length != 4) {
                  return 'Vui lòng nhập đúng 4 số';
                }
                return null;
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCustomization() {
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
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            'Tùy chỉnh',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Chọn màu ví',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _colors.map((color) {
              final isSelected =
                  _selectedColor == color;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = color;
                  });
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Color(int.parse(
                        color.replaceFirst(
                            '#', '0xFF'))),
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(
                            color:
                                Colors.grey[800]!,
                            width: 3)
                        : Border.all(
                            color:
                                Colors.grey[300]!,
                            width: 1),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Color(int.parse(
                                      color.replaceFirst(
                                          '#',
                                          '0xFF')))
                                  .withOpacity(
                                      0.3),
                              spreadRadius: 0,
                              blurRadius: 8,
                              offset:
                                  const Offset(
                                      0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: isSelected
                      ? const Icon(Icons.check,
                          color: Colors.white,
                          size: 24)
                      : null,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius:
                  BorderRadius.circular(12),
            ),
            child: CheckboxListTile(
              title: const Text(
                  'Đặt làm ví mặc định'),
              subtitle: const Text(
                  'Ví này sẽ được sử dụng làm mặc định'),
              value: _isDefault,
              onChanged: (value) {
                setState(() {
                  _isDefault = value ?? false;
                });
              },
              contentPadding:
                  const EdgeInsets.symmetric(
                      horizontal: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: 16),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _addWallet,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFDA020E),
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
            : Consumer<SettingsProvider>(
                builder: (context, settings, child) {
                  return Text(
                    Translations.get('add_wallet', settings.isEnglish),
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

  Future<void> _addWallet() async {
    if (!_formKey.currentState!.validate())
      return;

    setState(() {
      _isLoading = true;
    });

    try {
      final wallet = Wallet(
        id: '',
        name: _nameController.text,
        type: _selectedType,
        balance:
            double.parse(_balanceController.text),
        bankName:
            _bankNameController.text.isNotEmpty
                ? _bankNameController.text
                : null,
        accountNumber: _accountNumberController
                .text.isNotEmpty
            ? _accountNumberController.text
            : null,
        cardNumber: _cardNumberController
                .text.isNotEmpty
            ? '**** **** **** ${_cardNumberController.text}'
            : null,
        isDefault: _isDefault,
        color: _selectedColor,
        icon: _getWalletIcon(_selectedType),
      );

      await context
          .read<WalletProvider>()
          .addWallet(wallet);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
              content:
                  Text('Thêm ví thành công')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
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

  IconData _getWalletIconData(String type) {
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

  String _getWalletIcon(String type) {
    switch (type) {
      case 'cash':
        return 'wallet';
      case 'bank':
        return 'bank';
      case 'credit':
        return 'credit_card';
      case 'savings':
        return 'savings';
      default:
        return 'wallet';
    }
  }

  String _formatCurrency(double amount) {
    return '${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    _bankNameController.dispose();
    _accountNumberController.dispose();
    _cardNumberController.dispose();
    super.dispose();
  }
}
