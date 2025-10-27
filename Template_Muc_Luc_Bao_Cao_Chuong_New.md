# TEMPLATE MỤC LỤC BÁO CÁO BÀI TẬP MÔN HỌC
## Lập Trình Thiết Bị Di Động - Ứng Dụng SmartWallet

---

## **MỤC LỤC**

**THÔNG TIN CHUNG**
- Họ và tên: Nguyễn Minh Dương
- Mã số sinh viên: 23010441
- Lớp: Lập trình cho thiết bị di động-1-1-25(N04)
- Nhóm: 2025_LTTBDD_N04_Nhom_Duong
- Tên đề tài: Ứng dụng di động Ví điện tử SmartWallet

---

## **CHƯƠNG 1: TỔNG QUAN VỀ ĐỀ TÀI**

### 1.1 Giới thiệu đề tài
- Tên ứng dụng: SmartWallet - Ví điện tử thông minh
- Mô tả tổng quan về ứng dụng
- Lý do chọn đề tài
- Ý nghĩa thực tiễn của ứng dụng

### 1.2 Mục tiêu của đề tài
- Mục tiêu chính: Phát triển ứng dụng ví điện tử hoàn chỉnh
- Mục tiêu cụ thể:
  - Quản lý nhiều ví điện tử
  - Theo dõi giao dịch và chi tiêu
  - Thống kê tài chính cá nhân
  - Giao diện thân thiện, hiện đại

### 1.3 Đối tượng sử dụng
- Người dùng cá nhân quản lý tài chính
- Độ tuổi: 18-50
- Có smartphone và hiểu biết cơ bản về công nghệ

### 1.4 Phạm vi nghiên cứu
- Phát triển ứng dụng mobile với Flutter
- Tập trung vào UI/UX và trải nghiệm người dùng
- Sử dụng dữ liệu mẫu (mock data) cho demo
- Hỗ trợ nền tảng Android và iOS

---

## **CHƯƠNG 2: PHÂN TÍCH YÊU CẦU HỆ THỐNG**

### 2.1 Phân tích yêu cầu chức năng
#### 2.1.1 Xác thực và bảo mật
- Đăng nhập/đăng ký tài khoản
- Quên mật khẩu
- Bảo mật thông tin người dùng

#### 2.1.2 Quản lý ví điện tử
- Tạo ví mới với các loại: tiền mặt, ngân hàng, thẻ tín dụng
- Xem danh sách ví
- Chỉnh sửa thông tin ví
- Xóa ví (có xác nhận)
- Đặt ví mặc định

#### 2.1.3 Quản lý giao dịch
- Chuyển tiền giữa các ví
- Xem lịch sử giao dịch
- Tìm kiếm giao dịch theo tiêu chí
- Chi tiết giao dịch

#### 2.1.4 Quản lý chi tiêu
- Thêm khoản chi tiêu/thu nhập
- Phân loại theo danh mục
- Chỉnh sửa/xóa chi tiêu
- Ghi chú và mô tả

#### 2.1.5 Thống kê và báo cáo
- Biểu đồ chi tiêu theo danh mục
- Xu hướng chi tiêu theo thời gian
- So sánh thu chi theo tháng/quý
- Báo cáo tổng hợp

#### 2.1.6 Lịch tài chính
- Xem chi tiêu theo ngày/tháng
- Đánh dấu ngày quan trọng
- Nhắc nhở thanh toán

### 2.2 Phân tích yêu cầu phi chức năng
#### 2.2.1 Hiệu năng
- Thời gian khởi động < 3 giây
- Thời gian phản hồi < 1 giây
- Mượt mà khi cuộn danh sách

#### 2.2.2 Giao diện người dùng
- Tuân thủ Material Design 3
- Responsive trên nhiều kích thước màn hình
- Hỗ trợ chế độ sáng/tối
- Animations mượt mà

#### 2.2.3 Bảo mật
- Mã hóa dữ liệu nhạy cảm
- Xác thực an toàn
- Bảo vệ khỏi các lỗ hổng phổ biến

#### 2.2.4 Tương thích
- Android 6.0+ (API level 23+)
- iOS 11.0+
- Hỗ trợ đa ngôn ngữ (Tiếng Việt, English)

---

## **CHƯƠNG 3: THIẾT KẾ HỆ THỐNG**

### 3.1 Tổng quan kiến trúc hệ thống
#### 3.1.1 Sơ đồ Actor (Actor Diagram)
```
                    ┌─────────────────────────────┐
                    │         Actors              │
                    ├─────────────────────────────┤
                    │                             │
                    │  ┌─────────────────────┐    │
                    │  │       User          │    │
                    │  │   (Người dùng)      │    │
                    │  │                     │    │
                    │  │ - Quản lý ví        │    │
                    │  │ - Thực hiện giao dịch│   │
                    │  │ - Xem thống kê      │    │
                    │  │ - Quản lý chi tiêu  │    │
                    │  └─────────────────────┘    │
                    │                             │
                    │  ┌─────────────────────┐    │
                    │  │      System         │    │
                    │  │   (Hệ thống)        │    │
                    │  │                     │    │
                    │  │ - Xử lý dữ liệu     │    │
                    │  │ - Tính toán thống kê│    │
                    │  │ - Lưu trữ thông tin │    │
                    │  └─────────────────────┘    │
                    └─────────────────────────────┘
```

#### 3.1.2 Sơ đồ Package (Package Diagram)
```
┌─────────────────────────────────────────────────────────────────────┐
│                           SmartWallet App                          │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐     │
│  │   Presentation  │  │   Business      │  │      Data       │     │
│  │     Layer       │  │     Logic       │  │     Layer       │     │
│  │                 │  │     Layer       │  │                 │     │
│  │ ┌─────────────┐ │  │ ┌─────────────┐ │  │ ┌─────────────┐ │     │
│  │ │   Screens   │ │  │ │  Providers  │ │  │ │   Models    │ │     │
│  │ │             │ │  │ │             │ │  │ │             │ │     │
│  │ │ - Login     │ │  │ │ - Wallet    │ │  │ │ - User      │ │     │
│  │ │ - Home      │ │  │ │ - Expense   │ │  │ │ - Wallet    │ │     │
│  │ │ - Wallet    │ │  │ │ - Auth      │ │  │ │ - Transaction│ │    │
│  │ │ - Transfer  │ │  │ │             │ │  │ │ - Expense   │ │     │
│  │ └─────────────┘ │  │ └─────────────┘ │  │ └─────────────┘ │     │
│  │                 │  │                 │  │                 │     │
│  │ ┌─────────────┐ │  │ ┌─────────────┐ │  │ ┌─────────────┐ │     │
│  │ │   Widgets   │ │  │ │  Services   │ │  │ │   Storage   │ │     │
│  │ │             │ │  │ │             │ │  │ │             │ │     │
│  │ │ - Cards     │ │  │ │ - Auth      │ │  │ │ - Local DB  │ │     │
│  │ │ - Forms     │ │  │ │ - Wallet    │ │  │ │ - Shared    │ │     │
│  │ │ - Charts    │ │  │ │ - Transaction│ │  │ │   Prefs     │ │     │
│  │ └─────────────┘ │  │ └─────────────┘ │  │ └─────────────┘ │     │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘     │
└─────────────────────────────────────────────────────────────────────┘
```

### 3.2 Chức năng Xác thực và Bảo mật

**Mô tả chức năng:**
Chức năng xác thực là cổng vào chính của ứng dụng SmartWallet, đảm bảo chỉ những người dùng hợp lệ mới có thể truy cập vào dữ liệu tài chính cá nhân. Hệ thống hỗ trợ đăng nhập bằng email/mật khẩu, đăng ký tài khoản mới, khôi phục mật khẩu và quản lý phiên đăng nhập an toàn. Tất cả thông tin nhạy cảm đều được mã hóa và xử lý theo tiêu chuẩn bảo mật cao.

**Code Implementation:**

*User Model (models/user.dart):*
```dart
class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  bool validateEmail() {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool validatePassword(String password) {
    return password.length >= 6;
  }
}
```

*AuthProvider (providers/auth_provider.dart):*
```dart
class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  User? _currentUser;
  final AuthService _authService = AuthService();

  bool get isLoggedIn => _isLoggedIn;
  User? get currentUser => _currentUser;

  Future<bool> login(String email, String password) async {
    try {
      final user = await _authService.authenticate(email, password);
      if (user != null) {
        _currentUser = user;
        _isLoggedIn = true;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}
```

#### 3.2.1 Sơ đồ Use Case - Authentication
```
                    ┌─────────────────────────────────┐
                    │      Authentication System     │
                    ├─────────────────────────────────┤
                    │                                 │
                    │  ┌─────────────┐               │
                    │  │ Đăng nhập   │◄──────────────┤
                    │  └─────────────┘               │
                    │  ┌─────────────┐               │
                    │  │ Đăng ký     │◄──────────────┤
                    │  └─────────────┘               │     ┌─────────┐
                    │  ┌─────────────┐               │◄────┤  User   │
                    │  │ Quên mật    │◄──────────────┤     └─────────┘
                    │  │ khẩu        │               │
                    │  └─────────────┘               │
                    │  ┌─────────────┐               │
                    │  │ Đăng xuất   │◄──────────────┤
                    │  └─────────────┘               │
                    └─────────────────────────────────┘
```

#### 3.2.2 Sơ đồ Class - Authentication
```
┌─────────────────────┐       ┌─────────────────────┐
│        User         │       │    AuthProvider     │
├─────────────────────┤       ├─────────────────────┤
│ - id: String        │   ┌───┤ - _isLoggedIn: bool │
│ - email: String     │   │   │ - _currentUser: User│
│ - password: String  │   │   │ - _authService      │
│ - name: String      │   │   ├─────────────────────┤
│ - phone: String     │   │   │ + login()           │
│ - createdAt: DateTime│  │   │ + register()        │
├─────────────────────┤   │   │ + logout()          │
│ + fromJson()        │   │   │ + forgotPassword()  │
│ + toJson()          │   │   │ + isAuthenticated() │
│ + validateEmail()   │   │   └─────────────────────┘
│ + validatePassword()│   │              │
└─────────────────────┘   │              │ uses
           │               │              ▼
           │ 1           * │   ┌─────────────────────┐
           ▼               └───┤    AuthService      │
┌─────────────────────┐       ├─────────────────────┤
│     Session         │       │ + authenticate()    │
├─────────────────────┤       │ + createAccount()   │
│ - token: String     │       │ + resetPassword()   │
│ - expiresAt: DateTime│      │ + validateToken()   │
│ - userId: String    │       │ + encryptPassword() │
├─────────────────────┤       └─────────────────────┘
│ + isValid()         │
│ + refresh()         │
└─────────────────────┘
```

#### 3.2.3 Sơ đồ Sequence - Đăng nhập
```
    User      LoginScreen     AuthProvider     AuthService     Database
     │             │               │              │             │
     │── password()──►│               │              │             │
     │       │               │              │             │
     │             │──validate──────►│              │             │
     │             │   input()       │              │             │
     │             │               │──login()─────►│             │
     │             │               │              │──query()──────►│
     │             │               │              │        │
     │             │               │              │◄─result()────│
     │             │               │◄─success()/────│             │
     │             │               │   error()      │             │
     │             │◄─update───────│              │             │
     │             │   state()       │              │             │
     │◄─navigate────│               │              │             │
     │   to Home()    │               │              │             │
```

#### 3.2.4 Sơ đồ State - Authentication
```
    ┌─────────────┐
    │ Chưa đăng   │
    │ nhập        │
    └──────┬──────┘
           │ login()
    ┌──────▼──────┐
    │ Đang xác    │
    │ thực        │
    └──────┬──────┘
           │
    ┌──────▼──────┐
 ┌──┤ Đã đăng     │
 │  │ nhập        │
 │  └──────┬──────┘
 │         │ logout()
 │  ┌──────▼──────┐
 │  │ Đang đăng   │
 │  │ xuất        │
 │  └──────┬──────┘
 │         │
 └─────────┘
```

### 3.3 Chức năng Quản lý Ví điện tử

**Mô tả chức năng:**
Quản lý ví là tính năng cốt lõi của SmartWallet, cho phép người dùng tạo và quản lý nhiều ví điện tử khác nhau như tiền mặt, ngân hàng, thẻ tín dụng. Mỗi ví có thể tùy chỉnh màu sắc, biểu tượng và thông tin chi tiết. Hệ thống tự động tính toán tổng số dư và cung cấp giao diện trực quan để theo dõi tài sản.

**Code Implementation:**

*Wallet Model (models/wallet.dart):*
```dart
class Wallet {
  final String id;
  final String name;
  final String type;
  final double balance;
  final String currency;
  final String? bankName;
  final bool isDefault;
  final String color;
  final String icon;

  Wallet({
    required this.id,
    required this.name,
    required this.type,
    required this.balance,
    this.currency = 'VND',
    this.bankName,
    this.isDefault = false,
    this.color = '#2196F3',
    this.icon = 'wallet',
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? 'cash',
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] ?? 'VND',
      bankName: json['bankName'],
      isDefault: json['isDefault'] ?? false,
      color: json['color'] ?? '#2196F3',
      icon: json['icon'] ?? 'wallet',
    );
  }

  Wallet copyWith({double? balance}) {
    return Wallet(
      id: id,
      name: name,
      type: type,
      balance: balance ?? this.balance,
      currency: currency,
      bankName: bankName,
      isDefault: isDefault,
      color: color,
      icon: icon,
    );
  }
}
```

*WalletProvider (providers/wallet_provider.dart):*
```dart
class WalletProvider with ChangeNotifier {
  final WalletService _walletService = WalletService();
  List<Wallet> _wallets = [];
  Wallet? _selectedWallet;

  List<Wallet> get wallets => _wallets;
  double get totalBalance => _wallets.fold(0.0, (sum, wallet) => sum + wallet.balance);

  Future<void> fetchWallets() async {
    try {
      _wallets = await _walletService.getAllWallets();
      if (_selectedWallet == null && _wallets.isNotEmpty) {
        _selectedWallet = _wallets.first;
      }
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to fetch wallets: $e');
    }
  }

  Future<void> addWallet(Wallet wallet) async {
    try {
      final newWallet = await _walletService.addWallet(wallet);
      _wallets.add(newWallet);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to add wallet: $e');
    }
  }
}
```

#### 3.3.1 Sơ đồ Use Case - Wallet Management
```
                    ┌─────────────────────────────────┐
                    │      Wallet Management          │
                    ├─────────────────────────────────┤
                    │                                 │
                    │  ┌─────────────┐               │
                    │  │ Tạo ví mới  │◄──────────────┤
                    │  └─────────────┘               │
                    │  ┌─────────────┐               │
                    │  │ Xem danh    │◄──────────────┤
                    │  │ sách ví     │               │     ┌─────────┐
                    │  └─────────────┘               │◄────┤  User   │
                    │  ┌─────────────┐               │     └─────────┘
                    │  │ Chỉnh sửa   │◄──────────────┤
                    │  │ ví          │               │
                    │  └─────────────┘               │
                    │  ┌─────────────┐               │
                    │  │ Xóa ví      │◄──────────────┤
                    │  └─────────────┘               │
                    │  ┌─────────────┐               │
                    │  │ Đặt ví      │◄──────────────┤
                    │  │ mặc định    │               │
                    │  └─────────────┘               │
                    └─────────────────────────────────┘
```

#### 3.3.2 Sơ đồ Class - Wallet Management
```
┌─────────────────────┐       ┌─────────────────────┐
│       Wallet        │       │   WalletProvider    │
├─────────────────────┤       ├─────────────────────┤
│ - id: String        │   ┌───┤ - _wallets: List    │
│ - name: String      │   │   │ - _selectedWallet   │
│ - type: String      │   │   │ - _walletService    │
│ - balance: double   │   │   ├─────────────────────┤
│ - currency: String  │   │   │ + fetchWallets()    │
│ - bankName: String? │   │   │ + addWallet()       │
│ - accountNumber     │   │   │ + updateWallet()    │
│ - isDefault: bool   │   │   │ + deleteWallet()    │
│ - color: String     │   │   │ + selectWallet()    │
│ - icon: String      │   │   │ + getTotalBalance() │
├─────────────────────┤   │   └─────────────────────┘
│ + fromJson()        │   │              │
│ + toJson()          │   │              │ uses
│ + copyWith()        │   │              ▼
│ + validate()        │   │   ┌─────────────────────┐
└─────────────────────┘   └───┤   WalletService     │
           │                   ├─────────────────────┤
           │ 1               * │ + getAllWallets()   │
           ▼                   │ + createWallet()    │
┌─────────────────────┐       │ + updateWallet()    │
│    Transaction      │       │ + deleteWallet()    │
├─────────────────────┤       │ + getWalletById()   │
│ - id: String        │       │ + validateWallet()  │
│ - fromWalletId      │       └─────────────────────┘
│ - toWalletId        │
│ - amount: double    │
│ - type: String      │
│ - createdAt: DateTime│
│ - status: String    │
├─────────────────────┤
│ + fromJson()        │
│ + toJson()          │
└─────────────────────┘
```

#### 3.3.3 Sơ đồ Sequence - Tạo ví mới
```
  User    WalletScreen  WalletProvider  WalletService  ValidationService  Database
   │           │              │              │               │             │
   │──create()─────►│              │              │               │             │
   │   │              │              │               │             │
   │           │──show()───►│              │               │             │
   │           │    form      │              │               │             │
   │──input()─────►│              │              │               │             │
   │ information  │              │              │               │             │
   │           │──validate────►│              │               │             │
   │           │   input()      │              │               │             │
   │           │              │──validate────►│               │             │
   │           │              │   wallet()     │               │             │
   │           │              │              │──check────────►│             │
   │           │              │              │   rules()      │             │
   │           │              │              │◄─valid/───────│             │
   │           │              │              │   error      │             │
   │           │              │◄─result()──────│               │             │
   │           │              │──create()──────►│               │             │
   │           │              │   wallet     │               │             │
   │           │              │              │──save()─────────►│             │
   │           │              │              │              │──insert()─────►│
   │           │              │              │              │             │
   │           │              │              │              │◄─confirm()────│
   │           │              │              │◄─success()─────│             │
   │           │              │◄─wallet()──────│               │             │
   │           │◄─update()──────│              │               │             │
   │           │   UI         │              │               │             │
   │◄─result()─│              │              │               │             │
   │  success│              │              │               │             │
```

#### 3.3.4 Sơ đồ State - Wallet Lifecycle
```
    ┌─────────────┐
    │   Draft     │
    │ (Nháp)      │
    └──────┬──────┘
           │ validate()
    ┌──────▼──────┐
    │  Creating   │
    │ (Đang tạo)  │
    └──────┬──────┘
           │ save()
    ┌──────▼──────┐
 ┌──┤   Active    │──┐
 │  │ (Hoạt động) │  │
 │  └──────┬──────┘  │
 │         │         │ edit()
 │         │ suspend()│
 │  ┌──────▼──────┐  │
 │  │ Suspended   │  │
 │  │(Tạm dừng)   │  │
 │  └──────┬──────┘  │
 │         │         │
 │         │ activate()│
 │         └─────────┘
 │         │ delete()
 │  ┌──────▼──────┐
 │  │  Deleting   │
 │  │ (Đang xóa)  │
 │  └──────┬──────┘
 │         │
 │  ┌──────▼──────┐
 └─►│  Deleted    │
    │ (Đã xóa)    │
    └─────────────┘
```

### 3.4 Chức năng Chuyển tiền và Giao dịch

**Mô tả chức năng:**
Chức năng chuyển tiền cho phép người dùng thực hiện các giao dịch giữa các ví khác nhau một cách an toàn và nhanh chóng. Hệ thống kiểm tra số dư, xác thực giao dịch và cập nhật số dư tự động. Mỗi giao dịch đều được ghi lại chi tiết và có thể theo dõi trạng thái thời gian thực.

**Code Implementation:**

*Transaction Model (models/transaction.dart):*
```dart
class Transaction {
  final String id;
  final String type;
  final double amount;
  final String fromWalletId;
  final String? toWalletId;
  final String description;
  final DateTime createdAt;
  final String status;
  final double? fee;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.fromWalletId,
    this.toWalletId,
    required this.description,
    required this.createdAt,
    this.status = 'pending',
    this.fee,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      fromWalletId: json['fromWalletId'] ?? '',
      toWalletId: json['toWalletId'],
      description: json['description'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      status: json['status'] ?? 'pending',
      fee: (json['fee'] as num?)?.toDouble(),
    );
  }
}
```

*TransactionService (services/transaction_service.dart):*
```dart
class TransactionService {
  Future<bool> processTransfer(String fromWalletId, String toWalletId, double amount) async {
    try {
      // Validate balance
      final fromWallet = await WalletService().getWalletById(fromWalletId);
      if (fromWallet.balance < amount) {
        throw Exception('Insufficient balance');
      }

      // Create transaction record
      final transaction = Transaction(
        id: const Uuid().v4(),
        type: 'transfer',
        amount: amount,
        fromWalletId: fromWalletId,
        toWalletId: toWalletId,
        description: 'Transfer between wallets',
        createdAt: DateTime.now(),
        status: 'completed',
      );

      // Update wallet balances
      await _updateWalletBalance(fromWalletId, -amount);
      await _updateWalletBalance(toWalletId, amount);
      
      return true;
    } catch (e) {
      throw Exception('Transfer failed: $e');
    }
  }

  Future<void> _updateWalletBalance(String walletId, double amount) async {
    // Implementation for updating wallet balance
  }
}
```

#### 3.4.1 Sơ đồ Lớp - Chức năng Chuyển tiền

**Sơ đồ Lớp Tổng Quan:**
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           TRANSACTION MODEL                                 │
├─────────────────────────────────────────────────────────────────────────────┤
│ Transaction                                                                 │
├─────────────────────────────────────────────────────────────────────────────┤
│ - id: String                                                               │
│ - type: String (transfer, deposit, withdrawal)                             │
│ - amount: double                                                           │
│ - fromWalletId: String                                                     │
│ - toWalletId: String?                                                      │
│ - description: String                                                      │
│ - createdAt: DateTime                                                      │
│ - status: String (pending, completed, failed, cancelled)                  │
│ - fee: double?                                                             │
├─────────────────────────────────────────────────────────────────────────────┤
│ + fromJson(Map<String, dynamic>) : Transaction                            │
│ + toJson() : Map<String, dynamic>                                         │
│ + validate() : bool                                                       │
│ + calculateFee() : double                                                 │
│ + isCompleted() : bool                                                    │
│ + canCancel() : bool                                                      │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    │ uses
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                        TRANSACTION SERVICE                                  │
├─────────────────────────────────────────────────────────────────────────────┤
│ TransactionService                                                          │
├─────────────────────────────────────────────────────────────────────────────┤
│ - _walletService: WalletService                                            │
│ - _validationService: ValidationService                                    │
│ - _securityService: SecurityService                                        │
├─────────────────────────────────────────────────────────────────────────────┤
│ + processTransfer(TransferRequest) : Future<Transaction>                   │
│ + validateTransfer(TransferRequest) : Future<bool>                         │
│ + getTransactionHistory(String) : Future<List<Transaction>>                │
│ + cancelTransaction(String) : Future<bool>                                 │
│ + updateWalletBalances(Transaction) : Future<void>                         │
│ + saveTransaction(Transaction) : Future<void>                              │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    │ uses
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                       TRANSACTION PROVIDER                                 │
├─────────────────────────────────────────────────────────────────────────────┤
│ TransactionProvider                                                         │
├─────────────────────────────────────────────────────────────────────────────┤
│ - _transactions: List<Transaction>                                         │
│ - _isLoading: bool                                                         │
│ - _service: TransactionService                                             │
├─────────────────────────────────────────────────────────────────────────────┤
│ + processTransfer(TransferRequest) : Future<bool>                          │
│ + getTransactionHistory() : Future<void>                                   │
│ + cancelTransaction(String) : Future<bool>                                 │
│ + notifyListeners() : void                                                 │
└─────────────────────────────────────────────────────────────────────────────┘
```

#### 3.4.2 Sơ đồ Trình Tự - Quy trình Chuyển tiền

**Sơ đồ Sequence Chuyển tiền Hoàn chỉnh:**
```
User    TransferScreen  TransactionProvider  TransactionService  WalletService  Database
 │           │                │                 │               │            │
 │──open────►│                │                 │               │            │
 │ transfer   │                │                 │               │            │
 │ screen     │                │                 │               │            │
 │           │──get──────────►│                 │               │            │
 │           │  wallets()      │                 │               │            │
 │           │                │──get────────────►│               │            │
 │           │                │  wallets()      │               │            │
 │           │                │                 │──query────────►│            │
 │           │                │                 │               │──select────►│
 │           │                │                 │               │◄─wallets───│
 │           │                │                 │◄─wallets──────│            │
 │           │                │◄─wallets────────│               │            │
 │           │◄─update────────│                 │               │            │
 │           │  UI            │                 │               │            │
 │──select──►│                │                 │               │            │
 │ wallets    │                │                 │               │            │
 │──input───►│                │                 │               │            │
 │ amount     │                │                 │               │            │
 │──confirm─►│                │                 │               │            │
 │ transfer   │                │                 │               │            │
 │           │──process───────►│                 │               │            │
 │           │  transfer()     │                 │               │            │
 │           │                │──validate───────►│               │            │
 │           │                │  transfer()     │               │            │
 │           │                │                 │──check────────►│            │
 │           │                │                 │  balance()    │            │
 │           │                │                 │◄─valid────────│            │
 │           │                │◄─validated──────│               │            │
 │           │                │──execute────────►│               │            │
 │           │                │  transfer()     │               │            │
 │           │                │                 │──update───────►│            │
 │           │                │                 │  balances()   │            │
 │           │                │                 │               │──update────►│
 │           │                │                 │               │◄─success───│
 │           │                │                 │◄─completed────│            │
 │           │                │◄─success────────│               │            │
 │           │◄─completed─────│                 │               │            │
 │◄─success──│                │                 │               │            │
```

#### 3.4.3 Sơ đồ State - Transaction Lifecycle
```
    ┌─────────────┐
    │  Initiated  │
    │ (Khởi tạo)  │
    └──────┬──────┘
           │ validate()
    ┌──────▼──────┐
    │ Validating  │
    │(Đang kiểm   │
    │ tra)        │
    └──────┬──────┘
           │ process()
    ┌──────▼──────┐
    │ Processing  │
    │(Đang xử lý) │
    └──────┬──────┘
           │
    ┌──────▼──────┐
 ┌──┤ Completed   │
 │  │(Hoàn thành) │
 │  └─────────────┘
 │
 │  ┌─────────────┐
 └─►│   Failed    │
    │(Thất bại)   │
    └─────────────┘
```

#### 3.4.4 Sơ đồ Activity - Quy trình Xử lý Giao dịch
```
    ┌─────────────┐
    │   Bắt đầu   │
    └──────┬──────┘
           │
    ┌──────▼──────┐
    │ Chọn ví     │
    │ nguồn       │
    └──────┬──────┘
           │
    ┌──────▼──────┐
    │ Chọn ví đích│
    └──────┬──────┘
           │
    ┌──────▼──────┐
    │ Nhập số tiền│
    └──────┬──────┘
           │
    ┌──────▼──────┐
    │ Kiểm tra    │◄─────┐
    │ số dư       │      │
    └──────┬──────┘      │
           │              │
    ┌──────▼──────┐      │
    │ Số dư đủ?   │      │
    └──────┬──────┘      │
           │              │
          Yes             │
           │              │
    ┌──────▼──────┐      │
    │ Nhập PIN    │      │
    └──────┬──────┘      │
           │              │
    ┌──────▼──────┐      │
    │ Xác thực PIN│      │
    └──────┬──────┘      │
           │              │
    ┌──────▼──────┐      │
    │ PIN đúng?   │      │
    └──────┬──────┘      │
           │              │
          Yes             │
           │              │
    ┌──────▼──────┐      │
    │ Thực hiện   │      │
    │ chuyển tiền │      │
    └──────┬──────┘      │
           │              │
    ┌──────▼──────┐      │
    │ Cập nhật    │      │
    │ số dư       │      │
    └──────┬──────┘      │
           │              │
    ┌──────▼──────┐      │
    │ Lưu giao    │      │
    │ dịch        │      │
    └──────┬──────┘      │
           │              │
    ┌──────▼──────┐      │
    │ Thông báo   │      │
    │ thành công  │      │
    └──────┬──────┘      │
           │              │
    ┌──────▼──────┐      │
    │   Kết thúc  │      │
    └─────────────┘      │
                         │
           No            │
    ┌──────▼──────┐      │
    │ Hiển thị    │──────┘
    │ lỗi         │
    └─────────────┘
```

### 3.5 Chức năng Quản lý Chi tiêu

**Mô tả chức năng:**
Quản lý chi tiêu giúp người dùng theo dõi và phân loại các khoản thu chi hàng ngày. Hệ thống hỗ trợ nhiều danh mục như ăn uống, mua sắm, giải trí, giáo dục và cho phép tùy chỉnh. Mỗi khoản chi tiêu có thể kèm theo ghi chú, hình ảnh và được liên kết với ví tương ứng để tự động cập nhật số dư.

**Code Implementation:**

*Expense Model (models/expense.dart):*
```dart
class Expense {
  String id;
  String title;
  double amount;
  DateTime date;
  String category;
  String description;
  String type;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.description,
    this.type = 'Chi tiêu',
  });

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      amount: (map['amount'] as num).toDouble(),
      date: DateTime.parse(map['date']),
      category: map['category'] ?? '',
      description: map['description'] ?? '',
      type: map['type'] ?? 'Chi tiêu',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
      'description': description,
      'type': type,
    };
  }
}
```

*ExpenseProvider (providers/expense_provider.dart):*
```dart
class ExpenseProvider with ChangeNotifier {
  List<Expense> _expenses = [];
  final List<String> _categories = [
    'Ăn uống', 'Mua sắm', 'Giải trí', 'Giáo dục',
    'Y tế', 'Giao thông', 'Hóa đơn', 'Khác'
  ];

  List<Expense> get expenses => _expenses;
  List<String> get categories => _categories;

  Future<void> addExpense(Expense expense) async {
    _expenses.add(expense);
    notifyListeners();
  }

  List<Expense> getExpensesByCategory(String category) {
    return _expenses.where((expense) => expense.category == category).toList();
  }

  double getTotalExpenseByMonth(int month, int year) {
    return _expenses
        .where((expense) => 
            expense.date.month == month && 
            expense.date.year == year &&
            expense.type == 'Chi tiêu')
        .fold(0.0, (sum, expense) => sum + expense.amount);
  }
}
```

#### 3.5.1 Sơ đồ Use Case - Expense Management
```
                    ┌─────────────────────────────────┐
                    │     Expense Management          │
                    ├─────────────────────────────────┤
                    │                                 │
                    │  ┌─────────────┐               │
                    │  │ Thêm chi    │◄──────────────┤
                    │  │ tiêu        │               │
                    │  └─────────────┘               │
                    │  ┌─────────────┐               │
                    │  │ Phân loại   │◄──────────────┤
                    │  │ chi tiêu    │               │     ┌─────────┐
                    │  └─────────────┘               │◄────┤  User   │
                    │  ┌─────────────┐               │     └─────────┘
                    │  │ Chỉnh sửa   │◄──────────────┤
                    │  │ chi tiêu    │               │
                    │  └─────────────┘               │
                    │  ┌─────────────┐               │
                    │  │ Xóa chi tiêu│◄──────────────┤
                    │  └─────────────┘               │
                    │  ┌─────────────┐               │
                    │  │ Tìm kiếm    │◄──────────────┤
                    │  │ chi tiêu    │               │
                    │  └─────────────┘               │
                    └─────────────────────────────────┘
```

### 3.6 Chức năng Thống kê và Báo cáo

**Mô tả chức năng:**
Thống kê và báo cáo cung cấp cái nhìn tổng quan về tình hình tài chính của người dùng thông qua các biểu đồ trực quan và báo cáo chi tiết. Hệ thống phân tích xu hướng chi tiêu, so sánh thu chi theo thời gian và đưa ra các gợi ý tiết kiệm thông minh. Người dùng có thể xuất báo cáo dưới nhiều định dạng khác nhau.

**Code Implementation:**

*StatisticsScreen (screens/expenses/statistics_screen.dart):*
```dart
class StatisticsScreen extends StatefulWidget {
  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  String _selectedPeriod = 'month';

  List<PieChartSectionData> _getSections(Map<String, double> data) {
    final List<Color> colors = [
      Colors.blue, Colors.red, Colors.green, Colors.orange,
      Colors.yellow, Colors.purple, Colors.teal, Colors.pink,
    ];
    
    return data.entries.map((entry) {
      final index = data.keys.toList().indexOf(entry.key);
      final color = colors[index % colors.length];
      return PieChartSectionData(
        color: color,
        value: entry.value.abs(),
        title: '${(entry.value / data.values.fold(0.0, (a, b) => a + b) * 100).toStringAsFixed(1)}%',
        radius: 80,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ExpenseProvider, WalletProvider>(
      builder: (context, expenseProvider, walletProvider, child) {
        final categoryExpenses = <String, double>{};
        
        for (var expense in expenseProvider.expenses) {
          if (expense.type == 'Chi tiêu') {
            categoryExpenses[expense.category] = 
                (categoryExpenses[expense.category] ?? 0) + expense.amount.abs();
          }
        }

        return Scaffold(
          body: Column(
            children: [
              // Period selector
              _buildPeriodSelector(),
              // Pie chart
              Expanded(
                child: PieChart(
                  PieChartData(
                    sections: _getSections(categoryExpenses),
                    centerSpaceRadius: 40,
                    sectionsSpace: 2,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
```

#### 3.6.1 Sơ đồ Use Case - Statistics
```
                    ┌─────────────────────────────────┐
                    │        Statistics               │
                    ├─────────────────────────────────┤
                    │                                 │
                    │  ┌─────────────┐               │
                    │  │ Xem biểu đồ │◄──────────────┤
                    │  │ chi tiêu    │               │
                    │  └─────────────┘               │
                    │  ┌─────────────┐               │
                    │  │ Phân tích   │◄──────────────┤
                    │  │ xu hướng    │               │     ┌─────────┐
                    │  └─────────────┘               │◄────┤  User   │
                    │  ┌─────────────┐               │     └─────────┘
                    │  │ So sánh     │◄──────────────┤
                    │  │ thời gian   │               │
                    │  └─────────────┘               │
                    │  ┌─────────────┐               │
                    │  │ Xuất báo cáo│◄──────────────┤
                    │  └─────────────┘               │
                    └─────────────────────────────────┘
```

### 3.7 Kiến trúc tổng thể hệ thống
#### 3.7.1 Sơ đồ Class tổng thể
```
┌─────────────────────┐       ┌─────────────────────┐       ┌─────────────────────┐
│        User         │       │      Wallet         │       │    Transaction      │
├─────────────────────┤       ├─────────────────────┤       ├─────────────────────┤
│ - id: String        │   1:n │ - id: String        │   1:n │ - id: String        │
│ - name: String      │◄──────┤ - name: String      │◄──────┤ - type: String      │
│ - email: String     │       │ - balance: double   │       │ - amount: double    │
│ - phone: String     │       │ - type: String      │       │ - fromWalletId      │
├─────────────────────┤       ├─────────────────────┤       │ - toWalletId        │
│ + authenticate()    │       │ + updateBalance()   │       │ - createdAt         │
│ + getProfile()      │       │ + validate()        │       ├─────────────────────┤
└─────────────────────┘       └─────────────────────┘       │ + process()         │
           │                             │                   │ + validate()        │
           │ 1:n                        │                   └─────────────────────┘
           ▼                             │
┌─────────────────────┐                 │
│      Expense        │                 │
├─────────────────────┤                 │
│ - id: String        │                 │
│ - title: String     │                 │
│ - amount: double    │                 │
│ - category: String  │                 │
│ - date: DateTime    │                 │
├─────────────────────┤                 │
│ + categorize()      │                 │
│ + validate()        │                 │
└─────────────────────┘                 │
                                        │
                                        ▼
                              ┌─────────────────────┐
                              │    Statistics       │
                              ├─────────────────────┤
                              │ - period: String    │
                              │ - totalIncome       │
                              │ - totalExpense      │
                              │ - categories        │
                              ├─────────────────────┤
                              │ + generateChart()   │
                              │ + calculateTrend()  │
                              │ + exportReport()    │
                              └─────────────────────┘
```

### 3.8 Sơ đồ tổng hợp các Use Case
#### 3.8.1 Sơ đồ Use Case tổng thể
```
                    SmartWallet System
    ┌─────────────────────────────────────────────────────────┐
    │                                                         │
    │  ┌─────────────────┐    ┌─────────────────────────────┐ │
    │  │   Đăng nhập     │◄───┤                             │ │
    │  └─────────────────┘    │                             │ │
    │  ┌─────────────────┐    │                             │ │
    │  │   Đăng ký       │◄───┤                             │ │
    │  └─────────────────┘    │                             │ │
    │  ┌─────────────────┐    │         User                │ │
    │  │  Quản lý ví     │◄───┤      (Người dùng)          │ │
    │  └─────────────────┘    │                             │ │
    │  ┌─────────────────┐    │                             │ │
    │  │ Chuyển tiền     │◄───┤                             │ │
    │  └─────────────────┘    │                             │ │
    │  ┌─────────────────┐    │                             │ │
    │  │ Quản lý chi tiêu│◄───┤                             │ │
    │  └─────────────────┘    │                             │ │
    │  ┌─────────────────┐    │                             │ │
    │  │ Xem thống kê    │◄───┤                             │ │
    │  └─────────────────┘    │                             │ │
    │  ┌─────────────────┐    │                             │ │
    │  │ Quản lý lịch    │◄───┤                             │ │
    │  └─────────────────┘    └─────────────────────────────┘ │
    │                                                         │
    └─────────────────────────────────────────────────────────┘
```

### 3.9 Sơ đồ Activity tổng hợp
#### 3.9.1 Luồng chính của ứng dụng
```
                    ┌─────────┐
                    │  Start  │
                    └────┬────┘
                         │
                    ┌────▼────┐
                    │ Đăng    │
                    │ nhập    │
                    └────┬────┘
                         │
                    ┌────▼────┐
                    │ Home    │
                    │ Screen  │
                    └────┬────┘
                         │
        ┌────────────────┼────────────────┐
        │                │                │
   ┌────▼────┐      ┌────▼────┐     ┌────▼────┐
   │ Quản lý │      │ Chuyển  │     │ Thống   │
   │ ví      │      │ tiền    │     │ kê      │
   └────┬────┘      └────┬────┘     └────┬────┘
        │                │                │
        └────────────────┼────────────────┘
                         │
                    ┌────▼────┐
                    │ Cập     │
                    │ nhật    │
                    │ dữ liệu │
                    └────┬────┘
                         │
                    ┌────▼────┐
                    │   End   │
                    └─────────┘
```

### 3.10 Sơ đồ State tổng hợp
#### 3.10.1 Trạng thái ứng dụng tổng thể
```
                    ┌─────────────┐
                    │ App Start   │
                    └──────┬──────┘
                           │
                    ┌──────▼──────┐
                    │   Loading   │
                    └──────┬──────┘
                           │
                    ┌──────▼──────┐
              ┌─────┤Unauthenticated│
              │     └──────┬──────┘
              │            │ login()
    ┌─────────▼─────┐ ┌────▼────┐
    │ Registration  │ │ Login   │
    └─────────┬─────┘ └────┬────┘
              │            │
              └─────┬──────┘
                    │
             ┌──────▼──────┐
        ┌────┤Authenticated │
        │    └──────┬──────┘
        │           │
        │    ┌──────▼──────┐
        │ ┌──┤    Home     │──┐
        │ │  └─────────────┘  │
        │ │                  │
   ┌────▼─▼──┐  ┌─────────┐  │
   │ Wallet  │  │Transfer │  │
   │Management│  │ Money   │  │
   └────┬────┘  └────┬────┘  │
        │            │       │
        │     ┌──────▼──┐    │
        │     │Expense  │    │
        │     │Tracking │    │
        │     └────┬────┘    │
        │          │         │
        │   ┌──────▼──┐      │
        │   │Statistics│     │
        │   └────┬────┘      │
        │        │           │
        └────────┼───────────┘
                 │ logout()
          ┌──────▼──────┐
          │   Logout    │
          └─────────────┘
```

---

**Ghi chú:** Chương 3 được tổ chức theo từng chức năng chính của ứng dụng SmartWallet, mỗi chức năng bao gồm đầy đủ các sơ đồ UML: Use Case, Class, Sequence, State và Package Diagram để thể hiện thiết kế chi tiết và toàn diện của hệ thống.

---

## **CHƯƠNG 4: CÔNG NGHỆ VÀ CÔNG CỤ**

### 4.1 Công nghệ sử dụng
#### 4.1.1 Framework và ngôn ngữ
- **Flutter 3.x:** Framework phát triển đa nền tảng
- **Dart:** Ngôn ngữ lập trình chính
- **SDK version:** ≥ 3.6.2

#### 4.1.2 Thư viện và packages
- **State Management:** Provider (^6.1.2)
- **UI Components:**
  - material_symbols_icons (^4.2719.3)
  - flutter_spinkit (^5.2.1)
- **Charts:** fl_chart (^0.70.2)
- **Calendar:** table_calendar (^3.2.0)
- **Utilities:**
  - uuid (^4.5.1)
  - intl (^0.20.2)
  - crypto (^3.0.3)

### 4.2 Công cụ phát triển
- **IDE:** Android Studio / VS Code
- **SDK:** Flutter SDK, Android SDK, iOS SDK
- **Version Control:** Git
- **Design:** Figma (cho mockup)

### 4.3 Lý do chọn công nghệ
#### 4.3.1 Tại sao chọn Flutter?
- Phát triển đa nền tảng với một codebase
- Performance cao, gần native
- UI framework mạnh mẽ
- Cộng đồng lớn và tài liệu phong phú

#### 4.3.2 Tại sao chọn Provider?
- State management đơn giản, dễ hiểu
- Tích hợp tốt với Flutter
- Hiệu năng tốt cho ứng dụng vừa và nhỏ
- Dễ test và debug

---

## **CHƯƠNG 5: TRIỂN KHAI VÀ CÀI ĐẶT**

### 5.1 Cấu trúc dự án chi tiết
### 5.2 Triển khai các tính năng chính
### 5.3 Cài đặt và chạy ứng dụng

---

## **CHƯƠNG 6: THIẾT KẾ GIAO DIỆN NGƯỜI DÙNG**

### 6.1 Nguyên tắc thiết kế
### 6.2 Các màn hình chính
### 6.3 Animations và Transitions

---

## **CHƯƠNG 7: QUẢN LÝ DỮ LIỆU**

### 7.1 Chiến lược dữ liệu
### 7.2 Data Models

---

## **CHƯƠNG 8: TESTING VÀ DEBUGGING**

### 8.1 Chiến lược kiểm thử
### 8.2 Debugging và Optimization

---

## **CHƯƠNG 9: KẾT QUẢ VÀ ĐÁNH GIÁ**

### 9.1 Kết quả đạt được
### 9.2 Đánh giá và nhận xét
### 9.3 Bài học kinh nghiệm

---

## **CHƯƠNG 10: KẾT LUẬN VÀ HƯỚNG PHÁT TRIỂN**

### 10.1 Kết luận
### 10.2 Hướng phát triển tương lai

---

## **TÀI LIỆU THAM KHẢO**

### Tài liệu kỹ thuật
### Source Code

---

**Developed with ❤️ by Nguyễn Minh Dương - 23010441**

*SmartWallet - Quản lý tài chính thông minh, cuộc sống tài chính tự do!*