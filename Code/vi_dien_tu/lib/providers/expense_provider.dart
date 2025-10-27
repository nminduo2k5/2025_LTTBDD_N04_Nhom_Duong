import 'package:flutter/foundation.dart';
import 'package:vi_dien_tu/models/expense.dart';
import 'package:vi_dien_tu/services/database_service.dart';
import 'package:intl/intl.dart';

class ExpenseProvider with ChangeNotifier {
  List<Expense> _expenses = [];
  List<Expense> _filteredExpenses = [];
  String? _email;

  ExpenseProvider() {
    fetchExpenses();
  }

  List<Expense> get expenses => _filteredExpenses;
  String? get email => _email;

  Future<void> fetchExpenses() async {
    try {
      _expenses = await DatabaseService.getExpenses();
      _filteredExpenses = _expenses;
      notifyListeners();
    } catch (e) {
      throw Exception("Failed to fetch expenses: $e");
    }
  }

  Future<void> addExpense(Expense expense) async {
    try {
      _expenses.add(expense);
      await DatabaseService.saveExpenses(_expenses);
      _filteredExpenses = List.from(_expenses);
      notifyListeners();
    } catch (e) {
      throw Exception("Failed to add expense: $e");
    }
  }

  Future<void> updateExpense(Expense updatedExpense) async {
    try {
      final index = _expenses.indexWhere((e) => e.id == updatedExpense.id);
      if (index != -1) {
        _expenses[index] = updatedExpense;
        final filterIndex = _filteredExpenses.indexWhere((e) => e.id == updatedExpense.id);
        if (filterIndex != -1) {
          _filteredExpenses[filterIndex] = updatedExpense;
        }
        await DatabaseService.saveExpenses(_expenses);
        notifyListeners();
      }
    } catch (e) {
      throw Exception("Failed to update expense: $e");
    }
  }

  Future<void> deleteExpense(Expense expense) async {
    try {
      _expenses.removeWhere((e) => e.id == expense.id);
      await DatabaseService.saveExpenses(_expenses);
      _filteredExpenses = List.from(_expenses);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to delete expense: $e');
    }
  }

  void searchExpenses(String query) {
    final lowercaseQuery = query.toLowerCase();

    if (query.isEmpty) {
      _filteredExpenses = List.from(_expenses);
    } else {
      _filteredExpenses =
          _expenses.where((expense) {
        final title = expense.title.toLowerCase();
        final category =
            expense.category.toLowerCase();
        final amount = expense.amount.toString();
        final description =
            expense.description.toLowerCase();
        final type = expense.type.toLowerCase();
        final date = DateFormat('dd/MM/yyyy')
            .format(expense.date);

        return title.contains(lowercaseQuery) ||
            category.contains(lowercaseQuery) ||
            amount.contains(query) ||
            description
                .contains(lowercaseQuery) ||
            type.contains(lowercaseQuery) ||
            date.contains(lowercaseQuery);
      }).toList();
    }
    _debugPrint(
        "searchExpenses: query: $query, results: ${_filteredExpenses.length}");
    notifyListeners();
  }

  // Setter cho thuộc tính email
  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  // Helper function for debugging (only in debug mode)
  void _debugPrint(String message) {
    if (kDebugMode) {
      print(message);
    }
  }
}
