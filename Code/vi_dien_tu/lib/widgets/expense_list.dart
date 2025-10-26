import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vi_dien_tu/providers/expense_provider.dart';
import 'package:vi_dien_tu/providers/settings_provider.dart';
import 'package:vi_dien_tu/models/expense.dart';
import 'package:vi_dien_tu/screens/expenses/expense_detail_screen.dart';
import 'package:vi_dien_tu/widgets/edit_expense_form.dart';
import 'package:vi_dien_tu/utils/translations.dart';
import 'package:vi_dien_tu/utils/app_colors.dart';
import 'package:intl/intl.dart';

class ExpenseList extends StatefulWidget {
  final bool isCompact;

  const ExpenseList(
      {super.key, this.isCompact = false});

  @override
  State<ExpenseList> createState() =>
      _ExpenseListState();
}

class _ExpenseListState
    extends State<ExpenseList> {
  final TextEditingController _searchController =
      TextEditingController();
  String _selectedFilter = 'all';

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (context, expenseProvider, child) {
        if (widget.isCompact) {
          return _buildCompactList(
              expenseProvider);
        }

        return Scaffold(
          backgroundColor: Colors.grey[50],
          body: CustomScrollView(
            slivers: [
              _buildSliverAppBar(),
              SliverToBoxAdapter(
                  child: _buildSearchAndFilter(
                      expenseProvider)),
              _buildExpensesList(expenseProvider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSliverAppBar() {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return SliverAppBar(
          expandedHeight: 120,
          floating: false,
          pinned: true,
          backgroundColor: AppColors.primary,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(Translations.get(
                'transactions',
                settings.isEnglish)),
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.teal,
                    Colors.tealAccent
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchAndFilter(
      ExpenseProvider expenseProvider) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Search bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey
                      .withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Consumer<SettingsProvider>(
              builder:
                  (context, settings, child) {
                return TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: Translations.get(
                        'search_transactions',
                        settings.isEnglish),
                    prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.all(16),
                  ),
                  onChanged: (value) {
                    expenseProvider
                        .searchExpenses(value);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          // Filter chips
          Consumer<SettingsProvider>(
            builder: (context, settings, child) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip(
                        'all',
                        Translations.get('all',
                            settings.isEnglish),
                        expenseProvider),
                    _buildFilterChip(
                        'income',
                        Translations.get('income',
                            settings.isEnglish),
                        expenseProvider),
                    _buildFilterChip(
                        'expense',
                        Translations.get(
                            'expense',
                            settings.isEnglish),
                        expenseProvider),
                    _buildFilterChip(
                        'today',
                        Translations.get('today',
                            settings.isEnglish),
                        expenseProvider),
                    _buildFilterChip(
                        'week',
                        Translations.get(
                            'this_week',
                            settings.isEnglish),
                        expenseProvider),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
      String filter,
      String label,
      ExpenseProvider expenseProvider) {
    final isSelected = _selectedFilter == filter;

    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = filter;
          });
          _applyFilter(filter, expenseProvider);
        },
        backgroundColor: Colors.white,
        selectedColor:
            Colors.teal.withOpacity(0.2),
        checkmarkColor: Colors.teal,
        labelStyle: TextStyle(
          color: isSelected
              ? Colors.teal
              : Colors.grey[700],
          fontWeight: isSelected
              ? FontWeight.w600
              : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildExpensesList(
      ExpenseProvider expenseProvider) {
    if (expenseProvider.expenses.isEmpty) {
      return SliverFillRemaining(
        child: _buildEmptyState(),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(
          horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final expense =
                expenseProvider.expenses[index];
            return _buildModernExpenseCard(
                expense);
          },
          childCount:
              expenseProvider.expenses.length,
        ),
      ),
    );
  }

  Widget _buildCompactList(
      ExpenseProvider expenseProvider) {
    if (expenseProvider.expenses.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
          horizontal: 16),
      itemCount:
          expenseProvider.expenses.take(5).length,
      itemBuilder: (context, index) {
        final expense =
            expenseProvider.expenses[index];
        return _buildCompactExpenseCard(expense);
      },
    );
  }

  Widget _buildModernExpenseCard(
      Expense expense) {
    final isIncome = expense.type == 'Thu nhập';
    final color = isIncome
        ? AppColors.success
        : AppColors.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius:
                BorderRadius.circular(12),
          ),
          child: Icon(
            _getCategoryIcon(expense.category),
            color: color,
            size: 24,
          ),
        ),
        title: Text(
          expense.title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              expense.category,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              DateFormat('dd/MM/yyyy HH:mm')
                  .format(expense.date),
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 11,
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          crossAxisAlignment:
              CrossAxisAlignment.end,
          children: [
            Text(
              '${isIncome ? '+' : '-'}${_formatCurrency(expense.amount.abs())}',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Container(
              margin:
                  const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius:
                    BorderRadius.circular(8),
              ),
              child: Text(
                expense.type,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ExpenseDetailScreen(
                      expense: expense),
            ),
          );
        },
        onLongPress: () {
          _showExpenseOptions(context, expense);
        },
      ),
    );
  }

  Widget _buildCompactExpenseCard(
      Expense expense) {
    final isIncome = expense.type == 'Thu nhập';
    final color = isIncome
        ? AppColors.success
        : AppColors.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: Colors.grey[200]!),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ExpenseDetailScreen(
                      expense: expense),
            ),
          );
        },
        onLongPress: () {
          _showExpenseOptions(context, expense);
        },
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius:
                    BorderRadius.circular(8),
              ),
              child: Icon(
                _getCategoryIcon(
                    expense.category),
                color: color,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                  ),
                  Text(
                    DateFormat('dd/MM')
                        .format(expense.date),
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${isIncome ? '+' : '-'}${_formatCurrency(expense.amount.abs())}',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return Center(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: 80,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                Translations.get(
                    'no_transactions',
                    settings.isEnglish),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                Translations.get(
                    'add_first_transaction',
                    settings.isEnglish),
                style: TextStyle(
                    color: Colors.grey[500]),
              ),
            ],
          ),
        );
      },
    );
  }

  void _applyFilter(String filter,
      ExpenseProvider expenseProvider) {
    // Implement filter logic here
    switch (filter) {
      case 'income':
        // Filter income only
        break;
      case 'expense':
        // Filter expenses only
        break;
      case 'today':
        // Filter today's transactions
        break;
      case 'week':
        // Filter this week's transactions
        break;
      default:
        // Show all
        break;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'ăn uống':
        return Icons.restaurant;
      case 'di chuyển':
        return Icons.directions_car;
      case 'nhà cử a':
        return Icons.home;
      case 'sức khỏe':
        return Icons.local_hospital;
      case 'giải trí':
        return Icons.movie;
      case 'quần áo':
        return Icons.shopping_bag;
      case 'giáo dục':
        return Icons.school;
      case 'du lịch':
        return Icons.flight;
      case 'lương':
        return Icons.work;
      default:
        return Icons.category;
    }
  }

  void _showExpenseOptions(
      BuildContext context, Expense expense) {
    final settings =
        Provider.of<SettingsProvider>(context,
            listen: false);

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
            Text(
              expense.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildOptionButton(
                    icon: Icons.visibility,
                    label: Translations.get(
                        'view_details',
                        settings.isEnglish),
                    color: Colors.blue,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ExpenseDetailScreen(
                                  expense:
                                      expense),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildOptionButton(
                    icon: Icons.edit,
                    label: Translations.get(
                        'edit',
                        settings.isEnglish),
                    color: Colors.green,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditExpenseForm(
                                  expense:
                                      expense),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildOptionButton(
                    icon: Icons.delete,
                    label: Translations.get(
                        'delete',
                        settings.isEnglish),
                    color: Colors.red,
                    onTap: () {
                      Navigator.pop(context);
                      _showDeleteDialog(
                          context, expense);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(
      BuildContext context, Expense expense) {
    final settings =
        Provider.of<SettingsProvider>(context,
            listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(Translations.get(
            'confirm_delete',
            settings.isEnglish)),
        content: Text(
          '${Translations.get('delete_confirmation', settings.isEnglish)}\n"${expense.title}"',
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context),
            child: Text(Translations.get(
                'cancel', settings.isEnglish)),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await context
                    .read<ExpenseProvider>()
                    .deleteExpense(expense);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    SnackBar(
                      content: Text(
                          Translations.get(
                              'delete_success',
                              settings
                                  .isEnglish)),
                      backgroundColor:
                          Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    SnackBar(
                      content: Text(
                          '${Translations.get('error', settings.isEnglish)}: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red),
            child: Text(
              Translations.get(
                  'delete', settings.isEnglish),
              style: const TextStyle(
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double amount) {
    return '${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
