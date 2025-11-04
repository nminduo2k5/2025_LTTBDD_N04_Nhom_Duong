import 'package:vi_dien_tu/models/user.dart';
import 'package:vi_dien_tu/services/database_service.dart';

class AuthService {
  static User? currentUser;

  // Mock users for demo
  static final List<User> _users = [
    User(id: '1', email: 'admin@test.com', username: 'admin', password: '123456'),
    User(id: '2', email: 'user@test.com', username: 'user', password: '123456'),
  ];

  static bool get isLoggedIn => currentUser != null;
  static String get currentUserId => currentUser?.id ?? '';
  static String get currentUserName => currentUser?.username ?? 'User';
  static String get currentUserEmail => currentUser?.email ?? '';

  Future<User> login(String email, String password) async {
    await Future.delayed(Duration(milliseconds: 500));
    
    final user = _users.firstWhere(
      (u) => u.email == email && u.password == password,
      orElse: () => throw Exception('Email hoặc mật khẩu không đúng'),
    );
    
    currentUser = user;
    await DatabaseService.saveCurrentUser(user);
    return user;
  }

  Future<User> register(String email, String password, String username) async {
    await Future.delayed(Duration(milliseconds: 500));
    
    if (_users.any((u) => u.email == email)) {
      throw Exception('Email đã được sử dụng');
    }
    
    if (_users.any((u) => u.username == username)) {
      throw Exception('Username đã được sử dụng');
    }
    
    final newUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      username: username,
      password: password,
    );
    
    _users.add(newUser);
    currentUser = newUser;
    await DatabaseService.saveCurrentUser(newUser);
    return newUser;
  }

  Future<void> getUserData() async {
    currentUser = await DatabaseService.getCurrentUser();
    if (currentUser == null) {
      throw Exception('Không tìm thấy thông tin người dùng');
    }
  }

  Future<void> forgotPassword(String email) async {
    await Future.delayed(Duration(milliseconds: 500));
    
    if (!_users.any((u) => u.email == email)) {
      throw Exception('Email không tồn tại trong hệ thống');
    }
  }

  Future<void> logout() async {
    await DatabaseService.clearCurrentUser();
    currentUser = null;
  }
}
