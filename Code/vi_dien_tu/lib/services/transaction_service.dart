import 'package:vi_dien_tu/models/transaction.dart';

class TransactionService {
  static final List<Transaction> _transactions = [
    Transaction(
      id: '1',
      type: 'transfer',
      amount: 500000,
      fromWalletId: '2',
      toWalletId: '1',
      description: 'Rút tiền ATM',
      createdAt: DateTime.now()
          .subtract(Duration(hours: 2)),
      status: 'completed',
      transactionCode: 'TXN001',
      fee: 5000,
    ),
    Transaction(
      id: '2',
      type: 'payment',
      amount: 85000,
      fromWalletId: '1',
      recipientInfo: '0987654321',
      recipientName: 'Nguyễn Văn A',
      description: 'Thanh toán Grab',
      createdAt: DateTime.now()
          .subtract(Duration(hours: 5)),
      status: 'completed',
      transactionCode: 'TXN002',
    ),
    Transaction(
      id: '3',
      type: 'topup',
      amount: 200000,
      fromWalletId: '2',
      recipientInfo: '0123456789',
      description: 'Nạp tiền điện thoại',
      createdAt: DateTime.now()
          .subtract(Duration(days: 1)),
      status: 'completed',
      transactionCode: 'TXN003',
      fee: 2000,
    ),
  ];

  Future<List<Transaction>>
      getAllTransactions() async {
    await Future.delayed(
        Duration(milliseconds: 300));
    return List.from(_transactions);
  }

  Future<Transaction> createTransaction(
      Transaction transaction) async {
    await Future.delayed(
        Duration(milliseconds: 500));

    final newTransaction = Transaction(
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(),
      type: transaction.type,
      amount: transaction.amount,
      fromWalletId: transaction.fromWalletId,
      toWalletId: transaction.toWalletId,
      recipientInfo: transaction.recipientInfo,
      recipientName: transaction.recipientName,
      description: transaction.description,
      createdAt: DateTime.now(),
      status: 'pending',
      transactionCode:
          'TXN${DateTime.now().millisecondsSinceEpoch}',
      fee: transaction.fee,
      qrCode: transaction.qrCode,
    );

    _transactions.insert(0, newTransaction);

    // Simulate processing time
    await Future.delayed(Duration(seconds: 2));

    // Update status to completed
    final index = _transactions.indexWhere(
        (t) => t.id == newTransaction.id);
    if (index != -1) {
      _transactions[index] = Transaction(
        id: newTransaction.id,
        type: newTransaction.type,
        amount: newTransaction.amount,
        fromWalletId: newTransaction.fromWalletId,
        toWalletId: newTransaction.toWalletId,
        recipientInfo:
            newTransaction.recipientInfo,
        recipientName:
            newTransaction.recipientName,
        description: newTransaction.description,
        createdAt: newTransaction.createdAt,
        status: 'completed',
        transactionCode:
            newTransaction.transactionCode,
        fee: newTransaction.fee,
        qrCode: newTransaction.qrCode,
      );
    }

    return newTransaction;
  }

  Future<void> updateTransactionStatus(
      String transactionId, String status) async {
    await Future.delayed(
        Duration(milliseconds: 300));

    final index = _transactions
        .indexWhere((t) => t.id == transactionId);
    if (index != -1) {
      final transaction = _transactions[index];
      _transactions[index] = Transaction(
        id: transaction.id,
        type: transaction.type,
        amount: transaction.amount,
        fromWalletId: transaction.fromWalletId,
        toWalletId: transaction.toWalletId,
        recipientInfo: transaction.recipientInfo,
        recipientName: transaction.recipientName,
        description: transaction.description,
        createdAt: transaction.createdAt,
        status: status,
        transactionCode:
            transaction.transactionCode,
        fee: transaction.fee,
        qrCode: transaction.qrCode,
      );
    } else {
      throw Exception(
          'Không tìm thấy giao dịch để cập nhật');
    }
  }

  Future<Transaction?> getTransactionById(
      String transactionId) async {
    await Future.delayed(
        Duration(milliseconds: 100));
    try {
      return _transactions.firstWhere(
          (t) => t.id == transactionId);
    } catch (e) {
      return null;
    }
  }
}
