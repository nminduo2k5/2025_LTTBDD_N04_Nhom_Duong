# 📳 SmartWallet - Ứng Dụng Ví Điện Tử Thông Minh

## 👨🎓 Thông Tin Sinh Viên
- **Họ và tên:** Nguyễn Minh Dương
- **Mã số sinh viên:** 23010441
- **Lớp:** Lập trình cho thiết bị di động-1-1-25(N04)
- **Nhóm:** 2025_LTTBDD_N04_Nhom_Duong

## 📱 Giới Thiệu Đề Tài
**Tên đề tài:** SmartWallet- Ứng dụng ví điện tử thông minh

SmartWallet là một ứng dụng ví điện tử hiện đại được phát triển bằng Flutter, cung cấp giải pháp quản lý tài chính cá nhân toàn diện với giao diện thân thiện và các tính năng thông minh.

## ✨ Tính Năng Chính

### 💰 Quản Lý Ví
- Tạo và quản lý nhiều ví điện tử
- Theo dõi số dư thời gian thực
- Hỗ trợ nhiều loại tiền tệ
- Giao diện card hiện đại với gradient

### 💸 Chuyển Tiền & Thanh Toán
- Chuyển tiền giữa các ví
- Quét mã QR để thanh toán
- Lịch sử giao dịch chi tiết
- Xác thực bảo mật đa lớp

### 📊 Quản Lý Chi Tiêu
- Theo dõi thu chi hàng ngày
- Phân loại chi tiêu theo danh mục
- Báo cáo thống kê trực quan
- Đặt mục tiêu tài chính

### 📅 Lịch Tài Chính
- Xem chi tiêu theo ngày/tháng
- Đánh dấu các giao dịch quan trọng
- Nhắc nhở thanh toán
- Lập kế hoạch chi tiêu

### 🔔 Thông Báo Thông Minh
- Cảnh báo chi tiêu vượt ngân sách
- Thông báo giao dịch
- Nhắc nhở mục tiêu tài chính
- Báo cáo tài chính định kỳ

## 🛠️ Công Nghệ Sử Dụng

- **Framework:** Flutter 3.x
- **Ngôn ngữ:** Dart
- **State Management:** Provider
- **UI/UX:** Material Design 3
- **Charts:** FL Chart
- **Calendar:** Table Calendar
- **QR Code:** QR Flutter
- **Local Storage:** Shared Preferences

## 📁 Cấu Trúc Dự Án

```
lib/
├── models/          # Các model dữ liệu
├── providers/       # State management
├── services/        # Business logic
├── screens/         # Các màn hình
│   ├── home/
│   ├── wallet/
│   ├── transfer/
│   ├── expenses/
│   └── calendar/
├── widgets/         # Components tái sử dụng
└── main.dart        # Entry point
```

## 🚀 Cài Đặt và Chạy Ứng Dụng

### Yêu Cầu Hệ Thống
- Flutter SDK ≥ 3.0.0
- Dart SDK ≥ 2.17.0
- Android Studio / VS Code
- Android SDK / iOS SDK

### Các Bước Cài Đặt

1. **Clone repository:**
```bash
git clone https://github.com/username/2025_LTTBDD_N04_Nhom_Duong.git
cd 2025_LTTBDD_N04_Nhom_Duong/Code/vi_dien_tu
```

2. **Cài đặt dependencies:**
```bash
flutter pub get
```

3. **Chạy ứng dụng:**
```bash
flutter run
```

## 📸 Screenshots

### Màn Hình Chính
- Dashboard tổng quan
- Quick actions
- Recent transactions

### Quản Lý Ví
- Danh sách ví
- Thêm ví mới
- Chi tiết ví

### Chuyển Tiền
- Chọn ví nguồn/đích
- Nhập số tiền
- Xác nhận giao dịch

### Thống Kê
- Biểu đồ thu chi
- Phân tích xu hướng
- Báo cáo chi tiết

## 🎨 Thiết Kế UI/UX

**Trọng tâm phát triển:** Dự án tập trung chủ yếu vào thiết kế giao diện người dùng hiện đại và trải nghiệm người dùng mượt mà.

- **Design System:** Material Design 3
- **Color Scheme:** Gradient teal, indigo, purple
- **Typography:** Roboto font family
- **Animations:** Smooth transitions và micro-interactions
- **Layout:** Card-based với rounded corners
- **Responsive Design:** Tối ưu cho nhiều kích thước màn hình
- **Dark/Light Theme:** Hỗ trợ chế độ sáng/tối
- **Accessibility:** Tuân thủ tiêu chuẩn accessibility

## 💾 Quản Lý Dữ Liệu

**Backend & Storage:** Ứng dụng sử dụng dữ liệu mẫu (mock data) và lưu trữ local để demo các tính năng.

- **Local Storage:** SharedPreferences cho settings và preferences
- **Mock Data:** Dữ liệu mẫu cho ví, giao dịch, và thống kê
- **Sample Wallets:** Ví mẫu với số dư và lịch sử giao dịch
- **Demo Transactions:** Giao dịch mẫu để hiển thị các tính năng
- **Fake API Responses:** Mô phỏng các response từ server
- **Static Charts Data:** Dữ liệu tĩnh cho biểu đồ và thống kê

## 🔐 Bảo Mật

- Mã hóa dữ liệu local
- Xác thực sinh trắc học
- Session timeout
- Secure storage cho thông tin nhạy cảm

## 📈 Tính Năng Nâng Cao

- **AI Insights:** Phân tích thói quen chi tiêu
- **Budget Planning:** Lập kế hoạch ngân sách thông minh
- **Goal Tracking:** Theo dõi mục tiêu tài chính
- **Export Data:** Xuất báo cáo Excel/PDF

## 🤝 Đóng Góp

Dự án được phát triển như một phần của môn học Lập trình cho thiết bị di động. Mọi góp ý và đề xuất xin gửi về email sinh viên.

## 📄 License

Dự án này được phát triển cho mục đích học tập tại trường Đại học.

---

**Developed with ❤️ by Nguyễn Minh Dương - 23010441**

*SmartWallet - Quản lý tài chính thông minh, cuộc sống tài chính tự do!*
