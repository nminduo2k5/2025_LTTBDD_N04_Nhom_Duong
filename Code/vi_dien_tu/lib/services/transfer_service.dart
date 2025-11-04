import 'package:vi_dien_tu/models/transaction.dart';
import 'package:vi_dien_tu/models/wallet.dart';
import 'package:vi_dien_tu/services/database_service.dart';
import 'package:uuid/uuid.dart';

class TransferService {
  static const Uuid _uuid = Uuid();

  static Future<Transaction> transferMoney({
    required String fromWalletId,
    required String toWalletId,
    required double amount,
    required String description,
    String? recipientName,
    String? recipientInfo,
  }) async {
    // Get current wallets
    final wallets = await DatabaseService.getWallets();
    
    // Find source and destination wallets
    final fromWallet = wallets.firstWhere((w) => w.id == fromWalletId);
    final toWallet = wallets.firstWhere((w) => w.id == toWalletId);
    
    // Check if source wallet has enough balance
    if (fromWallet.balance < amount) {
      throw Exception('Số dư không đủ để thực hiện giao dịch');
    }
    
    // Update wallet balances
    final updatedFromWallet = fromWallet.copyWith(
      balance: fromWallet.balance - amount,
    );
    final updatedToWallet = toWallet.copyWith(
      balance: toWallet.balance + amount,
    );
    
    // Update wallets list
    final updatedWallets = wallets.map((w) {
      if (w.id == fromWalletId) return updatedFromWallet;
      if (w.id == toWalletId) return updatedToWallet;
      return w;
    }).toList();
    
    // Save updated wallets
    await DatabaseService.saveWallets(updatedWallets);
    
    // Create transaction record
    final transaction = Transaction(
      id: _uuid.v4(),
      type: 'transfer',
      amount: amount,
      fromWalletId: fromWalletId,
      toWalletId: toWalletId,
      recipientName: recipientName ?? toWallet.name,
      recipientInfo: recipientInfo,
      description: description,
      createdAt: DateTime.now(),
      status: 'completed',
      transactionCode: 'TF${DateTime.now().millisecondsSinceEpoch}',
      fee: 0.0,
    );
    
    // Save transaction
    final transactions = await DatabaseService.getTransactions();
    transactions.insert(0, transaction);
    await DatabaseService.saveTransactions(transactions);
    
    return transaction;
  }

  static Future<List<Wallet>> getAvailableWallets() async {
    return await DatabaseService.getWallets();
  }

  static Future<Wallet> getWalletById(String walletId) async {
    final wallets = await DatabaseService.getWallets();
    return wallets.firstWhere((w) => w.id == walletId);
  }
}