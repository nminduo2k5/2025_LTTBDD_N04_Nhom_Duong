# TEMPLATE MỤC LỤC BÁO CÁO BÀI TẬP MÔN HỌC
## Lập Trình Thiết Bị Di Động - Ứng Dụng SmartWallet

---

## **PHẦN I: THÔNG TIN CHUNG**

### 1. Thông tin sinh viên và đề tài
- **Họ và tên:** Nguyễn Minh Dương
- **Mã số sinh viên:** 23010441
- **Lớp:** Lập trình cho thiết bị di động-1-1-25(N04)
- **Nhóm:** 2025_LTTBDD_N04_Nhom_Duong
- **Tên đề tài:** Ứng dụng di động Ví điện tử SmartWallet
- **Ngày báo cáo:** [Điền ngày]

### 2. Tóm tắt đề tài
- Mô tả tổng quan ứng dụng
- Mục tiêu phát triển
- Đối tượng người dùng
- Phạm vi ứng dụng

---

## **PHẦN II: PHÂN TÍCH YÊU CẦU VÀ THIẾT KẾ HỆ THỐNG**

### 3. Phân tích yêu cầu hệ thống
#### 3.1 Yêu cầu chức năng
- **Quản lý ví điện tử**
  - Tạo và quản lý nhiều ví
  - Theo dõi số dư thời gian thực
  - Hỗ trợ nhiều loại tiền tệ
- **Chuyển tiền và thanh toán**
  - Chuyển tiền giữa các ví
  - Quét mã QR để thanh toán
  - Lịch sử giao dịch
- **Quản lý chi tiêu**
  - Theo dõi thu chi hàng ngày
  - Phân loại chi tiêu theo danh mục
  - Báo cáo thống kê
- **Lịch tài chính**
  - Xem chi tiêu theo ngày/tháng
  - Đánh dấu giao dịch quan trọng
- **Xác thực và bảo mật**
  - Đăng nhập/đăng ký
  - Quên mật khẩu
  - Bảo mật thông tin

#### 3.2 Yêu cầu phi chức năng
- Hiệu năng và tốc độ phản hồi
- Bảo mật thông tin người dùng
- Giao diện thân thiện, dễ sử dụng
- Tương thích đa nền tảng (Android, iOS)
- Khả năng mở rộng và bảo trì

### 4. Sơ đồ Use Case
#### 4.1 Xác định các Actor
- **Người dùng (User):** Chủ sở hữu ví điện tử
- **Hệ thống (System):** Ứng dụng SmartWallet

#### 4.2 Các Use Case chính
- **UC01: Đăng nhập/Đăng ký**
  - Đăng nhập vào hệ thống
  - Tạo tài khoản mới
  - Quên mật khẩu
- **UC02: Quản lý ví**
  - Tạo ví mới
  - Xem danh sách ví
  - Chỉnh sửa thông tin ví
  - Xóa ví
- **UC03: Quản lý giao dịch**
  - Chuyển tiền giữa các ví
  - Xem lịch sử giao dịch
  - Tìm kiếm giao dịch
- **UC04: Quản lý chi tiêu**
  - Thêm khoản chi tiêu
  - Phân loại chi tiêu
  - Chỉnh sửa/xóa chi tiêu
- **UC05: Xem thống kê**
  - Xem báo cáo chi tiêu
  - Phân tích xu hướng
  - Xuất báo cáo
- **UC06: Quản lý lịch**
  - Xem lịch tài chính
  - Đánh dấu ngày quan trọng
  - Nhắc nhở thanh toán

#### 4.3 Sơ đồ Use Case tổng thể
```
[Vẽ sơ đồ Use Case với các actor và use case đã xác định]
- Actor: User
- Use Cases: Login, Manage Wallets, Transfer Money, Track Expenses, View Statistics, Calendar Management
- Relationships: Include, Extend, Generalization
```

### 5. Sơ đồ Class (Class Diagram)
#### 5.1 Các lớp Model chính

**Class: User**
```
+------------------+
|      User        |
+------------------+
| - id: String     |
| - name: String   |
| - email: String  |
| - phone: String  |
| - avatar: String |
| - createdAt: DateTime |
+------------------+
| + fromJson()     |
| + toJson()       |
| + copyWith()     |
+------------------+
```

**Class: Wallet**
```
+------------------+
|     Wallet       |
+------------------+
| - id: String     |
| - name: String   |
| - type: String   |
| - balance: double|
| - currency: String|
| - bankName: String?|
| - accountNumber: String?|
| - isDefault: bool|
| - color: String  |
| - icon: String   |
+------------------+
| + fromJson()     |
| + toJson()       |
| + copyWith()     |
+------------------+
```

**Class: Transaction**
```
+------------------+
|   Transaction    |
+------------------+
| - id: String     |
| - type: String   |
| - amount: double |
| - fromWalletId: String|
| - toWalletId: String?|
| - recipientInfo: String?|
| - description: String|
| - createdAt: DateTime|
| - status: String |
| - fee: double?   |
+------------------+
| + fromJson()     |
| + toJson()       |
+------------------+
```

**Class: Expense**
```
+------------------+
|     Expense      |
+------------------+
| - id: String     |
| - title: String  |
| - amount: double |
| - date: DateTime |
| - category: String|
| - description: String|
| - type: String   |
+------------------+
| + fromMap()      |
| + toMap()        |
+------------------+
```

#### 5.2 Các lớp Provider (State Management)

**Class: WalletProvider**
```
+------------------+
|  WalletProvider  |
+------------------+
| - _wallets: List<Wallet>|
| - _selectedWallet: Wallet?|
| - _walletService: WalletService|
+------------------+
| + fetchWallets() |
| + addWallet()    |
| + updateWallet() |
| + deleteWallet() |
| + selectWallet() |
| + totalBalance: double|
+------------------+
```

**Class: ExpenseProvider**
```
+------------------+
| ExpenseProvider  |
+------------------+
| - _expenses: List<Expense>|
| - _categories: List<String>|
+------------------+
| + fetchExpenses()|
| + addExpense()   |
| + updateExpense()|
| + deleteExpense()|
| + getExpensesByCategory()|
+------------------+
```

#### 5.3 Các lớp Service (Business Logic)

**Class: AuthService**
```
+------------------+
|   AuthService    |
+------------------+
| + login()        |
| + register()     |
| + logout()       |
| + forgotPassword()|
| + isLoggedIn()   |
+------------------+
```

**Class: WalletService**
```
+------------------+
|  WalletService   |
+------------------+
| + getAllWallets()|
| + addWallet()    |
| + updateWallet() |
| + deleteWallet() |
| + getWalletById()|
+------------------+
```

#### 5.4 Mối quan hệ giữa các lớp
- **User** có nhiều **Wallet** (1:n)
- **Wallet** có nhiều **Transaction** (1:n)
- **User** có nhiều **Expense** (1:n)
- **WalletProvider** sử dụng **WalletService** (Dependency)
- **ExpenseProvider** quản lý **Expense** (Composition)

### 6. Sơ đồ tuần tự (Sequence Diagram)
#### 6.1 Luồng đăng nhập
```
User -> LoginScreen: nhập email/password
LoginScreen -> AuthService: login(email, password)
AuthService -> Database: validate credentials
Database -> AuthService: return result
AuthService -> LoginScreen: return success/error
LoginScreen -> HomeScreen: navigate on success
```

#### 6.2 Luồng chuyển tiền
```
User -> TransferScreen: chọn ví nguồn/đích, nhập số tiền
TransferScreen -> WalletProvider: transfer(fromWallet, toWallet, amount)
WalletProvider -> TransactionService: createTransaction()
TransactionService -> WalletService: updateBalance()
WalletService -> Database: save changes
Database -> WalletService: confirm
WalletService -> WalletProvider: notify success
WalletProvider -> TransferScreen: update UI
```

---

## **PHẦN III: THIẾT KẾ KIẾN TRÚC VÀ CÔNG NGHỆ**

### 7. Kiến trúc hệ thống
#### 7.1 Kiến trúc tổng thể
- **Pattern:** MVVM (Model-View-ViewModel) với Provider
- **Presentation Layer:** Screens và Widgets
- **Business Logic Layer:** Providers và Services
- **Data Layer:** Models và Local Storage

#### 7.2 Cấu trúc thư mục dự án
```
lib/
├── models/          # Data Models
├── providers/       # State Management (ViewModel)
├── services/        # Business Logic
├── screens/         # UI Screens (View)
├── widgets/         # Reusable Components
└── utils/           # Utilities và Constants
```

#### 7.3 Luồng dữ liệu
```
UI (Screens) ↔ Providers (State) ↔ Services (Logic) ↔ Models (Data)
```

## **PHẦN IV: CÔNG NGHỆ VÀ CÔNG CỤ**

### 8. Công nghệ sử dụng
#### 5.1 Framework và ngôn ngữ
- **Flutter 3.x** - Framework phát triển đa nền tảng
- **Dart** - Ngôn ngữ lập trình chính
- **SDK version:** ≥ 3.6.2

#### 5.2 Thư viện và packages
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

#### 5.3 Công cụ phát triển
- Android Studio / VS Code
- Flutter SDK
- Android SDK / iOS SDK
- Git version control

---

## **PHẦN V: TRIỂN KHAI VÀ CÀI ĐẶT**

### 9. Cấu trúc dự án
#### 6.1 Tổ chức thư mục
```
lib/
├── models/          # Các model dữ liệu
├── providers/       # State management với Provider
├── services/        # Business logic và API services
├── screens/         # Các màn hình ứng dụng
│   ├── authentication/  # Đăng nhập, đăng ký
│   ├── home/           # Màn hình chính
│   ├── wallet/         # Quản lý ví
│   ├── transfer/       # Chuyển tiền
│   ├── expenses/       # Quản lý chi tiêu
│   ├── calendar/       # Lịch tài chính
│   └── settings/       # Cài đặt
├── widgets/         # Components tái sử dụng
└── utils/           # Utilities và constants
```

#### 6.2 Các thành phần chính
- **Models:** Định nghĩa cấu trúc dữ liệu
- **Providers:** Quản lý state toàn cục
- **Services:** Xử lý logic nghiệp vụ
- **Screens:** Giao diện người dùng
- **Widgets:** Components tái sử dụng

### 10. Triển khai các tính năng
#### 7.1 Xác thực người dùng
- **LoginScreen:** Màn hình đăng nhập với animation
- **RegisterScreen:** Đăng ký tài khoản
- **ForgotPasswordScreen:** Quên mật khẩu
- **AuthService:** Xử lý logic xác thực

#### 7.2 Quản lý ví điện tử
- **WalletProvider:** State management cho ví
- **WalletService:** Business logic quản lý ví
- **WalletScreen:** Giao diện hiển thị danh sách ví
- **AddWalletScreen:** Thêm ví mới

#### 7.3 Giao dịch và chuyển tiền
- **TransactionProvider:** Quản lý state giao dịch
- **TransferScreen:** Màn hình chuyển tiền
- **TransactionService:** Xử lý logic giao dịch

#### 7.4 Quản lý chi tiêu
- **ExpenseProvider:** State management chi tiêu
- **AddExpenseScreen:** Thêm khoản chi tiêu
- **StatisticsScreen:** Thống kê và biểu đồ
- **ExpenseDetailScreen:** Chi tiết khoản chi tiêu

#### 7.5 Lịch tài chính
- **CalendarScreen:** Hiển thị lịch với giao dịch
- **Table Calendar integration:** Tích hợp thư viện lịch

#### 7.6 Thống kê và báo cáo
- **FL Chart integration:** Biểu đồ tròn, cột, đường
- **Phân tích theo danh mục:** Chi tiêu theo từng loại
- **Báo cáo xu hướng:** Theo dõi thay đổi theo thời gian

---

## **PHẦN VI: GIAO DIỆN NGƯỜI DÙNG**

### 11. Thiết kế UI/UX
#### 8.1 Design System
- **Material Design 3:** Tuân thủ guidelines mới nhất
- **Color Scheme:** Gradient teal, indigo, purple
- **Typography:** Roboto font family
- **Spacing:** Consistent padding và margin

#### 8.2 Các màn hình chính
- **Splash Screen:** Màn hình khởi động
- **Login/Register:** Xác thực với animation
- **Home Dashboard:** Tổng quan tài chính
- **Wallet Management:** Quản lý ví
- **Transfer Money:** Chuyển tiền
- **Expense Tracking:** Theo dõi chi tiêu
- **Statistics:** Thống kê và biểu đồ
- **Calendar View:** Lịch tài chính
- **Settings:** Cài đặt ứng dụng

#### 8.3 Animations và Transitions
- **Smooth transitions:** Chuyển đổi mượt mà
- **Micro-interactions:** Tương tác nhỏ
- **Loading states:** Trạng thái tải dữ liệu
- **Error handling:** Xử lý lỗi thân thiện

### 12. Responsive Design
- **Multi-screen support:** Hỗ trợ nhiều kích thước
- **Orientation handling:** Xoay màn hình
- **Accessibility:** Tuân thủ tiêu chuẩn accessibility

---

## **PHẦN VII: QUẢN LÝ DỮ LIỆU**

### 13. Chiến lược dữ liệu
#### 10.1 Local Storage
- **SharedPreferences:** Lưu settings và preferences
- **Mock Data:** Dữ liệu mẫu cho demo
- **Sample Data Structure:** Cấu trúc dữ liệu mẫu

#### 10.2 State Management
- **Provider Pattern:** Quản lý state toàn cục
- **ChangeNotifier:** Thông báo thay đổi state
- **Consumer Widgets:** Lắng nghe thay đổi

#### 10.3 Data Models
- **Serialization:** JSON to/from Dart objects
- **Validation:** Kiểm tra tính hợp lệ dữ liệu
- **Type Safety:** Đảm bảo kiểu dữ liệu

---

## **PHẦN VIII: TESTING VÀ DEBUGGING**

### 14. Chiến lược kiểm thử
#### 11.1 Unit Testing
- Test các models và services
- Test business logic
- Test utilities functions

#### 11.2 Widget Testing
- Test giao diện người dùng
- Test user interactions
- Test navigation flows

#### 11.3 Integration Testing
- Test end-to-end workflows
- Test data flow
- Test performance

### 15. Debugging và Optimization
#### 12.1 Performance Optimization
- Widget rebuilding optimization
- Memory management
- Asset optimization

#### 12.2 Error Handling
- Exception handling
- User-friendly error messages
- Logging và monitoring

---

## **PHẦN IX: DEPLOYMENT VÀ DISTRIBUTION**

### 16. Build và Release
#### 13.1 Android Build
- APK generation
- App signing
- Play Store preparation

#### 13.2 iOS Build
- IPA generation
- App Store preparation
- Provisioning profiles

#### 13.3 Web Build
- Flutter web compilation
- Hosting options
- PWA features

### 17. CI/CD Pipeline
- Automated testing
- Build automation
- Deployment strategies

---

## **PHẦN X: KẾT QUẢ VÀ ĐÁNH GIÁ**

### 18. Kết quả đạt được
#### 15.1 Tính năng hoàn thành
- Danh sách các tính năng đã triển khai
- Screenshots và demo
- User flow documentation

#### 15.2 Hiệu năng ứng dụng
- Performance metrics
- Loading times
- Memory usage

### 19. Đánh giá và nhận xét
#### 16.1 Ưu điểm
- Giao diện đẹp và hiện đại
- Trải nghiệm người dùng mượt mà
- Cấu trúc code rõ ràng
- Responsive design

#### 16.2 Hạn chế và cải tiến
- Các tính năng chưa hoàn thiện
- Performance bottlenecks
- Security considerations
- Scalability issues

---

## **PHẦN XI: TÀI LIỆU THAM KHẢO VÀ PHỤ LỤC**

### 20. Tài liệu tham khảo
- Flutter Documentation
- Material Design Guidelines
- Dart Language Specification
- Third-party packages documentation

### 21. Phụ lục
#### 18.1 Source Code
- Link to GitHub repository
- Code structure explanation
- Key code snippets

#### 18.2 Screenshots
- App screenshots
- UI/UX mockups
- User journey flows

#### 18.3 Installation Guide
- Development environment setup
- Dependencies installation
- Running the application

#### 18.4 API Documentation
- Service interfaces
- Data models
- Error codes

---

## **PHẦN XI: KẾT LUẬN VÀ HƯỚNG PHÁT TRIỂN**

## **PHẦN XII: KẾT LUẬN VÀ HƯớNG PHÁT TRIỂN**

### 22. Kết luận
- Tóm tắt những gì đã học được
- Đánh giá quá trình phát triển
- Kỹ năng đã cải thiện

### 23. Hướng phát triển tương lai
#### 20.1 Tính năng mở rộng
- AI-powered insights
- Real-time notifications
- Biometric authentication
- Multi-currency support
- Cloud synchronization

#### 20.2 Cải tiến kỹ thuật
- Backend integration
- Real-time database
- Push notifications
- Offline capabilities
- Security enhancements

#### 20.3 Business expansion
- Monetization strategies
- User acquisition
- Market analysis
- Competitive advantages

---

**Ghi chú:** Template này được thiết kế dựa trên phân tích chi tiết code repository SmartWallet. Sinh viên có thể điều chỉnh và bổ sung nội dung phù hợp với yêu cầu cụ thể của môn học và tiến độ phát triển ứng dụng.