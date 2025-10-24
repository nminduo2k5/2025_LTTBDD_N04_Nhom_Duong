import 'package:flutter/material.dart';
import 'package:vi_dien_tu/services/auth_service.dart';

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
        title: const Text(
          'Đăng Ký',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold),
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
          Text(
            'Tạo tài khoản mới',
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
            'Điền thông tin để đăng ký',
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
          const SizedBox(height: 32),
          TextField(
            controller: _emailController,
            keyboardType:
                TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
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
              labelText: 'Username',
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
              labelText: 'Mật khẩu',
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
              labelText: 'Nhập Lại Mật khẩu',
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
                  : const Text(
                      'Đăng ký',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold),
                    ),
              onPressed: () async {
                if (_formKey.currentState
                        ?.validate() ??
                    false) {
                  if (_passwordController.text !=
                      _confirmPasswordController
                          .text) {
                    _showErrorDialog(context,
                        'Mật khẩu nhập lại không khớp');
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
          Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Text(
                'Đã có tài khoản? ',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium,
              ),
              TextButton(
                child:
                    const Text('Đăng nhập ngay'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thành công'),
          content:
              const Text('Đăng ký thành công!'),
          actions: [
            TextButton(
              child: const Text('OK'),
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
}
