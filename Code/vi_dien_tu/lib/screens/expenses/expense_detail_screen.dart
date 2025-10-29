import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vi_dien_tu/models/expense.dart';
import 'package:vi_dien_tu/providers/expense_provider.dart';
import 'package:vi_dien_tu/providers/settings_provider.dart';
import 'package:vi_dien_tu/widgets/edit_expense_form.dart';
import 'package:vi_dien_tu/utils/translations.dart';
import 'package:vi_dien_tu/utils/app_colors.dart';
import 'package:intl/intl.dart';

class ExpenseDetailScreen extends StatefulWidget {
  final Expense expense;

  const ExpenseDetailScreen(
      {super.key, required this.expense});

  @override
  State<ExpenseDetailScreen> createState() =>
      _ExpenseDetailScreenState();
}

class _ExpenseDetailScreenState
    extends State<ExpenseDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isIncome =
        widget.expense.type == 'Thu nhập';
    final color = isIncome
        ? AppColors.success
        : AppColors.primary;

    return Scaffold(
      backgroundColor: const Color(0xfff9f9e8),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(color, isIncome),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding:
                      const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildAmountCard(
                          color, isIncome),
                      const SizedBox(height: 20),
                      _buildDetailsCard(),
                      const SizedBox(height: 20),
                      _buildActionButtons(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(
      Color color, bool isIncome) {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      backgroundColor: color,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color,
                color.withOpacity(0.8)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.end,
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Icon(
                    _getCategoryIcon(
                        widget.expense.category),
                    color: Colors.white,
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.expense.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAmountCard(
      Color color, bool isIncome) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isIncome
                  ? Icons.trending_up
                  : Icons.trending_down,
              color: color,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isIncome ? 'Thu nhập' : 'Chi tiêu',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${isIncome ? '+' : '-'}${_formatCurrency(widget.expense.amount.abs())}',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius:
                  BorderRadius.circular(20),
            ),
            child: Text(
              widget.expense.category,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Container(
      width: double.infinity,
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
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Consumer<SettingsProvider>(
              builder:
                  (context, settings, child) {
                return Text(
                  Translations.get('view_details',
                      settings.isEnglish),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                );
              },
            ),
          ),
          Consumer<SettingsProvider>(
            builder: (context, settings, child) {
              return Column(
                children: [
                  _buildDetailItem(
                    Icons.calendar_today_outlined,
                    Translations.get(
                        'transaction_date',
                        settings.isEnglish),
                    DateFormat('dd/MM/yyyy')
                        .format(
                            widget.expense.date),
                    Colors.blue,
                  ),
                  _buildDetailItem(
                    Icons.access_time_outlined,
                    settings.isEnglish
                        ? 'Time'
                        : 'Thời gian',
                    DateFormat('HH:mm').format(
                        widget.expense.date),
                    Colors.orange,
                  ),
                  _buildDetailItem(
                    Icons.category_outlined,
                    Translations.get('category',
                        settings.isEnglish),
                    widget.expense.category,
                    Colors.purple,
                  ),
                ],
              );
            },
          ),
          Consumer<SettingsProvider>(
            builder: (context, settings, child) {
              return Column(
                children: [
                  if (widget.expense.description
                      .isNotEmpty)
                    _buildDetailItem(
                      Icons.description_outlined,
                      Translations.get(
                          'description',
                          settings.isEnglish),
                      widget.expense.description,
                      Colors.green,
                    ),
                  _buildDetailItem(
                    Icons.receipt_outlined,
                    settings.isEnglish
                        ? 'Transaction ID'
                        : 'Mã giao dịch',
                    'TXN${widget.expense.id}',
                    Colors.grey,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(
      IconData icon,
      String title,
      String value,
      Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius:
                  BorderRadius.circular(10),
            ),
            child: Icon(icon,
                color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _editExpense,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                  vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            icon: const Icon(Icons.edit),
            label: Consumer<SettingsProvider>(
              builder:
                  (context, settings, child) {
                return Text(
                  Translations.get(
                      'edit', settings.isEnglish),
                  style: const TextStyle(
                      fontWeight:
                          FontWeight.w600),
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _deleteExpense,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                  vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            icon: const Icon(Icons.delete),
            label: Consumer<SettingsProvider>(
              builder:
                  (context, settings, child) {
                return Text(
                  Translations.get('delete',
                      settings.isEnglish),
                  style: const TextStyle(
                      fontWeight:
                          FontWeight.w600),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _editExpense() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditExpenseForm(
            expense: widget.expense),
      ),
    ).then((_) {
      // Refresh the detail screen when returning from edit
      setState(() {});
    });
  }

  void _deleteExpense() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(16)),
        title: Consumer<SettingsProvider>(
          builder: (context, settings, child) {
            return Text(Translations.get(
                'confirm_delete',
                settings.isEnglish));
          },
        ),
        content: Consumer<SettingsProvider>(
          builder: (context, settings, child) {
            return Text(Translations.get(
                'delete_confirmation',
                settings.isEnglish));
          },
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context),
            child: Consumer<SettingsProvider>(
              builder:
                  (context, settings, child) {
                return Text(Translations.get(
                    'cancel',
                    settings.isEnglish));
              },
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await context
                    .read<ExpenseProvider>()
                    .deleteExpense(
                        widget.expense);
                if (mounted) {
                  Navigator.pop(
                      context); // Close dialog
                  Navigator.pop(
                      context); // Close detail screen
                  final settings = Provider.of<
                          SettingsProvider>(
                      context,
                      listen: false);
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
                if (mounted) {
                  Navigator.pop(context);
                  final settings = Provider.of<
                          SettingsProvider>(
                      context,
                      listen: false);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    SnackBar(
                      content: Text(
                          '${Translations.get('error', settings.isEnglish)}: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red),
            child: Consumer<SettingsProvider>(
              builder:
                  (context, settings, child) {
                return Text(
                  Translations.get('delete',
                      settings.isEnglish),
                  style: const TextStyle(
                      color: Colors.white),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'ăn uống':
        return Icons.restaurant;
      case 'di chuyển':
        return Icons.directions_car;
      case 'nhà cửa':
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

  String _formatCurrency(double amount) {
    return '${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ';
  }
}
