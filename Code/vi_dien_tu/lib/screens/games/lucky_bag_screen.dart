import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vi_dien_tu/providers/settings_provider.dart';

class LuckyBagScreen extends StatelessWidget {
  const LuckyBagScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFFFF8DC),
          appBar: AppBar(
            title: Text(settings.isEnglish ? '🇻🇳 Lucky Bag Vietnam' : '🇻🇳 Túi Thần Tài VN'),
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
                _buildLuckyCard(settings),
                const SizedBox(height: 20),
                _buildRewardCard(
                  'Túi Vàng',
                  'Cơ hội nhận 100,000đ',
                  '🏆',
                  const Color(0xFFFFD700),
                  settings,
                ),
                _buildRewardCard(
                  'Túi Bạc',
                  'Cơ hội nhận 50,000đ',
                  '🥈',
                  const Color(0xFFC0C0C0),
                  settings,
                ),
                _buildRewardCard(
                  'Túi Đồng',
                  'Cơ hội nhận 10,000đ',
                  '🥉',
                  const Color(0xFFCD7F32),
                  settings,
                ),
                _buildRewardCard(
                  'Túi May Mắn',
                  'Voucher giảm giá đặc biệt',
                  '🎁',
                  const Color(0xFFDA020E),
                  settings,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLuckyCard(SettingsProvider settings) {
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
        children: [
          const Text('🧧', style: TextStyle(fontSize: 60)),
          const SizedBox(height: 16),
          Text(
            settings.isEnglish ? '🇻🇳 Try Your Luck!' : '🇻🇳 Thử Vận May!',
            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            settings.isEnglish 
              ? 'Open lucky bags and win amazing prizes'
              : 'Mở túi thần tài và nhận quà tặng hấp dẫn',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFFDA020E),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            ),
            child: Text(
              settings.isEnglish ? 'Open Lucky Bag' : 'Mở Túi Thần Tài',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardCard(String title, String description, String emoji, Color color, SettingsProvider settings) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
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
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 30)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
                Text(description, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: color, size: 20),
        ],
      ),
    );
  }
}