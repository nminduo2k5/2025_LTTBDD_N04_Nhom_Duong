import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vi_dien_tu/models/expense.dart';
import 'package:vi_dien_tu/providers/expense_provider.dart';
import 'package:vi_dien_tu/providers/settings_provider.dart';
import 'package:vi_dien_tu/utils/translations.dart';
import 'package:intl/intl.dart';

class EditExpenseForm extends StatefulWidget {
  final Expense expense;

  const EditExpenseForm(
      {super.key, required this.expense});

  @override
  State<EditExpenseForm> createState() =>
      _EditExpenseFormState();
}

class _EditExpenseFormState
    extends State<EditExpenseForm>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController =
      TextEditingController();
  final _amountController =
      TextEditingController();
  final _descriptionController =
      TextEditingController();

  String? _selectedCategory;
  String? _selectedType;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<String> _categoryKeys = [
    'food_drink',
    'housing',
    'vehicle',
    'beauty',
    'clothing',
    'travel',
    'salary',
    'education',
    'transport',
    'entertainment',
    'health',
    'other'
  ];

  @override
  void initState() {
    super.initState();
    _initializeForm();
    _setupAnimations();
  }

  void _initializeForm() {
    _titleController.text = widget.expense.title;
    _amountController.text =
        widget.expense.amount.abs().toString();
    _descriptionController.text =
        widget.expense.description;
    _selectedCategory = widget.expense.category;
    _selectedType = widget.expense.type;
    _selectedDate = widget.expense.date;
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0)
            .animate(
      CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff9f9e8),
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildHeaderCard(),
                  const SizedBox(height: 16),
                  _buildFormCard(),
                  const SizedBox(height: 24),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return Text(
            Translations.get('edit_transaction',
                settings.isEnglish),
            style: const TextStyle(
                fontWeight: FontWeight.bold),
          );
        },
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildHeaderCard() {
    final isIncome =
        widget.expense.type == 'Thu nhập';
    final color =
        isIncome ? Colors.green : Colors.red;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.8), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            isIncome
                ? Icons.trending_up
                : Icons.trending_down,
            color: Colors.white,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            '${isIncome ? '+' : '-'}${_formatCurrency(widget.expense.amount.abs())}',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.expense.category,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Consumer<SettingsProvider>(
              builder:
                  (context, settings, child) {
                return Column(
                  children: [
                    _buildTextField(
                      controller:
                          _titleController,
                      icon: Icons.edit_outlined,
                      label: Translations.get(
                          'title',
                          settings.isEnglish),
                      validator: (value) =>
                          value?.isEmpty == true
                              ? Translations.get(
                                  'enter_title',
                                  settings
                                      .isEnglish)
                              : null,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller:
                          _amountController,
                      icon: Icons.attach_money,
                      label: Translations.get(
                          'amount',
                          settings.isEnglish),
                      keyboardType:
                          TextInputType.number,
                      validator: (value) =>
                          value?.isEmpty == true
                              ? Translations.get(
                                  'enter_amount',
                                  settings
                                      .isEnglish)
                              : null,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller:
                          _descriptionController,
                      icon: Icons
                          .description_outlined,
                      label: Translations.get(
                          'description',
                          settings.isEnglish),
                      maxLines: 3,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            _buildTypeSelector(),
            const SizedBox(height: 24),
            _buildCategorySelector(),
            const SizedBox(height: 24),
            _buildDateSelector(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon,
            color: Colors.blue.shade600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: Colors.blue.shade600,
              width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        final types = [
          Translations.get(
              'income', settings.isEnglish),
          Translations.get(
              'expense', settings.isEnglish)
        ];

        return Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              Translations.get('transaction_type',
                  settings.isEnglish),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: types.map((type) {
                final isSelected =
                    _selectedType == type;
                final isIncome = type ==
                    Translations.get('income',
                        settings.isEnglish);
                final color = isIncome
                    ? Colors.green
                    : Colors.red;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets
                        .symmetric(horizontal: 4),
                    child: GestureDetector(
                      onTap: () => setState(() =>
                          _selectedType = type),
                      child: Container(
                        padding: const EdgeInsets
                            .symmetric(
                            vertical: 16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? color
                              : Colors
                                  .grey.shade100,
                          borderRadius:
                              BorderRadius
                                  .circular(12),
                          border: Border.all(
                            color: isSelected
                                ? color
                                : Colors.grey
                                    .shade300,
                            width: isSelected
                                ? 2
                                : 1,
                          ),
                        ),
                        child: Text(
                          type,
                          textAlign:
                              TextAlign.center,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Colors.grey
                                    .shade700,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategorySelector() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Consumer<SettingsProvider>(
          builder: (context, settings, child) {
            return Text(
              Translations.get(
                  'category', settings.isEnglish),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _showCategoryPicker,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius:
                  BorderRadius.circular(12),
              border: Border.all(
                  color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(
                  _getCategoryIcon(
                      _selectedCategory),
                  color: Colors.blue.shade600,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child:
                      Consumer<SettingsProvider>(
                    builder: (context, settings,
                        child) {
                      return Text(
                        _selectedCategory ??
                            Translations.get(
                                'select_category',
                                settings
                                    .isEnglish),
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              _selectedCategory !=
                                      null
                                  ? Colors.black87
                                  : Colors.grey
                                      .shade600,
                        ),
                      );
                    },
                  ),
                ),
                Icon(Icons.arrow_drop_down,
                    color: Colors.grey.shade600),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelector() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Consumer<SettingsProvider>(
          builder: (context, settings, child) {
            return Text(
              Translations.get('transaction_date',
                  settings.isEnglish),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _showDatePicker,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius:
                  BorderRadius.circular(12),
              border: Border.all(
                  color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today,
                    color: Colors.blue.shade600),
                const SizedBox(width: 12),
                Text(
                  DateFormat('dd/MM/yyyy')
                      .format(_selectedDate),
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87),
                ),
                const Spacer(),
                Icon(Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey.shade600),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () =>
                Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                  vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(12),
              ),
              side: BorderSide(
                  color: Colors.grey.shade400),
            ),
            child: Consumer<SettingsProvider>(
              builder:
                  (context, settings, child) {
                return Text(
                  Translations.get('cancel',
                      settings.isEnglish),
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.w600),
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade600,
                  Colors.purple.shade600
                ],
              ),
              borderRadius:
                  BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue
                      .withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : _updateExpense,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.transparent,
                shadowColor: Colors.transparent,
                padding:
                    const EdgeInsets.symmetric(
                        vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white)
                  : Consumer<SettingsProvider>(
                      builder: (context, settings,
                          child) {
                        return Text(
                          Translations.get(
                              'update_transaction',
                              settings.isEnglish),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight:
                                FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatCurrency(double amount) {
    return NumberFormat('#,###', 'vi_VN')
            .format(amount) +
        ' đ';
  }

  IconData _getCategoryIcon(String? category) {
    switch (category) {
      case 'Ăn uống':
        return Icons.restaurant;
      case 'Nhà cửa':
        return Icons.home;
      case 'Xe cộ':
        return Icons.directions_car;
      case 'Làm đẹp':
        return Icons.face;
      case 'Quần áo':
        return Icons.shopping_bag;
      case 'Du lịch':
        return Icons.flight;
      case 'Lương':
        return Icons.attach_money;
      case 'Học phí':
        return Icons.school;
      case 'Di chuyển':
        return Icons.directions_transit;
      case 'Giải trí':
        return Icons.sports_esports;
      case 'Sức khỏe':
        return Icons.local_hospital;
      case 'Khác':
        return Icons.help_outline;
      default:
        return Icons.category;
    }
  }

  void _showCategoryPicker() {
    final categories = [
      'Ăn uống',
      'Nhà cửa',
      'Xe cộ',
      'Làm đẹp',
      'Quần áo',
      'Du lịch',
      'Lương',
      'Học phí',
      'Di chuyển',
      'Giải trí',
      'Sức khỏe',
      'Khác'
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius:
                    BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Consumer<SettingsProvider>(
              builder:
                  (context, settings, child) {
                return Text(
                  Translations.get(
                      'select_category',
                      settings.isEnglish),
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold),
                );
              },
            ),
            const SizedBox(height: 20),
            Flexible(
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category =
                      categories[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() =>
                          _selectedCategory =
                              category);
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            Colors.grey.shade50,
                        borderRadius:
                            BorderRadius.circular(
                                12),
                        border: Border.all(
                            color: Colors
                                .grey.shade200),
                      ),
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .center,
                        children: [
                          Icon(
                            _getCategoryIcon(
                                category),
                            size: 32,
                            color: Colors
                                .blue.shade600,
                          ),
                          const SizedBox(
                              height: 8),
                          Text(
                            category,
                            style:
                                const TextStyle(
                              fontSize: 12,
                              fontWeight:
                                  FontWeight.w500,
                            ),
                            textAlign:
                                TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null &&
        picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  void _updateExpense() async {
    if (_formKey.currentState?.validate() ??
        false) {
      final settings =
          Provider.of<SettingsProvider>(context,
              listen: false);

      if (_selectedCategory == null ||
          _selectedType == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
                _selectedCategory == null
                    ? Translations.get(
                        'please_select_category',
                        settings.isEnglish)
                    : Translations.get(
                        'please_select_type',
                        settings.isEnglish)),
          ),
        );
        return;
      }

      setState(() => _isLoading = true);

      try {
        final updatedExpense = Expense(
          id: widget.expense.id,
          title: _titleController.text,
          amount: (_selectedType == 'Chi tiêu')
              ? -double.parse(
                  _amountController.text)
              : double.parse(
                  _amountController.text),
          date: _selectedDate,
          category: _selectedCategory!,
          description:
              _descriptionController.text.isEmpty
                  ? Translations.get(
                      'no_description',
                      settings.isEnglish)
                  : _descriptionController.text,
          type: _selectedType!,
        );

        await Provider.of<ExpenseProvider>(
                context,
                listen: false)
            .updateExpense(updatedExpense);

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context)
              .showSnackBar(
            SnackBar(
              content: Text(Translations.get(
                  'update_success',
                  settings.isEnglish)),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(
            SnackBar(
              content: Text(
                  '${Translations.get('error', settings.isEnglish)}: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }
}
