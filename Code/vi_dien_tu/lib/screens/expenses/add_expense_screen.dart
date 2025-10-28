import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vi_dien_tu/providers/expense_provider.dart';
import 'package:vi_dien_tu/providers/settings_provider.dart';
import 'package:vi_dien_tu/models/expense.dart';
import 'package:vi_dien_tu/utils/translations.dart';
import 'package:intl/intl.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() =>
      _AddExpenseScreenState();
}

class _AddExpenseScreenState
    extends State<AddExpenseScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController =
      TextEditingController();
  final _amountController =
      TextEditingController();
  final _descriptionController =
      TextEditingController();

  String _selectedType = 'Chi tiêu';
  String _selectedCategory = 'Ăn uống';
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  late TabController _tabController;

  final List<String> _expenseCategories = [
    'Ăn uống',
    'Di chuyển',
    'Nhà cử a',
    'Sức khỏe',
    'Giải trí',
    'Quần áo',
    'Giáo dục',
    'Du lịch',
    'Khác'
  ];

  final List<String> _incomeCategories = [
    'Lương',
    'Thưởng',
    'Bán hàng',
    'Đầu tư',
    'Khác'
  ];

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedType = _tabController.index == 0
            ? 'Chi tiêu'
            : 'Thu nhập';
        _selectedCategory =
            _tabController.index == 0
                ? _expenseCategories.first
                : _incomeCategories.first;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff9f9e8),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTypeSelector(),
                  const SizedBox(height: 20),
                  _buildAmountInput(),
                  const SizedBox(height: 16),
                  _buildBasicInfo(),
                  const SizedBox(height: 16),
                  _buildCategorySelector(),
                  const SizedBox(height: 16),
                  _buildDateSelector(),
                  const SizedBox(height: 30),
                  _buildSaveButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: _selectedType == 'Chi tiêu'
          ? Colors.red
          : Colors.green,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
            'Thêm ${_selectedType.toLowerCase()}'),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _selectedType == 'Chi tiêu'
                  ? [Colors.red, Colors.redAccent]
                  : [
                      Colors.green,
                      Colors.greenAccent
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
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
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: _selectedType == 'Chi tiêu'
              ? Colors.red
              : Colors.green,
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[600],
        labelStyle: const TextStyle(
            fontWeight: FontWeight.w600),
        tabs: [
          Consumer<SettingsProvider>(
            builder: (context, settings, child) {
              return Tab(
                icon: const Icon(
                    Icons.remove_circle_outline),
                text: Translations.get('expense',
                    settings.isEnglish),
              );
            },
          ),
          Consumer<SettingsProvider>(
            builder: (context, settings, child) {
              return Tab(
                icon: const Icon(
                    Icons.add_circle_outline),
                text: Translations.get(
                    'income', settings.isEnglish),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAmountInput() {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Consumer<SettingsProvider>(
            builder: (context, settings, child) {
              return Text(
                Translations.get(
                    'amount', settings.isEnglish),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: _selectedType == 'Chi tiêu'
                  ? Colors.red
                  : Colors.green,
            ),
            decoration: InputDecoration(
              hintText: '0',
              hintStyle: TextStyle(
                fontSize: 32,
                color: Colors.grey[300],
              ),
              border: InputBorder.none,
              suffixText: 'đ',
              suffixStyle: TextStyle(
                fontSize: 20,
                color: Colors.grey[600],
              ),
            ),
            validator: (value) {
              final settings =
                  Provider.of<SettingsProvider>(
                      context,
                      listen: false);
              if (value == null ||
                  value.isEmpty) {
                return Translations.get(
                    'enter_amount',
                    settings.isEnglish);
              }
              if (double.tryParse(value) ==
                      null ||
                  double.parse(value) <= 0) {
                return Translations.get(
                    'invalid_amount',
                    settings.isEnglish);
              }
              return null;
            },
          ),
        ],
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
                settings.isEnglish
                    ? 'Details'
                    : 'Thông tin chi tiết',
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
            controller: _titleController,
            decoration: InputDecoration(
              labelText:
                  Provider.of<SettingsProvider>(
                              context)
                          .isEnglish
                      ? 'Title'
                      : 'Tiêu đề',
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.title),
            ),
            validator: (value) {
              final settings =
                  Provider.of<SettingsProvider>(
                      context,
                      listen: false);
              if (value == null ||
                  value.isEmpty) {
                return Translations.get(
                    'enter_title',
                    settings.isEnglish);
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText:
                  Provider.of<SettingsProvider>(
                              context)
                          .isEnglish
                      ? 'Description (optional)'
                      : 'Mô tả (tùy chọn)',
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(12),
              ),
              prefixIcon:
                  const Icon(Icons.description),
            ),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    final categories = _selectedType == 'Chi tiêu'
        ? _expenseCategories
        : _incomeCategories;

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
                Translations.get('category',
                    settings.isEnglish),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: categories.map((category) {
              final isSelected =
                  _selectedCategory == category;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (_selectedType ==
                                    'Chi tiêu'
                                ? Colors.red
                                : Colors.green)
                            .withOpacity(0.1)
                        : Colors.grey[100],
                    borderRadius:
                        BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? (_selectedType ==
                                  'Chi tiêu'
                              ? Colors.red
                              : Colors.green)
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize:
                        MainAxisSize.min,
                    children: [
                      Icon(
                        _getCategoryIcon(
                            category),
                        size: 18,
                        color: isSelected
                            ? (_selectedType ==
                                    'Chi tiêu'
                                ? Colors.red
                                : Colors.green)
                            : Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Consumer<SettingsProvider>(
                        builder: (context,
                            settings, child) {
                          return Text(
                            Translations.get(
                                category,
                                settings
                                    .isEnglish),
                            style: TextStyle(
                              color: isSelected
                                  ? (_selectedType ==
                                          'Chi tiêu'
                                      ? Colors.red
                                      : Colors
                                          .green)
                                  : Colors
                                      .grey[700],
                              fontWeight:
                                  isSelected
                                      ? FontWeight
                                          .w600
                                      : FontWeight
                                          .normal,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
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
      child: Row(
        children: [
          Icon(
            Icons.calendar_today,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Ngày giao dịch',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('dd/MM/yyyy')
                      .format(_selectedDate),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: _selectDate,
            child: const Text('Thay đổi'),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: 16),
      width: double.infinity,
      child: ElevatedButton(
        onPressed:
            _isLoading ? null : _saveExpense,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              _selectedType == 'Chi tiêu'
                  ? Colors.red
                  : Colors.green,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
              vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(16),
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
            : Text(
                'Lưu ${_selectedType.toLowerCase()}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null &&
        picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveExpense() async {
    if (!_formKey.currentState!.validate())
      return;

    setState(() {
      _isLoading = true;
    });

    try {
      final expense = Expense(
        id: '',
        title: _titleController.text,
        amount: _selectedType == 'Chi tiêu'
            ? -double.parse(
                _amountController.text)
            : double.parse(
                _amountController.text),
        date: _selectedDate,
        category: _selectedCategory,
        description: _descriptionController.text,
        type: _selectedType,
      );

      await context
          .read<ExpenseProvider>()
          .addExpense(expense);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
                'Thêm ${_selectedType.toLowerCase()} thành công'),
            backgroundColor:
                _selectedType == 'Chi tiêu'
                    ? Colors.red
                    : Colors.green,
          ),
        );
      }
    } catch (e) {
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

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Ăn uống':
        return Icons.restaurant;
      case 'Di chuyển':
        return Icons.directions_car;
      case 'Nhà cử a':
        return Icons.home;
      case 'Sức khỏe':
        return Icons.local_hospital;
      case 'Giải trí':
        return Icons.movie;
      case 'Quần áo':
        return Icons.shopping_bag;
      case 'Giáo dục':
        return Icons.school;
      case 'Du lịch':
        return Icons.flight;
      case 'Lương':
        return Icons.work;
      case 'Thưởng':
        return Icons.card_giftcard;
      case 'Bán hàng':
        return Icons.store;
      case 'Đầu tư':
        return Icons.trending_up;
      default:
        return Icons.category;
    }
  }
}
