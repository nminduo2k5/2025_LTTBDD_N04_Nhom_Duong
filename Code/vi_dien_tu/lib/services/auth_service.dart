import 'package:vi_dien_tu/models/user.dart';

class AuthService {
  static User? currentUser;

  // Static users data
  static final List<User> _users = [
    User(
        id: '1',
        email: 'admin@test.com',
        username: 'admin',
        password: '123456'),
    User(
        id: '2',
        email: 'user@test.com',
        username: 'user',
        password: '123456'),
  ];

  Future<User> login(
      String email, String password) async {
    await Future.delayed(Duration(
        milliseconds:
            500)); // Simulate network delay

    final user = _users.firstWhere(
      (u) =>
          u.email == email &&
          u.password == password,
      orElse: () => throw Exception(
          'Email hoặc mật khẩu không đúng'),
    );

    currentUser = user;
    return user;
  }

  Future<User> register(String email,
      String password, String username) async {
    await Future.delayed(Duration(
        milliseconds:
            500)); // Simulate network delay

    // Check if email already exists
    if (_users.any((u) => u.email == email)) {
      throw Exception('Email đã được sử dụng');
    }

    // Check if username already exists
    if (_users
        .any((u) => u.username == username)) {
      throw Exception('Username đã được sử dụng');
    }

    final newUser = User(
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(),
      email: email,
      username: username,
      password: password,
    );

    _users.add(newUser);
    return newUser;
  }

  Future<void> getUserData() async {
    await Future.delayed(
        Duration(milliseconds: 300));
    if (currentUser == null) {
      throw Exception(
          'Không tìm thấy thông tin người dùng');
    }
  }

  Future<void> forgotPassword(
      String email) async {
    await Future.delayed(
        Duration(milliseconds: 500));

    if (!_users.any((u) => u.email == email)) {
      throw Exception(
          'Email không tồn tại trong hệ thống');
    }

    // Simulate sending reset email
  }

  Future<void> logout() async {
    await Future.delayed(
        Duration(milliseconds: 300));
    currentUser = null;
  }
}
