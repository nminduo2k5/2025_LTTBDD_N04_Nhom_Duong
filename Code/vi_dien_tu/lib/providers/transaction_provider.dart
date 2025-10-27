import 'package:flutter/foundation.dart';
import 'package:vi_dien_tu/models/transaction.dart';
import 'package:vi_dien_tu/services/database_service.dart';

class TransactionProvider with ChangeNotifier {
  List<Transaction> _transactions = [];
  List<Transaction> _filteredTransactions = [];

  List<Transaction> get transactions => _filteredTransactions;
  List<Transaction> get allTransactions => _transactions;

  Future<void> fetchTransactions() async {
    try {
      _transactions = await DatabaseService.getTransactions();
      _filteredTransactions = _transactions;
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
  }

  Future<Transaction> createTransaction(Transaction transaction) async {
    try {
      _transactions.insert(0, transaction);
      await DatabaseService.saveTransactions(_transactions);
      _filteredTransactions = List.from(_transactions);
      notifyListeners();
      return transaction;
    } catch (e) {
      throw Exception('Failed to create transaction: $e');
    }
  }

  Future<void> updateTransactionStatus(
      String transactionId, String status) async {
    try {
      final index = _transactions.indexWhere(
          (t) => t.id == transactionId);
      if (index != -1) {
        final updatedTransaction = Transaction(
          id: _transactions[index].id,
          type: _transactions[index].type,
          amount: _transactions[index].amount,
          fromWalletId:
              _transactions[index].fromWalletId,
          toWalletId:
              _transactions[index].toWalletId,
          recipientInfo:
              _transactions[index].recipientInfo,
          recipientName:
              _transactions[index].recipientName,
          description:
              _transactions[index].description,
          createdAt:
              _transactions[index].createdAt,
          status: status,
          transactionCode: _transactions[index]
              .transactionCode,
          fee: _transactions[index].fee,
          qrCode: _transactions[index].qrCode,
        );
        _transactions[index] = updatedTransaction;
        await DatabaseService.saveTransactions(_transactions);
        _filteredTransactions =
            List.from(_transactions);
        notifyListeners();
      }
    } catch (e) {
      throw Exception(
          'Failed to update transaction status: $e');
    }
  }

  void filterTransactions({
    String? type,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    _filteredTransactions =
        _transactions.where((transaction) {
      bool matchesType = type == null ||
          transaction.type == type;
      bool matchesStatus = status == null ||
          transaction.status == status;
      bool matchesDateRange = true;

      if (startDate != null && endDate != null) {
        matchesDateRange = transaction.createdAt
                .isAfter(startDate.subtract(
                    Duration(days: 1))) &&
            transaction.createdAt.isBefore(
                endDate.add(Duration(days: 1)));
      }

      return matchesType &&
          matchesStatus &&
          matchesDateRange;
    }).toList();

    notifyListeners();
  }

  void searchTransactions(String query) {
    if (query.isEmpty) {
      _filteredTransactions =
          List.from(_transactions);
    } else {
      final lowercaseQuery = query.toLowerCase();
      _filteredTransactions =
          _transactions.where((transaction) {
        return transaction.description
                .toLowerCase()
                .contains(lowercaseQuery) ||
            (transaction.recipientName
                    ?.toLowerCase()
                    .contains(lowercaseQuery) ??
                false) ||
            (transaction.recipientInfo
                    ?.toLowerCase()
                    .contains(lowercaseQuery) ??
                false) ||
            (transaction.transactionCode
                    ?.toLowerCase()
                    .contains(lowercaseQuery) ??
                false);
      }).toList();
    }
    notifyListeners();
  }

  List<Transaction> getTransactionsByWallet(
      String walletId) {
    return _transactions
        .where((t) =>
            t.fromWalletId == walletId ||
            t.toWalletId == walletId)
        .toList();
  }
}
