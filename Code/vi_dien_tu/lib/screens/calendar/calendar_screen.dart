import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vi_dien_tu/providers/expense_provider.dart';
import 'package:vi_dien_tu/providers/settings_provider.dart';
import 'package:vi_dien_tu/models/expense.dart';
import 'package:vi_dien_tu/screens/expenses/expense_detail_screen.dart';
import 'package:vi_dien_tu/utils/translations.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() =>
      _CalendarScreenState();
}

class _CalendarScreenState
    extends State<CalendarScreen>
    with TickerProviderStateMixin {
  late final ValueNotifier<List<Expense>>
      _selectedEvents;
  CalendarFormat _calendarFormat =
      CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _selectedEvents = ValueNotifier(
        _getEventsForDay(_selectedDay!));

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0)
            .animate(
      CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    _animationController.dispose();
    super.dispose();
  }

  List<Expense> _getEventsForDay(DateTime day) {
    final expenseProvider =
        context.read<ExpenseProvider>();
    return expenseProvider.expenses
        .where((expense) {
      return isSameDay(expense.date, day);
    }).toList();
  }

  void _onDaySelected(
      DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      _selectedEvents.value =
          _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8DC),
      body: Consumer<ExpenseProvider>(
        builder:
            (context, expenseProvider, child) {
          return CustomScrollView(
            slivers: [
              _buildSliverAppBar(),
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      _buildCalendarCard(
                          expenseProvider),
                      const SizedBox(height: 16),
                      _buildMonthlyOverview(
                          expenseProvider),
                      const SizedBox(height: 16),
                      _buildSelectedDayEvents(),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
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
              stops: [0.0, 0.6, 1.0],
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
                  Consumer<SettingsProvider>(
                    builder: (context, settings,
                        child) {
                      return Text(
                        settings.isEnglish
                            ? 'Month ${_focusedDay.month}/${_focusedDay.year}'
                            : 'Tháng ${_focusedDay.month}/${_focusedDay.year}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarCard(
      ExpenseProvider expenseProvider) {
    return Container(
      margin: const EdgeInsets.all(16),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: TableCalendar<Expense>(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          eventLoader: _getEventsForDay,
          startingDayOfWeek:
              StartingDayOfWeek.monday,
          selectedDayPredicate: (day) =>
              isSameDay(_selectedDay, day),
          onDaySelected: _onDaySelected,
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
          calendarStyle: CalendarStyle(
            outsideDaysVisible: false,
            weekendTextStyle: const TextStyle(
                color: Colors.red),
            holidayTextStyle: const TextStyle(
                color: Colors.red),
            selectedDecoration: BoxDecoration(
              color: const Color(0xFFDA020E),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFDA020E)
                      .withOpacity(0.3),
                  spreadRadius: 0,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            todayDecoration: const BoxDecoration(
              color: Color(0xFFDA020E),
              shape: BoxShape.circle,
            ),
            markerDecoration: const BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
            markersMaxCount: 3,
          ),
          headerStyle: const HeaderStyle(
            formatButtonVisible: true,
            titleCentered: true,
            formatButtonShowsNext: false,
            formatButtonDecoration: BoxDecoration(
              color: Color(0xFFDA020E),
              borderRadius: BorderRadius.all(
                  Radius.circular(12)),
            ),
            formatButtonTextStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMonthlyOverview(
      ExpenseProvider expenseProvider) {
    final monthlyExpenses =
        expenseProvider.expenses.where((expense) {
      return expense.date.year ==
              _focusedDay.year &&
          expense.date.month == _focusedDay.month;
    }).toList();

    final totalIncome = monthlyExpenses
        .where((e) => e.type == 'Thu nhập')
        .fold(0.0,
            (sum, e) => sum + e.amount.abs());

    final totalExpense = monthlyExpenses
        .where((e) => e.type == 'Chi tiêu')
        .fold(0.0,
            (sum, e) => sum + e.amount.abs());

    final balance = totalIncome - totalExpense;

    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: 16),
      padding: const EdgeInsets.all(20),
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
          Consumer<SettingsProvider>(
            builder: (context, settings, child) {
              return Text(
                settings.isEnglish
                    ? 'Month ${_focusedDay.month} Overview'
                    : 'Tổng quan tháng ${_focusedDay.month}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Consumer<SettingsProvider>(
                  builder:
                      (context, settings, child) {
                    return _buildOverviewItem(
                      Translations.get('income',
                          settings.isEnglish),
                      totalIncome,
                      Icons.trending_up,
                      Colors.green,
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Consumer<SettingsProvider>(
                  builder:
                      (context, settings, child) {
                    return _buildOverviewItem(
                      Translations.get('expense',
                          settings.isEnglish),
                      totalExpense,
                      Icons.trending_down,
                      Colors.red,
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: balance >= 0
                  ? Colors.green.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
              borderRadius:
                  BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Consumer<SettingsProvider>(
                  builder:
                      (context, settings, child) {
                    return Text(
                      Translations.get('balance',
                          settings.isEnglish),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 4),
                Text(
                  '${balance >= 0 ? '+' : ''}${_formatCurrency(balance)}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: balance >= 0
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewItem(String title,
      double amount, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _formatCurrency(amount),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedDayEvents() {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: 16),
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
            child: Row(
              children: [
                Icon(
                  Icons.event_note,
                  color: const Color(0xFFDA020E),
                  size: 24,
                ),
                const SizedBox(width: 8),
                Consumer<SettingsProvider>(
                  builder:
                      (context, settings, child) {
                    return Text(
                      settings.isEnglish
                          ? 'Transactions on ${DateFormat('dd/MM/yyyy').format(_selectedDay ?? DateTime.now())}'
                          : 'Giao dịch ngày ${DateFormat('dd/MM/yyyy').format(_selectedDay ?? DateTime.now())}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          ValueListenableBuilder<List<Expense>>(
            valueListenable: _selectedEvents,
            builder: (context, value, _) {
              if (value.isEmpty) {
                return Padding(
                  padding:
                      const EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.event_busy,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 8),
                        Consumer<
                            SettingsProvider>(
                          builder: (context,
                              settings, child) {
                            return Text(
                              Translations.get(
                                  'no_transactions_date',
                                  settings
                                      .isEnglish),
                              style: TextStyle(
                                color: Colors
                                    .grey[600],
                                fontSize: 16,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                itemCount: value.length,
                separatorBuilder:
                    (context, index) => Divider(
                  height: 1,
                  color: Colors.grey[200],
                ),
                itemBuilder: (context, index) {
                  final expense = value[index];
                  final isIncome =
                      expense.type == 'Thu nhập';
                  final color = isIncome
                      ? Colors.green
                      : Colors.red;

                  return ListTile(
                    contentPadding:
                        const EdgeInsets
                            .symmetric(
                            horizontal: 20,
                            vertical: 8),
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: color
                            .withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(
                                12),
                      ),
                      child: Icon(
                        _getCategoryIcon(
                            expense.category),
                        color: color,
                        size: 24,
                      ),
                    ),
                    title: Text(
                      expense.title,
                      style: const TextStyle(
                        fontWeight:
                            FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Text(
                          expense.category,
                          style: TextStyle(
                            color:
                                Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          DateFormat('HH:mm')
                              .format(
                                  expense.date),
                          style: TextStyle(
                            color:
                                Colors.grey[500],
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    trailing: Text(
                      '${isIncome ? '+' : '-'}${_formatCurrency(expense.amount.abs())}',
                      style: TextStyle(
                        color: color,
                        fontWeight:
                            FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
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
                  );
                },
              );
            },
          ),
          const SizedBox(height: 20),
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
