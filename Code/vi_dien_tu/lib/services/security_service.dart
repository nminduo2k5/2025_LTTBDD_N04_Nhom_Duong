import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

class SecurityService {
  static const String _pinKey = 'user_pin';
  static const String _biometricKey =
      'biometric_enabled';
  static const String _sessionKey =
      'user_session';

  // Mã hóa PIN
  static String hashPin(String pin) {
    final bytes =
        utf8.encode(pin + 'salt_key_2024');
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Xác thực PIN
  static bool verifyPin(
      String inputPin, String storedHashedPin) {
    final hashedInput = hashPin(inputPin);
    return hashedInput == storedHashedPin;
  }

  // Tạo OTP
  static String generateOTP({int length = 6}) {
    final random = Random.secure();
    String otp = '';
    for (int i = 0; i < length; i++) {
      otp += random.nextInt(10).toString();
    }
    return otp;
  }

  // Tạo session token
  static String generateSessionToken() {
    final random = Random.secure();
    final bytes = List<int>.generate(
        32, (i) => random.nextInt(256));
    return base64Encode(bytes);
  }

  // Kiểm tra độ mạnh của mật khẩu
  static PasswordStrength checkPasswordStrength(
      String password) {
    int score = 0;

    // Độ dài
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;

    // Chữ hoa
    if (password.contains(RegExp(r'[A-Z]')))
      score++;

    // Chữ thường
    if (password.contains(RegExp(r'[a-z]')))
      score++;

    // Số
    if (password.contains(RegExp(r'[0-9]')))
      score++;

    // Ký tự đặc biệt
    if (password.contains(
        RegExp(r'[!@#$%^&*(),.?":{}|<>]')))
      score++;

    if (score <= 2) return PasswordStrength.weak;
    if (score <= 4)
      return PasswordStrength.medium;
    return PasswordStrength.strong;
  }

  // Mã hóa dữ liệu nhạy cảm
  static String encryptSensitiveData(
      String data) {
    // Trong thực tế, sử dụng thư viện mã hóa mạnh hơn
    final bytes = utf8.encode(data);
    final encoded = base64Encode(bytes);
    return encoded;
  }

  // Giải mã dữ liệu nhạy cảm
  static String decryptSensitiveData(
      String encryptedData) {
    try {
      final bytes = base64Decode(encryptedData);
      return utf8.decode(bytes);
    } catch (e) {
      throw Exception(
          'Không thể giải mã dữ liệu');
    }
  }

  // Kiểm tra thiết bị đáng tin cậy
  static bool isTrustedDevice(String deviceId) {
    // Logic kiểm tra thiết bị đáng tin cậy
    // Trong thực tế, sẽ kiểm tra với server
    return true;
  }

  // Tạo mã xác thực 2FA
  static String generate2FACode() {
    return generateOTP(length: 6);
  }

  // Xác thực giao dịch
  static bool verifyTransactionSignature(
    String transactionData,
    String signature,
    String publicKey,
  ) {
    // Logic xác thực chữ ký giao dịch
    // Trong thực tế, sử dụng thuật toán mã hóa bất đối xứng
    return true;
  }

  // Kiểm tra hoạt động đáng ngờ
  static SuspiciousActivity
      checkSuspiciousActivity({
    required double amount,
    required String recipientId,
    required DateTime transactionTime,
    required String location,
  }) {
    // Logic phát hiện hoạt động đáng ngờ

    // Giao dịch lớn
    if (amount > 50000000) {
      return SuspiciousActivity(
        level: SuspiciousLevel.high,
        reason: 'Giao dịch có số tiền lớn',
        requiresVerification: true,
      );
    }

    // Giao dịch vào giờ lạ
    final hour = transactionTime.hour;
    if (hour < 6 || hour > 22) {
      return SuspiciousActivity(
        level: SuspiciousLevel.medium,
        reason:
            'Giao dịch vào giờ không thông thường',
        requiresVerification: true,
      );
    }

    return SuspiciousActivity(
      level: SuspiciousLevel.low,
      reason: 'Hoạt động bình thường',
      requiresVerification: false,
    );
  }

  // Tạo backup key
  static String generateBackupKey() {
    final random = Random.secure();
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(
        16,
        (index) => chars[
            random.nextInt(chars.length)]).join();
  }
}

enum PasswordStrength { weak, medium, strong }

enum SuspiciousLevel { low, medium, high }

class SuspiciousActivity {
  final SuspiciousLevel level;
  final String reason;
  final bool requiresVerification;

  SuspiciousActivity({
    required this.level,
    required this.reason,
    required this.requiresVerification,
  });
}
