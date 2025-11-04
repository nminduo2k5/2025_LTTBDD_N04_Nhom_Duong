import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vi_dien_tu/services/auth_service.dart';
import 'package:vi_dien_tu/providers/settings_provider.dart';
import 'package:vi_dien_tu/utils/translations.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState
    extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController =
      TextEditingController();
  final _passwordController =
      TextEditingController();
  final _confirmPasswordController =
      TextEditingController();
  final _usernameController =
      TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8DC),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFDA020E),
              Color(0xFFFF6B6B),
              Color(0xFFFFF8DC),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: _buildForm(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }



  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          const SizedBox(height: 40),
          const SizedBox(height: 32),
          _buildEmailField(),
          const SizedBox(height: 16),
          _buildUsernameField(),
          const SizedBox(height: 16),
          _buildPasswordField(),
          const SizedBox(height: 16),
          _buildConfirmPasswordField(),
          const SizedBox(height: 24),
          _buildRegisterButton(),
          const SizedBox(height: 24),
          _buildLoginLink(),
          const SizedBox(height: 32),
          _buildStudentInfo(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFDA020E), Color(0xFFFF6B6B)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFDA020E).withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.person_add,
                    color: Colors.white,
                    size: 45,
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFCD00),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.star,
                      color: Color(0xFFDA020E),
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              '🇻🇳 ${Translations.get('create_account', settings.isEnglish)}',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFFDA020E),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFCD00).withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFDA020E), width: 1),
              ),
              child: const Text(
                'SmartWallet Việt Nam ⭐',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFDA020E),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmailField() {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: Translations.get('email', settings.isEnglish),
              prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFFDA020E)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(20),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUsernameField() {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: Translations.get('username', settings.isEnglish),
              prefixIcon: const Icon(Icons.person_outline, color: Color(0xFFDA020E)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(20),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPasswordField() {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: TextField(
            controller: _passwordController,
            obscureText: _obscureText,
            decoration: InputDecoration(
              labelText: Translations.get('password', settings.isEnglish),
              prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFFDA020E)),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey.shade600,
                ),
                onPressed: () => setState(() => _obscureText = !_obscureText),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(20),
            ),
          ),
        );
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: TextField(
            controller: _confirmPasswordController,
            obscureText: _obscureText,
            decoration: InputDecoration(
              labelText: Translations.get('confirm_password', settings.isEnglish),
              prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFFDA020E)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(20),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRegisterButton() {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFDA020E), Color(0xFFFF6B6B)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFDA020E).withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: _isLoading ? null : _handleRegister,
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    Translations.get('register', settings.isEnglish),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildLoginLink() {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Translations.get('have_account', settings.isEnglish),
              style: TextStyle(color: Colors.grey.shade600),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                Translations.get('login_now', settings.isEnglish),
                style: const TextStyle(
                  color: Color(0xFFDA020E),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleRegister() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      final settings = Provider.of<SettingsProvider>(context, listen: false);
      _showErrorDialog(context, Translations.get('passwords_not_match', settings.isEnglish));
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      await AuthService().register(
        _emailController.text,
        _passwordController.text,
        _usernameController.text,
      );
      _showSuccessDialog(context);
    } catch (e) {
      _showErrorDialog(context, e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSuccessDialog(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(Translations.get('success', settings.isEnglish)),
          content: Text(settings.isEnglish ? 'Registration successful!' : 'Đăng ký thành công!'),
          actions: [
            TextButton(
              child: Text(Translations.get('ok', settings.isEnglish)),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(
      BuildContext context, String errorMessage) {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(Translations.get('error', settings.isEnglish)),
          content: Text(errorMessage),
          actions: [
            TextButton(
              child: Text(Translations.get('ok', settings.isEnglish)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildStudentInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFDA020E), Color(0xFFFFCD00)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
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
              const Icon(
                Icons.school,
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(width: 8),
              const Text(
                '👨🎓 Thông Tin Sinh Viên',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow('Họ và tên:', 'Nguyễn Minh Dương'),
          _buildInfoRow('MSSV:', '23010441'),
          _buildInfoRow('Lớp:', 'LTTBDD-1-1-25(N04)'),
          _buildInfoRow('Nhóm:', '2025_LTTBDD_N04_Nhom_Duong'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
