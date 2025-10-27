import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vi_dien_tu/models/expense.dart';
import 'package:vi_dien_tu/providers/expense_provider.dart';
import 'package:vi_dien_tu/providers/settings_provider.dart';
import 'package:vi_dien_tu/utils/translations.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class AddExpenseForm extends StatefulWidget {
  final Expense? expense;

  const AddExpenseForm({super.key, this.expense});

  @override
  _AddExpenseFormState createState() =>
      _AddExpenseFormState();
}

class _AddExpenseFormState
    extends State<AddExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController =
      TextEditingController();
  final _amountController =
      TextEditingController();
  final _descriptionController =
      TextEditingController();
  final Uuid uuid = const Uuid();
  String? _selectedCategory;
  String? _selectedType;
  DateTime _selectedDate = DateTime.now();
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

  List<String> _getCategories(bool isEnglish) {
    return _categoryKeys
        .map((key) =>
            Translations.get(key, isEnglish))
        .toList();
  }

  List<String> get _types => [
        Translations.get(
            'income',
            Provider.of<SettingsProvider>(context,
                    listen: false)
                .isEnglish),
        Translations.get(
            'expense',
            Provider.of<SettingsProvider>(context,
                    listen: false)
                .isEnglish)
      ];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      _titleController.text =
          widget.expense!.title;
      _amountController.text =
          widget.expense!.amount.abs().toString();
      _descriptionController.text =
          widget.expense!.description;
      _selectedCategory =
          widget.expense!.category;
      _selectedType = widget.expense!.type;
      _selectedDate = widget.expense!.date;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider =
        Provider.of<SettingsProvider>(context);
    final isEnglish = settingsProvider.isEnglish;

    return GestureDetector(
      onTap: () =>
          FocusScope.of(context).unfocus(),
      child: Card(
        margin: const EdgeInsets.all(20),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .stretch,
                    mainAxisSize:
                        MainAxisSize.min,
                    children: [
                      _buildInputField(
                        controller:
                            _titleController,
                        icon: Icons.edit_outlined,
                        label: Translations.get(
                            'title', isEnglish),
                        placeholder:
                            Translations.get(
                                'enter_title',
                                isEnglish),
                      ),
                      const SizedBox(height: 20),
                      _buildInputField(
                        controller:
                            _amountController,
                        icon: Icons.attach_money,
                        label: Translations.get(
                            'amount', isEnglish),
                        placeholder:
                            Translations.get(
                                'enter_amount',
                                isEnglish),
                        keyboardType:
                            TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      _buildInputField(
                        controller:
                            _descriptionController,
                        icon: Icons
                            .description_outlined,
                        label: Translations.get(
                            'description',
                            isEnglish),
                        placeholder:
                            Translations.get(
                                'enter_description',
                                isEnglish),
                      ),
                      const SizedBox(height: 25),
                      _buildTypeSelector(
                          isEnglish),
                      const SizedBox(height: 25),
                      _buildCategorySelector(
                          isEnglish),
                      const SizedBox(height: 25),
                      _buildDateSelector(
                          isEnglish),
                      const SizedBox(height: 30),
                      _buildSubmitButton(
                          isEnglish),
                    ],
                  ),
                ),
              ),
            ),
            if (_isLoading)
              _buildLoadingOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    required String placeholder,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .titleMedium,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            hintText: placeholder,
            border: const OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeSelector(bool isEnglish) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          Translations.get(
              'transaction_type', isEnglish),
          style: Theme.of(context)
              .textTheme
              .titleMedium,
        ),
        const SizedBox(height: 8),
        Row(
          children: _types
              .map((type) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets
                          .symmetric(
                          horizontal: 4),
                      child: ElevatedButton(
                        style: ElevatedButton
                            .styleFrom(
                          backgroundColor: _selectedType ==
                                  type
                              ? (type ==
                                      Translations.get(
                                          'income',
                                          isEnglish)
                                  ? Colors.green
                                  : Colors.red)
                              : Theme.of(context)
                                  .colorScheme
                                  .surface,
                          foregroundColor:
                              _selectedType ==
                                      type
                                  ? Colors.white
                                  : Theme.of(
                                          context)
                                      .colorScheme
                                      .onSurface,
                        ),
                        onPressed: () => setState(
                            () => _selectedType =
                                type),
                        child: Text(type),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildCategorySelector(bool isEnglish) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          Translations.get('category', isEnglish),
          style: Theme.of(context)
              .textTheme
              .titleMedium,
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _showCategoryPicker,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .outline),
              borderRadius:
                  BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Icon(_getCategoryIcon(
                    _selectedCategory)),
                const SizedBox(width: 12),
                Text(
                  _selectedCategory ??
                      Translations.get(
                          'select_category',
                          isEnglish),
                  style: TextStyle(
                    color:
                        _selectedCategory == null
                            ? Theme.of(context)
                                .hintColor
                            : Theme.of(context)
                                .colorScheme
                                .onSurface,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelector(bool isEnglish) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          Translations.get(
              'transaction_date', isEnglish),
          style: Theme.of(context)
              .textTheme
              .titleMedium,
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _showDatePicker(context),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .outline),
              borderRadius:
                  BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today),
                const SizedBox(width: 12),
                Text(DateFormat('dd/MM/yyyy')
                    .format(_selectedDate)),
                const Spacer(),
                const Icon(
                    Icons.arrow_forward_ios,
                    size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(bool isEnglish) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
            vertical: 16),
      ),
      onPressed: _submitForm,
      child: Text(
        widget.expense == null
            ? Translations.get(
                'add_transaction', isEnglish)
            : Translations.get(
                'update_transaction', isEnglish),
        style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Theme.of(context)
          .colorScheme
          .surface
          .withOpacity(0.8),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  IconData _getCategoryIcon(String? category) {
    // Check by key first
    if (_categoryKeys.contains(category)) {
      switch (category) {
        case 'food_drink':
          return Icons.restaurant;
        case 'housing':
          return Icons.home;
        case 'vehicle':
          return Icons.directions_car;
        case 'beauty':
          return Icons.face;
        case 'clothing':
          return Icons.shopping_bag;
        case 'travel':
          return Icons.flight;
        case 'salary':
          return Icons.attach_money;
        case 'education':
          return Icons.school;
        case 'transport':
          return Icons.directions_transit;
        case 'entertainment':
          return Icons.sports_esports;
        case 'health':
          return Icons.local_hospital;
        case 'other':
          return Icons.help_outline;
        default:
          return Icons.category;
      }
    }

    // Check by Vietnamese name for backward compatibility
    switch (category) {
      case 'Ăn uống':
      case 'Food & Drink':
        return Icons.restaurant;
      case 'Nhà cửa':
      case 'Housing':
        return Icons.home;
      case 'Xe cộ':
      case 'Vehicle':
        return Icons.directions_car;
      case 'Làm đẹp':
      case 'Beauty':
        return Icons.face;
      case 'Quần áo':
      case 'Clothing':
        return Icons.shopping_bag;
      case 'Du lịch':
      case 'Travel':
        return Icons.flight;
      case 'Lương':
      case 'Salary':
        return Icons.attach_money;
      case 'Học phí':
      case 'Education':
        return Icons.school;
      case 'Di chuyển':
      case 'Transport':
        return Icons.directions_transit;
      case 'Giải trí':
      case 'Entertainment':
        return Icons.sports_esports;
      case 'Sức khỏe':
      case 'Health':
        return Icons.local_hospital;
      case 'Khác':
      case 'Other':
        return Icons.help_outline;
      default:
        return Icons.category;
    }
  }

  void _showCategoryPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 300,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              Translations.get(
                  'select_category',
                  Provider.of<SettingsProvider>(
                          context,
                          listen: false)
                      .isEnglish),
              style: Theme.of(context)
                  .textTheme
                  .titleLarge,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _categoryKeys.length,
                itemBuilder: (context, index) {
                  final categoryKey =
                      _categoryKeys[index];
                  final categoryName =
                      Translations.get(
                          categoryKey,
                          Provider.of<SettingsProvider>(
                                  context,
                                  listen: false)
                              .isEnglish);
                  return ListTile(
                    leading: Icon(
                        _getCategoryIcon(
                            categoryKey)),
                    title: Text(categoryName),
                    onTap: () {
                      setState(() =>
                          _selectedCategory =
                              categoryName);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDatePicker(
      BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null &&
        picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ??
        false) {
      final settingsProvider =
          Provider.of<SettingsProvider>(context,
              listen: false);
      final isEnglish =
          settingsProvider.isEnglish;

      if (_selectedCategory == null) {
        _showErrorDialog(
            context,
            Translations.get(
                'please_select_category',
                isEnglish));
        return;
      }
      if (_selectedType == null) {
        _showErrorDialog(
            context,
            Translations.get(
                'please_select_type', isEnglish));
        return;
      }
      final expense = Expense(
        id: widget.expense?.id ?? uuid.v4(),
        title: _titleController.text,
        amount: (_selectedType ==
                Translations.get(
                    'expense', isEnglish))
            ? -double.parse(
                _amountController.text)
            : double.parse(
                _amountController.text),
        date: _selectedDate,
        category: _selectedCategory!,
        description:
            _descriptionController.text.isEmpty
                ? Translations.get(
                    'no_description', isEnglish)
                : _descriptionController.text,
        type: _selectedType!,
      );
      setState(() => _isLoading = true);
      try {
        if (widget.expense == null) {
          await Provider.of<ExpenseProvider>(
                  context,
                  listen: false)
              .addExpense(expense);
          if (mounted) Navigator.pop(context);
          _showSuccessDialog(context, true);
        } else {
          await Provider.of<ExpenseProvider>(
                  context,
                  listen: false)
              .updateExpense(expense);
          if (mounted) Navigator.pop(context);
          _showSuccessDialog(context, false);
        }
      } catch (e) {
        if (mounted)
          _showErrorDialog(context, e.toString());
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorDialog(
      BuildContext context, String errorMessage) {
    final isEnglish =
        Provider.of<SettingsProvider>(context,
                listen: false)
            .isEnglish;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(Translations.get(
              'error', isEnglish)),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              child: Text(Translations.get(
                  'ok', isEnglish)),
              onPressed: () =>
                  Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(
      BuildContext context, bool isAdd) {
    final isEnglish =
        Provider.of<SettingsProvider>(context,
                listen: false)
            .isEnglish;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(Translations.get(
              'success', isEnglish)),
          content: Text(isAdd
              ? Translations.get(
                  'add_success', isEnglish)
              : Translations.get(
                  'update_success', isEnglish)),
          actions: <Widget>[
            TextButton(
              child: Text(Translations.get(
                  'ok', isEnglish)),
              onPressed: () =>
                  Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
