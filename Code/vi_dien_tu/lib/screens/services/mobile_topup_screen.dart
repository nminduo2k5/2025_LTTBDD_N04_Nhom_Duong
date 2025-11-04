import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vi_dien_tu/providers/settings_provider.dart';
import 'package:vi_dien_tu/services/api_service.dart';

class MobileTopupScreen extends StatefulWidget {
  const MobileTopupScreen({super.key});

  @override
  State<MobileTopupScreen> createState() =>
      _MobileTopupScreenState();
}

class _MobileTopupScreenState
    extends State<MobileTopupScreen> {
  final _phoneController =
      TextEditingController();
  List<Map<String, dynamic>> topupPackages = [];
  String selectedProvider = 'viettel';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTopupPackages();
  }

  Future<void> _loadTopupPackages() async {
    final apiService = ApiService();
    final packages =
        await apiService.getTopupPackages();
    setState(() {
      topupPackages = packages;
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
                ? 'Mobile Top-up'
                : 'Nạp tiền điện thoại'),
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
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildPhoneInput(settings),
                const SizedBox(height: 16),
                _buildProviderSelector(settings),
                const SizedBox(height: 16),
                Expanded(
                  child: isLoading
                      ? const Center(
                          child:
                              CircularProgressIndicator())
                      : _buildPackageGrid(
                          settings),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPhoneInput(
      SettingsProvider settings) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _phoneController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          labelText: settings.isEnglish
              ? 'Phone Number'
              : 'Số điện thoại',
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(8),
          ),
          prefixIcon: const Icon(Icons.phone),
        ),
      ),
    );
  }

  Widget _buildProviderSelector(
      SettingsProvider settings) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceAround,
        children: [
          _buildProviderOption(
              'viettel', 'Viettel', Colors.green),
          _buildProviderOption('vinaphone',
              'Vinaphone', Colors.blue),
          _buildProviderOption('mobifone',
              'Mobifone', Colors.orange),
        ],
      ),
    );
  }

  Widget _buildProviderOption(
      String provider, String name, Color color) {
    final isSelected =
        selectedProvider == provider;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedProvider = provider;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? color
                : Colors.grey[300]!,
          ),
        ),
        child: Text(
          name,
          style: TextStyle(
            color: isSelected
                ? color
                : Colors.grey[600],
            fontWeight: isSelected
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildPackageGrid(
      SettingsProvider settings) {
    return GridView.builder(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: topupPackages.length,
      itemBuilder: (context, index) {
        final package = topupPackages[index];
        return _buildPackageCard(
            package, settings);
      },
    );
  }

  Widget _buildPackageCard(
      Map<String, dynamic> package,
      SettingsProvider settings) {
    return Container(
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
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Text(
            '${package['amount']}đ',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFDA020E),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            package['description'],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
