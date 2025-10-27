import 'package:flutter/foundation.dart';
import 'package:vi_dien_tu/models/wallet.dart';
import 'package:vi_dien_tu/services/database_service.dart';

class WalletProvider with ChangeNotifier {
  List<Wallet> _wallets = [];
  Wallet? _selectedWallet;

  List<Wallet> get wallets => _wallets;
  Wallet? get selectedWallet => _selectedWallet;
  Wallet? get defaultWallet {
    try {
      return _wallets
          .where((w) => w.isDefault)
          .first;
    } catch (e) {
      return null;
    }
  }

  double get totalBalance => _wallets.fold(
      0.0, (sum, wallet) => sum + wallet.balance);

  Future<void> fetchWallets() async {
    try {
      _wallets = await DatabaseService.getWallets();
      if (_selectedWallet == null &&
          _wallets.isNotEmpty) {
        _selectedWallet =
            defaultWallet ?? _wallets.first;
      }
      notifyListeners();
    } catch (e) {
      throw Exception(
          'Failed to fetch wallets: $e');
    }
  }

  Future<void> addWallet(Wallet wallet) async {
    try {
      _wallets.add(wallet);
      await DatabaseService.saveWallets(_wallets);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to add wallet: $e');
    }
  }

  Future<void> updateWallet(Wallet wallet) async {
    try {
      final index = _wallets
          .indexWhere((w) => w.id == wallet.id);
      if (index != -1) {
        _wallets[index] = wallet;
        if (_selectedWallet?.id == wallet.id) {
          _selectedWallet = wallet;
        }
        await DatabaseService.saveWallets(_wallets);
        notifyListeners();
      }
    } catch (e) {
      throw Exception(
          'Failed to update wallet: $e');
    }
  }

  Future<void> deleteWallet(
      String walletId) async {
    try {
      _wallets
          .removeWhere((w) => w.id == walletId);
      if (_selectedWallet?.id == walletId) {
        _selectedWallet = _wallets.isNotEmpty
            ? _wallets.first
            : null;
      }
      await DatabaseService.saveWallets(_wallets);
      notifyListeners();
    } catch (e) {
      throw Exception(
          'Failed to delete wallet: $e');
    }
  }

  void selectWallet(Wallet wallet) {
    _selectedWallet = wallet;
    notifyListeners();
  }

  Future<void> updateWalletBalance(
      String walletId, double newBalance) async {
    final index = _wallets
        .indexWhere((w) => w.id == walletId);
    if (index != -1) {
      final updatedWallet = _wallets[index]
          .copyWith(balance: newBalance);
      await updateWallet(updatedWallet);
    }
  }
}
