import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vi_dien_tu/models/expense.dart';
import 'package:vi_dien_tu/providers/expense_provider.dart';
import 'package:vi_dien_tu/screens/expenses/expense_detail_screen.dart';
import 'package:intl/intl.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;

  const ExpenseCard(
      {super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
      child: Card(
        margin: const EdgeInsets.symmetric(
            vertical: 8.0, horizontal: 16.0),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color:
                      expense.type == 'Thu nhập'
                          ? Colors.green
                              .withOpacity(0.1)
                          : Colors.red
                              .withOpacity(0.1),
                  borderRadius:
                      BorderRadius.circular(12.0),
                ),
                child: Icon(
                  expense.type == 'Thu nhập'
                      ? Icons
                          .arrow_downward_rounded
                      : Icons
                          .arrow_upward_rounded,
                  color:
                      expense.type == 'Thu nhập'
                          ? Colors.green
                          : Colors.red,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      expense.title,
                      style: const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        fontSize: 18.0,
                      ),
                      overflow:
                          TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${NumberFormat("#,##0", "vi_VN").format(expense.amount.abs())} VNĐ - ${expense.category}',
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant,
                        fontSize: 14.0,
                      ),
                      overflow:
                          TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                crossAxisAlignment:
                    CrossAxisAlignment.end,
                children: [
                  Text(
                    '${expense.date.day}/${expense.date.month}/${expense.date.year}',
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant,
                      fontSize: 14.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    expense.type,
                    style: TextStyle(
                      color: expense.type ==
                              'Thu nhập'
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () async {
                  _showDeleteConfirmationDialog(
                      context);
                },
                icon: const Icon(Icons.delete,
                    color: Colors.red, size: 28),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: const Text(
              'Bạn có chắc chắn muốn xóa giao dịch này?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                  foregroundColor: Colors.red),
              child: const Text('Xóa'),
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await Provider.of<
                              ExpenseProvider>(
                          context,
                          listen: false)
                      .deleteExpense(expense);
                } catch (error) {
                  _showErrorDialog(context,
                      'Xóa giao dịch không thành công: ${error.toString()}');
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(
      BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Lỗi'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
