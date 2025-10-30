import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vi_dien_tu/screens/authentication/register_screen.dart';
import 'package:vi_dien_tu/screens/authentication/forgot_password_screen.dart';
import 'package:vi_dien_tu/screens/home_screen.dart';
import 'package:vi_dien_tu/services/auth_service.dart';
import 'package:vi_dien_tu/providers/settings_provider.dart';
import 'package:vi_dien_tu/utils/translations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() =>
      _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController =
      TextEditingController();
  final _passwordController =
      TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true;
  String? _emailError;
  String? _passwordError;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration:
          const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0)
            .animate(
      CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack));
    _scaleAnimation =
        Tween<double>(begin: 0.8, end: 1.0)
            .animate(
      CurvedAnimation(
          parent: _animationController,
          curve: Curves.elasticOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8DC),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFDA020E), // Đỏ cờ VN
              Color(0xFFFF6B6B), // Đỏ nhạt
              Color(0xFFFFF8DC), // Cream
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
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      constraints:
                          const BoxConstraints(
                              maxWidth: 400),
                      decoration: BoxDecoration(
                        color: Colors.white
                            .withOpacity(0.95),
                        borderRadius:
                            BorderRadius.circular(
                                24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(
                                0, 10),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.all(
                                32.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize:
                                MainAxisSize.min,
                            children: [
                              _buildHeader(),
                              const SizedBox(
                                  height: 40),
                              _buildEmailField(),
                              const SizedBox(
                                  height: 20),
                              _buildPasswordField(),
                              const SizedBox(
                                  height: 16),
                              _buildForgotPassword(),
                              const SizedBox(
                                  height: 32),
                              _buildLoginButton(),
                              const SizedBox(
                                  height: 24),
                              _buildDivider(),
                              const SizedBox(
                                  height: 24),
                              _buildSocialButtons(),
                              const SizedBox(
                                  height: 32),
                              _buildRegisterLink(),
                              const SizedBox(height: 32),
                              _buildStudentInfo(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
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
                      colors: [
                        Color(0xFFDA020E),
                        Color(0xFFFF6B6B),
                      ],
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
                    Icons.account_balance_wallet,
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
              '🇻🇳 ${Translations.get('welcome_back', settings.isEnglish)}',
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
                border: Border.all(
                  color: const Color(0xFFDA020E),
                  width: 1,
                ),
              ),
              child: Text(
                'SmartWallet Việt Nam ⭐',
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFFDA020E),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
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
            borderRadius:
                BorderRadius.circular(16),
            border: Border.all(
                color: Colors.grey.shade200),
          ),
          child: TextField(
            controller: _emailController,
            keyboardType:
                TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: Translations.get(
                  'email', settings.isEnglish),
              prefixIcon: const Icon(
                  Icons.email_outlined,
                  color: Color(0xffef3c7b)),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.all(20),
              errorText: _emailError,
            ),
            onChanged: (value) {
              if (value.isEmpty) {
                setState(() {
                  _emailError = settings.isEnglish
                      ? 'Please enter email'
                      : 'Vui lòng nhập email';
                });
              } else {
                setState(() {
                  _emailError = null;
                });
              }
            },
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
            borderRadius:
                BorderRadius.circular(16),
            border: Border.all(
                color: Colors.grey.shade200),
          ),
          child: TextField(
            controller: _passwordController,
            obscureText: _obscureText,
            decoration: InputDecoration(
              labelText: Translations.get(
                  'password', settings.isEnglish),
              prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: Color(0xffef3c7b)),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: Colors.grey.shade600,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.all(20),
              errorText: _passwordError,
            ),
            onChanged: (value) {
              if (value.isEmpty) {
                setState(() {
                  _passwordError = settings
                          .isEnglish
                      ? 'Please enter password'
                      : 'Vui lòng nhập mật khẩu';
                });
              } else {
                setState(() {
                  _passwordError = null;
                });
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const ForgotPasswordScreen(),
                ),
              );
            },
            child: Text(
              Translations.get('forgot_password',
                  settings.isEnglish),
              style: const TextStyle(
                color: Color(0xffef3c7b),
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoginButton() {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xffef3c7b),
                Color(0xffff6b9d)
              ],
            ),
            borderRadius:
                BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xffef3c7b)
                    .withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(16),
              ),
            ),
            onPressed:
                _isLoading ? null : _handleLogin,
            child: _isLoading
                ? const CircularProgressIndicator(
                    color: Colors.white)
                : Text(
                    Translations.get('login',
                        settings.isEnglish),
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

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
            child: Divider(
                color: Colors.grey.shade300)),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 16),
          child: Text(
            'hoặc',
            style: TextStyle(
                color: Colors.grey.shade600),
          ),
        ),
        Expanded(
            child: Divider(
                color: Colors.grey.shade300)),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildSocialButton(
            icon: Icons.g_mobiledata,
            label: 'Google',
            color: Colors.red,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSocialButton(
            icon: Icons.facebook,
            label: 'Facebook',
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        border: Border.all(
            color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextButton(
        onPressed: () {},
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return Row(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Text(
              Translations.get('no_account',
                  settings.isEnglish),
              style: TextStyle(
                  color: Colors.grey.shade600),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const RegisterScreen(),
                  ),
                );
              },
              child: Text(
                Translations.get('register_now',
                    settings.isEnglish),
                style: const TextStyle(
                  color: Color(0xffef3c7b),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleLogin() async {
    if (_emailError == null &&
        _passwordError == null &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      try {
        await AuthService().login(
          _emailController.text,
          _passwordController.text,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const HomeScreen(),
          ),
        );
      } catch (e) {
        _showErrorDialog(context, e.toString());
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorDialog(
      BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Lỗi'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              child: const Text('OK'),
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
