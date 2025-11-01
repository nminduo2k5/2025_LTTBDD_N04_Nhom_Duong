import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vi_dien_tu/providers/settings_provider.dart';

class StocksScreen extends StatefulWidget {
  const StocksScreen({super.key});

  @override
  State<StocksScreen> createState() => _StocksScreenState();
}

class _StocksScreenState extends State<StocksScreen> {
  final List<Map<String, dynamic>> _stocks = [
    {
      'symbol': 'VIC',
      'name': 'Vingroup',
      'price': 45500,
      'change': 1200,
      'changePercent': 2.71,
      'volume': '2.1M',
    },
    {
      'symbol': 'VCB',
      'name': 'Vietcombank',
      'price': 89000,
      'change': -500,
      'changePercent': -0.56,
      'volume': '1.8M',
    },
    {
      'symbol': 'VHM',
      'name': 'Vinhomes',
      'price': 52000,
      'change': 800,
      'changePercent': 1.56,
      'volume': '3.2M',
    },
    {
      'symbol': 'HPG',
      'name': 'Hòa Phát Group',
      'price': 18500,
      'change': -300,
      'changePercent': -1.59,
      'volume': '4.5M',
    },
    {
      'symbol': 'FPT',
      'name': 'FPT Corporation',
      'price': 125000,
      'change': 2500,
      'changePercent': 2.04,
      'volume': '1.2M',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFFFF8DC),
          appBar: AppBar(
            title: Text(settings.isEnglish ? '🇻🇳 Vietnam Stocks' : '🇻🇳 Chứng Khoán Việt Nam'),
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
          body: Column(
            children: [
              _buildMarketOverview(settings),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _stocks.length,
                  itemBuilder: (context, index) {
                    return _buildStockCard(_stocks[index], settings);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMarketOverview(SettingsProvider settings) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFDA020E), Color(0xFFFFCD00)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.trending_up, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Text(
                settings.isEnglish ? '🇻🇳 VN-Index Today' : '🇻🇳 VN-Index Hôm Nay',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildIndexItem('1,234.56', '+12.34 (+1.01%)', Colors.green, settings.isEnglish ? 'VN-Index' : 'VN-Index'),
              _buildIndexItem('567.89', '+5.67 (+1.01%)', Colors.green, settings.isEnglish ? 'HNX-Index' : 'HNX-Index'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIndexItem(String value, String change, Color color, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          change,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 12,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildStockCard(Map<String, dynamic> stock, SettingsProvider settings) {
    final isPositive = stock['change'] > 0;
    final changeColor = isPositive ? Colors.green : Colors.red;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 2),
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
            child: Center(
              child: Text(
                stock['symbol'],
                style: const TextStyle(
                  color: Color(0xFFDA020E),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stock['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${settings.isEnglish ? 'Volume:' : 'KL:'} ${stock['volume']}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${stock['price'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                '${isPositive ? '+' : ''}${stock['change']} (${isPositive ? '+' : ''}${stock['changePercent']}%)',
                style: TextStyle(
                  color: changeColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}