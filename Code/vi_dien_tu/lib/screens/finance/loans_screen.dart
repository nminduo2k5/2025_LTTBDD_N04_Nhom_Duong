import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vi_dien_tu/providers/settings_provider.dart';

class LoansScreen extends StatelessWidget {
  const LoansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFFFF8DC),
          appBar: AppBar(
            title: Text(settings.isEnglish ? '🇻🇳 Vietnam Loans' : '🇻🇳 Khoản Vay Việt Nam'),
            backgroundColor: const Color(0xFFDA020E),
            foregroundColor: Colors.white,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFDA020E), Color(0xFFFF6B6B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildLoanCard(
                  'Vay Tiêu Dùng',
                  'Lãi suất từ 6.5%/năm',
                  'Lên đến 500 triệu VNĐ',
                  Icons.shopping_cart,
                  settings,
                ),
                _buildLoanCard(
                  'Vay Mua Nhà',
                  'Lãi suất từ 8.2%/năm',
                  'Lên đến 5 tỷ VNĐ',
                  Icons.home,
                  settings,
                ),
                _buildLoanCard(
                  'Vay Mua Xe',
                  'Lãi suất từ 7.5%/năm',
                  'Lên đến 2 tỷ VNĐ',
                  Icons.directions_car,
                  settings,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoanCard(String title, String rate, String amount, IconData icon, SettingsProvider settings) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFDA020E).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFFDA020E), size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(rate, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                Text(amount, style: const TextStyle(color: Color(0xFFDA020E), fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}