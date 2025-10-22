class User {
  final String id;
  final String email;
  final String username;
  final String password;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? 'Unknown Email',
      username: json['username'] ?? 'Unknown Username',
      password: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
    };
  }
}