import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vi_dien_tu/providers/settings_provider.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() =>
      _QRScannerScreenState();
}

class _QRScannerScreenState
    extends State<QRScannerScreen> {
  bool isFlashOn = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            title: Text(settings.isEnglish
                ? 'QR Scanner'
                : 'Quét mã QR'),
            actions: [
              IconButton(
                icon: Icon(isFlashOn
                    ? Icons.flash_on
                    : Icons.flash_off),
                onPressed: () {
                  setState(() {
                    isFlashOn = !isFlashOn;
                  });
                },
              ),
            ],
          ),
          body: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.grey[900],
                child: Center(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt,
                        size: 100,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        settings.isEnglish
                            ? 'Camera Preview\n(Requires camera permission)'
                            : 'Xem trước camera\n(Cần quyền truy cập camera)',
                        textAlign:
                            TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          const Color(0xFFDA020E),
                      width: 3,
                    ),
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),
              ),
              Positioned(
                bottom: 100,
                left: 0,
                right: 0,
                child: Text(
                  settings.isEnglish
                      ? 'Point your camera at a QR code'
                      : 'Hướng camera vào mã QR để quét',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
