import 'package:vi_dien_tu/models/wallet.dart';

class WalletService {
  static final List<Wallet> _wallets = [
    Wallet(
      id: '1',
      name: 'Ví tiền mặt',
      type: 'cash',
      balance: 2500000,
      isDefault: true,
      color: '#4CAF50',
      icon: 'wallet',
    ),
    Wallet(
      id: '2',
      name: 'Techcombank',
      type: 'bank',
      balance: 15000000,
      bankName: 'Techcombank',
      accountNumber: '19036584***',
      color: '#2196F3',
      icon: 'bank',
    ),
    Wallet(
      id: '3',
      name: 'Thẻ tín dụng',
      type: 'credit',
      balance: -850000,
      bankName: 'Sacombank',
      cardNumber: '5234 **** **** 1234',
      color: '#FF9800',
      icon: 'credit_card',
    ),
  ];

  Future<List<Wallet>> getAllWallets() async {
    await Future.delayed(
        Duration(milliseconds: 300));
    return List.from(_wallets);
  }

  Future<Wallet> addWallet(Wallet wallet) async {
    await Future.delayed(
        Duration(milliseconds: 300));

    final newWallet = Wallet(
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(),
      name: wallet.name,
      type: wallet.type,
      balance: wallet.balance,
      currency: wallet.currency,
      bankName: wallet.bankName,
      accountNumber: wallet.accountNumber,
      cardNumber: wallet.cardNumber,
      isDefault: wallet.isDefault,
      color: wallet.color,
      icon: wallet.icon,
    );

    _wallets.add(newWallet);
    return newWallet;
  }

  Future<void> updateWallet(Wallet wallet) async {
    await Future.delayed(
        Duration(milliseconds: 300));

    final index = _wallets
        .indexWhere((w) => w.id == wallet.id);
    if (index != -1) {
      _wallets[index] = wallet;
    } else {
      throw Exception(
          'Không tìm thấy ví để cập nhật');
    }
  }

  Future<void> deleteWallet(
      String walletId) async {
    await Future.delayed(
        Duration(milliseconds: 300));

    final initialLength = _wallets.length;
    _wallets.removeWhere((w) => w.id == walletId);
    if (_wallets.length == initialLength) {
      throw Exception('Không tìm thấy ví để xóa');
    }
  }

  Future<Wallet?> getWalletById(
      String walletId) async {
    await Future.delayed(
        Duration(milliseconds: 100));
    try {
      return _wallets
          .firstWhere((w) => w.id == walletId);
    } catch (e) {
      return null;
    }
  }
}
