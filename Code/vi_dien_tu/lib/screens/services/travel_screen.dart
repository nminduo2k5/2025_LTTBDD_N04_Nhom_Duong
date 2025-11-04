import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vi_dien_tu/providers/settings_provider.dart';
import 'package:vi_dien_tu/services/api_service.dart';

class TravelScreen extends StatefulWidget {
  const TravelScreen({super.key});

  @override
  State<TravelScreen> createState() =>
      _TravelScreenState();
}

class _TravelScreenState
    extends State<TravelScreen> {
  List<Map<String, dynamic>> travelServices = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTravelServices();
  }

  Future<void> _loadTravelServices() async {
    final apiService = ApiService();
    final services =
        await apiService.getTravelServices();
    setState(() {
      travelServices = services;
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
                ? 'Travel'
                : 'Du lịch - Đi lại'),
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
              : GridView.builder(
                  padding:
                      const EdgeInsets.all(16),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount:
                      travelServices.length,
                  itemBuilder: (context, index) {
                    final service =
                        travelServices[index];
                    return _buildServiceCard(
                        service, settings);
                  },
                ),
        );
      },
    );
  }

  Widget _buildServiceCard(
      Map<String, dynamic> service,
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
          CircleAvatar(
            backgroundColor:
                const Color(0xFFDA020E)
                    .withOpacity(0.1),
            radius: 30,
            child: Icon(
              _getServiceIcon(service['type']),
              color: const Color(0xFFDA020E),
              size: 30,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            service['name'],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            service['description'],
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getServiceIcon(String type) {
    switch (type) {
      case 'flight':
        return Icons.flight;
      case 'hotel':
        return Icons.hotel;
      case 'bus':
        return Icons.directions_bus;
      case 'train':
        return Icons.train;
      case 'car':
        return Icons.car_rental;
      case 'tour':
        return Icons.tour;
      default:
        return Icons.travel_explore;
    }
  }
}
