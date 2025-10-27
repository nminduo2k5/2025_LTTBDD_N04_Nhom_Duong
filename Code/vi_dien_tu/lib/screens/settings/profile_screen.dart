import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vi_dien_tu/providers/user_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {
  final _usernameController =
      TextEditingController();
  final _emailController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userProvider =
          Provider.of<UserProvider>(context,
              listen: false);
      await userProvider.getUserData();
      final userData = userProvider.currentUser;
      if (userData != null) {
        _usernameController.text =
            userData.username;
        _emailController.text = userData.email;
      } else {
        _showErrorDialog(
            'Không tìm thấy thông tin người dùng.');
      }
    } catch (e) {
      _showErrorDialog(
          'Lỗi tải thông tin người dùng: $e');
    } finally {
      setState(() {});
    }
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Lỗi'),
          content: Text(errorMessage),
          actions: <Widget>[
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin cá nhân'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context)
                        .colorScheme
                        .primary,
                    Theme.of(context)
                        .colorScheme
                        .primaryContainer,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    const BorderRadius.only(
                  bottomLeft:
                      Radius.circular(30.0),
                  bottomRight:
                      Radius.circular(30.0),
                ),
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: Icon(Icons.person,
                    size: 50,
                    color: Theme.of(context)
                        .colorScheme
                        .primary),
              ),
            ),
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.all(16.0),
                children: [
                  _buildInfoField(
                      'Tên người dùng',
                      _usernameController),
                  const SizedBox(height: 20),
                  _buildInfoField(
                      'Email', _emailController),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoField(String label,
      TextEditingController controller) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(10.0),
            ),
            filled: true,
            fillColor: Colors.grey[100],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
