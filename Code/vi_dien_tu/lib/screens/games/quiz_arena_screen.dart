import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vi_dien_tu/providers/settings_provider.dart';

class QuizArenaScreen extends StatelessWidget {
  const QuizArenaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFFFF8DC),
          appBar: AppBar(
            title: Text(settings.isEnglish ? '🇻🇳 Quiz Arena Vietnam' : '🇻🇳 Đấu Trường Tri Thức VN'),
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
                _buildWelcomeCard(settings),
                const SizedBox(height: 20),
                _buildQuizCard(
                  'Lịch Sử Việt Nam',
                  'Khám phá 4000 năm lịch sử dân tộc',
                  '50 câu hỏi',
                  Icons.history_edu,
                  settings,
                ),
                _buildQuizCard(
                  'Địa Lý Việt Nam',
                  'Tìm hiểu về đất nước hình chữ S',
                  '40 câu hỏi',
                  Icons.map,
                  settings,
                ),
                _buildQuizCard(
                  'Văn Hóa Việt Nam',
                  'Khám phá văn hóa truyền thống',
                  '60 câu hỏi',
                  Icons.temple_buddhist,
                  settings,
                ),
                _buildQuizCard(
                  'Ẩm Thực Việt Nam',
                  'Hành trình khám phá ẩm thực 3 miền',
                  '30 câu hỏi',
                  Icons.restaurant,
                  settings,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWelcomeCard(SettingsProvider settings) {
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
          const Icon(Icons.emoji_events, color: Colors.white, size: 50),
          const SizedBox(height: 16),
          Text(
            settings.isEnglish ? '🇻🇳 Challenge Your Knowledge!' : '🇻🇳 Thách Thức Tri Thức!',
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            settings.isEnglish 
              ? 'Learn about Vietnam while earning rewards'
              : 'Học về Việt Nam và nhận thưởng hấp dẫn',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuizCard(String title, String description, String questions, IconData icon, SettingsProvider settings) {
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
                Text(description, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                Text(questions, style: const TextStyle(color: Color(0xFFDA020E), fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const Icon(Icons.play_arrow, color: Color(0xFFDA020E), size: 30),
        ],
      ),
    );
  }
}