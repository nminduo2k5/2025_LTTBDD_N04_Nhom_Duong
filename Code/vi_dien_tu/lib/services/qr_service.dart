import 'dart:convert';
import 'dart:math';

class QRService {
  // Tạo mã QR cho thanh toán
  static String generatePaymentQR({
    required String recipientId,
    required String recipientName,
    required double amount,
    String? description,
  }) {
    final qrData = {
      'type': 'payment',
      'recipientId': recipientId,
      'recipientName': recipientName,
      'amount': amount,
      'description': description ?? '',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'qrId': _generateQRId(),
    };
    
    return base64Encode(utf8.encode(jsonEncode(qrData)));
  }

  // Tạo mã QR cho chuyển tiền
  static String generateTransferQR({
    required String recipientId,
    required String recipientName,
    String? bankCode,
    String? accountNumber,
  }) {
    final qrData = {
      'type': 'transfer',
      'recipientId': recipientId,
      'recipientName': recipientName,
      'bankCode': bankCode,
      'accountNumber': accountNumber,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'qrId': _generateQRId(),
    };
    
    return base64Encode(utf8.encode(jsonEncode(qrData)));
  }

  // Giải mã QR code
  static Map<String, dynamic>? decodeQR(String qrCode) {
    try {
      final decodedBytes = base64Decode(qrCode);
      final decodedString = utf8.decode(decodedBytes);
      final qrData = jsonDecode(decodedString) as Map<String, dynamic>;
      
      // Kiểm tra tính hợp lệ của QR (ví dụ: thời gian hết hạn)
      final timestamp = qrData['timestamp'] as int?;
      if (timestamp != null) {
        final qrTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
        final now = DateTime.now();
        final difference = now.difference(qrTime).inMinutes;
        
        // QR code hết hạn sau 30 phút
        if (difference > 30) {
          throw Exception('Mã QR đã hết hạn');
        }
      }
      
      return qrData;
    } catch (e) {
      return null;
    }
  }

  // Tạo QR cho thông tin cá nhân
  static String generatePersonalQR({
    required String userId,
    required String userName,
    required String phoneNumber,
    String? email,
  }) {
    final qrData = {
      'type': 'personal',
      'userId': userId,
      'userName': userName,
      'phoneNumber': phoneNumber,
      'email': email,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'qrId': _generateQRId(),
    };
    
    return base64Encode(utf8.encode(jsonEncode(qrData)));
  }

  // Kiểm tra loại QR
  static String? getQRType(String qrCode) {
    final qrData = decodeQR(qrCode);
    return qrData?['type'] as String?;
  }

  // Tạo ID duy nhất cho QR
  static String _generateQRId() {
    final random = Random();
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(8, (index) => chars[random.nextInt(chars.length)]).join();
  }

  // Validate QR data
  static bool validateQRData(Map<String, dynamic> qrData) {
    final type = qrData['type'] as String?;
    
    switch (type) {
      case 'payment':
        return qrData.containsKey('recipientId') &&
               qrData.containsKey('recipientName') &&
               qrData.containsKey('amount');
      case 'transfer':
        return qrData.containsKey('recipientId') &&
               qrData.containsKey('recipientName');
      case 'personal':
        return qrData.containsKey('userId') &&
               qrData.containsKey('userName') &&
               qrData.containsKey('phoneNumber');
      default:
        return false;
    }
  }
}