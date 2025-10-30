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
      appBar: AppBar(
        title: Consumer<SettingsProvider>(
          builder: (context, settings, child) {
            return Text(
              Translations.get('register', settings.isEnglish),
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            );
          },
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isLandscape =
                constraints.maxWidth >
                    constraints.maxHeight;
            return Center(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.all(20.0),
                child: isLandscape
                    ? Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceEvenly,
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .center,
                        children: [
                          Flexible(
                            child: _buildForm(),
                            flex: 2,
                          ),
                          const SizedBox(
                              width: 20),
                          Flexible(
                            child: _buildImage(
                                isLandscape:
                                    true),
                            flex: 1,
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          _buildImage(
                              isLandscape: false),
                          _buildForm(),
                        ],
                      ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildImage(
      {required bool isLandscape}) {
    return Image.asset(
      'assets/images/logo.png',
      height: isLandscape ? 300 : 250,
      width: isLandscape ? 300 : null,
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        crossAxisAlignment:
            CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 32),
          Consumer<SettingsProvider>(
            builder: (context, settings, child) {
              return Column(
                children: [
                  Text(
                    Translations.get('create_account', settings.isEnglish),
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    Translations.get('fill_info', settings.isEnglish),
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 32),
          Consumer<SettingsProvider>(
            builder: (context, settings, child) {
              return Column(
                children: [
                  TextField(
                    controller: _emailController,
                    keyboardType:
                        TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: Translations.get('email', settings.isEnglish),
                      prefixIcon: const Icon(
                          Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: Translations.get('username', settings.isEnglish),
                      prefixIcon: const Icon(
                          Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: Translations.get('password', settings.isEnglish),
                      prefixIcon:
                          const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller:
                        _confirmPasswordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: Translations.get('confirm_password', settings.isEnglish),
                      prefixIcon:
                          const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(
                        vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Consumer<SettingsProvider>(
                      builder: (context, settings, child) {
                        return Text(
                          Translations.get('register', settings.isEnglish),
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.bold),
                        );
                      },
                    ),
              onPressed: () async {
                if (_formKey.currentState
                        ?.validate() ??
                    false) {
                  if (_passwordController.text !=
                      _confirmPasswordController
                          .text) {
                    final settings = Provider.of<SettingsProvider>(context, listen: false);
                    _showErrorDialog(context,
                        Translations.get('passwords_not_match', settings.isEnglish));
                    return;
                  }
                  setState(() {
                    _isLoading = true;
                  });
                  try {
                    await AuthService().register(
                      _emailController.text,
                      _passwordController.text,
                      _usernameController.text,
                    );
                    _showSuccessDialog(context);
                  } catch (e) {
                    _showErrorDialog(
                        context, e.toString());
                  } finally {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                }
              },
            ),
          ),
          const SizedBox(height: 24),
          Consumer<SettingsProvider>(
            builder: (context, settings, child) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Text(
                        Translations.get('have_account', settings.isEnglish),
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium,
                      ),
                      TextButton(
                        child: Text(Translations.get('login_now', settings.isEnglish)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildStudentInfo(),
                ],
              );
            },
          ),
        ],
      ),
    );
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
