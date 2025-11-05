import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vi_dien_tu/providers/settings_provider.dart';
import 'package:vi_dien_tu/services/api_service.dart';

class DataPackageScreen extends StatefulWidget {
  const DataPackageScreen({super.key});

  @override
  State<DataPackageScreen> createState() =>
      _DataPackageScreenState();
}

class _DataPackageScreenState
    extends State<DataPackageScreen> {
  List<Map<String, dynamic>> dataPackages = [];
  bool isLoading = true;
  String selectedType = 'daily';

  @override
  void initState() {
    super.initState();
    _loadDataPackages();
  }

  Future<void> _loadDataPackages() async {
    final apiService = ApiService();
    final packages =
        await apiService.getDataPackages();
    setState(() {
      dataPackages = packages;
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
                ? 'Data 4G/5G'
                : 'Data 4G/5G'),
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
              _buildTypeSelector(settings),
              Expanded(
                child: isLoading
                    ? const Center(
                        child:
                            CircularProgressIndicator())
                    : _buildPackageList(settings),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTypeSelector(
      SettingsProvider settings) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTypeOption(
                'daily',
                settings.isEnglish
                    ? 'Daily'
                    : 'Ngày',
                settings),
          ),
          Expanded(
            child: _buildTypeOption(
                'weekly',
                settings.isEnglish
                    ? 'Weekly'
                    : 'Tuần',
                settings),
          ),
          Expanded(
            child: _buildTypeOption(
                'monthly',
                settings.isEnglish
                    ? 'Monthly'
                    : 'Tháng',
                settings),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeOption(String type,
      String label, SettingsProvider settings) {
    final isSelected = selectedType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFDA020E)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : Colors.grey[600],
            fontWeight: isSelected
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildPackageList(
      SettingsProvider settings) {
    final filteredPackages = dataPackages
        .where((p) => p['type'] == selectedType)
        .toList();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
          horizontal: 16),
      itemCount: filteredPackages.length,
      itemBuilder: (context, index) {
        final package = filteredPackages[index];
        return _buildPackageCard(
            package, settings);
      },
    );
  }

  Widget _buildPackageCard(
      Map<String, dynamic> package,
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
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFDA020E)
                  .withOpacity(0.1),
              borderRadius:
                  BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.data_usage,
              color: Color(0xFFDA020E),
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  package['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  package['description'],
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${package['price']}đ',
                  style: const TextStyle(
                    color: Color(0xFFDA020E),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
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
                ? 'Buy'
                : 'Mua'),
          ),
        ],
      ),
    );
  }
}
