import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vi_dien_tu/providers/settings_provider.dart';

class CreditWalletScreen extends StatelessWidget {
  const CreditWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFFFF8DC),
          appBar: AppBar(
            title: Text(settings.isEnglish ? '🇻🇳 Credit Wallet VN' : '🇻🇳 Ví Trả Sau VN'),
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
                _buildCreditCard(settings),
                const SizedBox(height: 20),
                _buildFeatureCard(
                  'Mua Trước Trả Sau',
                  'Thanh toán linh hoạt với hạn mức lên đến 50 triệu',
                  Icons.credit_card,
                  settings,
                ),
                _buildFeatureCard(
                  'Trả Góp 0%',
                  'Trả góp không lãi suất cho các sản phẩm được chọn',
                  Icons.percent,
                  settings,
                ),
                _buildFeatureCard(
                  'Ưu Đãi Đặc Biệt',
                  'Giảm giá và hoàn tiền cho thành viên VIP',
                  Icons.star,
                  settings,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCreditCard(SettingsProvider settings) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFDA020E), Color(0xFFFFCD00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                settings.isEnglish ? 'SmartWallet Credit VN' : 'Ví Tín Dụng VN',
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Icon(Icons.contactless, color: Colors.white, size: 30),
            ],
          ),
          const SizedBox(height: 20),
          const Text('Hạn mức khả dụng', style: TextStyle(color: Colors.white70, fontSize: 14)),
          const Text('50,000,000đ', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('**** **** **** 1234', style: TextStyle(color: Colors.white, fontSize: 16)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('🇻🇳 VN', style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(String title, String description, IconData icon, SettingsProvider settings) {
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
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFDA020E).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFFDA020E), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(description, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}