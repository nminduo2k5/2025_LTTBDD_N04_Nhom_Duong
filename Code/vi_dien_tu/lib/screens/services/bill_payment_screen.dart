import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vi_dien_tu/providers/settings_provider.dart';
import 'package:vi_dien_tu/services/api_service.dart';

class BillPaymentScreen extends StatefulWidget {
  const BillPaymentScreen({super.key});

  @override
  State<BillPaymentScreen> createState() =>
      _BillPaymentScreenState();
}

class _BillPaymentScreenState
    extends State<BillPaymentScreen> {
  List<Map<String, dynamic>> bills = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBills();
  }

  Future<void> _loadBills() async {
    final apiService = ApiService();
    final loadedBills =
        await apiService.getBills();
    setState(() {
      bills = loadedBills;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return Scaffold(
          backgroundColor:
              const Color(0xFFFFF8DC),
          appBar: AppBar(
            backgroundColor:
                const Color(0xFFDA020E),
            foregroundColor: Colors.white,
            title: Text(settings.isEnglish
                ? 'Bill Payment'
                : 'Thanh toán hóa đơn'),
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
          body: isLoading
              ? const Center(
                  child:
                      CircularProgressIndicator())
              : ListView.builder(
                  padding:
                      const EdgeInsets.all(16),
                  itemCount: bills.length,
                  itemBuilder: (context, index) {
                    final bill = bills[index];
                    return _buildBillCard(
                        bill, settings);
                  },
                ),
        );
      },
    );
  }

  Widget _buildBillCard(Map<String, dynamic> bill,
      SettingsProvider settings) {
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
          CircleAvatar(
            backgroundColor:
                const Color(0xFFDA020E)
                    .withOpacity(0.1),
            child: Icon(
              _getBillIcon(bill['type']),
              color: const Color(0xFFDA020E),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  bill['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${bill['amount']}đ',
                  style: const TextStyle(
                    color: Color(0xFFDA020E),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${settings.isEnglish ? 'Due:' : 'Hạn:'} ${bill['dueDate']}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  const Color(0xFFDA020E),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(8),
              ),
            ),
            child: Text(settings.isEnglish
                ? 'Pay'
                : 'Thanh toán'),
          ),
        ],
      ),
    );
  }

  IconData _getBillIcon(String type) {
    switch (type) {
      case 'electric':
        return Icons.flash_on;
      case 'water':
        return Icons.water_drop;
      case 'internet':
        return Icons.wifi;
      case 'gas':
        return Icons.local_gas_station;
      default:
        return Icons.receipt;
    }
  }
}
