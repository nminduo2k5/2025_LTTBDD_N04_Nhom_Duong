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

### 3.1 Sơ đồ Use Case
#### 3.1.1 Xác định Actor
- **Người dùng (User):** Chủ sở hữu ví điện tử
- **Hệ thống (System):** Ứng dụng SmartWallet

#### 3.1.2 Sơ đồ Use Case tổng thể
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

#### 3.1.3 Mô tả chi tiết Use Case
**UC01: Đăng nhập/Đăng ký**
- **Actor:** User
- **Mô tả:** Xác thực người dùng vào hệ thống
- **Luồng chính:**
  1. User nhập thông tin đăng nhập
  2. Hệ thống xác thực thông tin
  3. Chuyển đến màn hình chính

**UC02: Quản lý ví**
- **Actor:** User
- **Mô tả:** Người dùng quản lý các ví điện tử
- **Luồng chính:**
  1. User chọn "Quản lý ví"
  2. Hệ thống hiển thị danh sách ví
  3. User chọn thao tác (thêm/sửa/xóa)
  4. Hệ thống thực hiện và cập nhật

**Sơ đồ Activity cho UC02: Quản lý ví**
```
                    ┌─────────┐
                    │  Start  │
                    └────┬────┘
                         │
                    ┌────▼────┐
                    │ Chọn    │
                    │"Quản lý │
                    │  ví"    │
                    └────┬────┘
                         │
                    ┌────▼────┐
                    │Hiển thị │
                    │danh sách│
                    │  ví     │
                    └────┬────┘
                         │
                    ┌────▼────┐
                    │ Chọn   │
                    │thao tác │
                    └────┬────┘
                         │
        ┌─────────────┼─────────────┐
        │             │             │
   ┌────▼────┐   ┌────▼────┐   ┌────▼────┐
   │ Thêm ví  │   │ Sửa ví  │   │ Xóa ví  │
   └────┬────┘   └────┬────┘   └────┬────┘
        │             │             │
        └─────────────┼─────────────┘
                         │
                    ┌────▼────┐
                    │Thực hiện│
                    │ và cập   │
                    │ nhật     │
                    └────┬────┘
                         │
                    ┌────▼────┐
                    │   End   │
                    └─────────┘
```

**Sơ đồ Sequence cho UC02.1: Thêm ví mới**
```
    User      WalletScreen   WalletProvider   WalletService   Database
     │             │              │              │           │
     │──nhấn "Thêm"─►│              │              │           │
     │             │──hiển thị───►│              │           │
     │             │    form      │              │           │
     │──nhập thông tin►│              │              │           │
     │             │──addWallet()─►│              │           │
     │             │              │──save()──────►│           │
     │             │              │              │──insert──►│
     │             │              │              │           │
     │             │              │              │◄─confirm─│
     │             │              │◄──success───│           │
     │             │◄──update UI──│              │           │
     │◄──hiển thị───│              │              │           │
     │   thành công   │              │              │           │
```

**Sơ đồ Sequence cho UC02.3: Xóa ví**
```
    User      WalletScreen   WalletProvider   WalletService   Database
     │             │              │              │           │
     │──nhấn "Xóa"──►│              │              │           │
     │             │──hiển thị───►│              │           │
     │             │  xác nhận    │              │           │
     │──xác nhận────►│              │              │           │
     │             │─deleteWallet()►│              │           │
     │             │              │──delete()────►│           │
     │             │              │              │──remove──►│
     │             │              │              │           │
     │             │              │              │◄─confirm─│
     │             │              │◄──success───│           │
     │             │◄──update UI──│              │           │
     │◄──hiển thị───│              │              │           │
     │   thành công   │              │              │           │
```

**Sơ đồ State cho Wallet**
```
    ┌─────────┐
    │Tạo mới  │
    └────┬────┘
         │ create()
    ┌────▼────┐
 ┌──┤Hoạt động│──┐
 │  └─────────┘  │
 │               │ edit()
 │  ┌─────────┐  │
 └─►│Đang sửa │◄─┘
    └────┬────┘
         │ delete()
    ┌────▼────┐
    │ Đã xóa  │
    └─────────┘
```

**UC03: Chuyển tiền**
- **Actor:** User
- **Mô tả:** Chuyển tiền giữa các ví
- **Luồng chính:**
  1. User chọn ví nguồn và ví đích
  2. Nhập số tiền cần chuyển
  3. Xác nhận giao dịch
  4. Hệ thống thực hiện chuyển tiền

**UC04: Quản lý chi tiêu**
- **Actor:** User
- **Mô tả:** Thêm, sửa, xóa các khoản chi tiêu
- **Luồng chính:**
  1. User chọn "Quản lý chi tiêu"
  2. Hệ thống hiển thị danh sách chi tiêu
  3. User chọn thao tác (thêm/sửa/xóa)
  4. Hệ thống cập nhật và thống kê

**UC05: Xem thống kê**
- **Actor:** User
- **Mô tả:** Xem báo cáo thống kê tài chính
- **Luồng chính:**
  1. User chọn "Thống kê"
  2. Hệ thống tính toán dữ liệu
  3. Hiển thị biểu đồ và báo cáo
  4. User có thể lọc theo thời gian

### 3.2 Sơ đồ Class (Class Diagram)
#### 3.2.1 Sơ đồ Class tổng thể
```
┌─────────────────────┐       ┌─────────────────────┐
│        User         │       │    WalletProvider   │
├─────────────────────┤       ├─────────────────────┤
│ - id: String        │       │ - _wallets: List    │
│ - name: String      │       │ - _selectedWallet   │
│ - email: String     │   ┌───┤ - _walletService    │
│ - phone: String     │   │   ├─────────────────────┤
│ - avatar: String    │   │   │ + fetchWallets()    │
│ - createdAt: DateTime│  │   │ + addWallet()       │
├─────────────────────┤   │   │ + updateWallet()    │
│ + fromJson()        │   │   │ + deleteWallet()    │
│ + toJson()          │   │   │ + selectWallet()    │
│ + copyWith()        │   │   │ + totalBalance      │
└─────────────────────┘   │   └─────────────────────┘
           │               │              │
           │ 1           * │              │ uses
           ▼               │              ▼
┌─────────────────────┐    │   ┌─────────────────────┐
│       Wallet        │◄───┘   │   WalletService     │
├─────────────────────┤        ├─────────────────────┤
│ - id: String        │        │ + getAllWallets()   │
│ - name: String      │        │ + addWallet()       │
│ - type: String      │        │ + updateWallet()    │
│ - balance: double   │        │ + deleteWallet()    │
│ - currency: String  │        │ + getWalletById()   │
│ - bankName: String? │        └─────────────────────┘
│ - accountNumber: String?│
│ - isDefault: bool   │
│ - color: String     │
│ - icon: String      │
├─────────────────────┤
│ + fromJson()        │
│ + toJson()          │
│ + copyWith()        │
└─────────────────────┘
           │
           │ 1
           │
           │ *
           ▼
┌─────────────────────┐
│    Transaction      │
├─────────────────────┤
│ - id: String        │
│ - type: String      │
│ - amount: double    │
│ - fromWalletId: String│
│ - toWalletId: String?│
│ - description: String│
│ - createdAt: DateTime│
│ - status: String    │
├─────────────────────┤
│ + fromJson()        │
│ + toJson()          │
└─────────────────────┘

┌─────────────────────┐       ┌─────────────────────┐
│      Expense        │       │  ExpenseProvider    │
├─────────────────────┤       ├─────────────────────┤
│ - id: String        │   ┌───┤ - _expenses: List   │
│ - title: String     │   │   │ - _categories: List │
│ - amount: double    │   │   ├─────────────────────┤
│ - date: DateTime    │   │   │ + fetchExpenses()   │
│ - category: String  │◄──┘   │ + addExpense()      │
│ - description: String│       │ + updateExpense()   │
│ - type: String      │       │ + deleteExpense()   │
├─────────────────────┤       │ + getByCategory()   │
│ + fromMap()         │       └─────────────────────┘
│ + toMap()           │
└─────────────────────┘
```

#### 3.2.2 Mối quan hệ giữa các lớp
- **User** có nhiều **Wallet** (1:n)
- **Wallet** có nhiều **Transaction** (1:n)
- **User** có nhiều **Expense** (1:n)
- **WalletProvider** sử dụng **WalletService** (Dependency)
- **ExpenseProvider** quản lý **Expense** (Composition)

### 3.3 Sơ đồ tuần tự (Sequence Diagram)
#### 3.3.1 Luồng đăng nhập
```
    User        LoginScreen     AuthService      Database
     │               │               │              │
     │──nhập email───►│               │              │
     │   password     │               │              │
     │               │──login()──────►│              │
     │               │               │──validate────►│
     │               │               │   credentials │
     │               │               │◄─────result──│
     │               │◄──success/────│              │
     │               │     error     │              │
     │◄──navigate────│               │              │
     │   to Home     │               │              │
```

#### 3.3.2 Luồng chuyển tiền
```
  User    TransferScreen  WalletProvider  TransactionService  WalletService  Database
   │            │               │                │               │            │
   │──chọn ví───►│               │                │               │            │
   │ nhập tiền   │               │                │               │            │
   │            │──transfer()───►│                │               │            │
   │            │               │──createTransaction()──────────►│            │
   │            │               │                │               │──save──────►│
   │            │               │                │               │            │
   │            │               │                │               │◄──confirm──│
   │            │               │◄──────notify success──────────│            │
   │            │◄──update UI───│                │               │            │
   │◄──success──│               │                │               │            │
   │            │──transfer()───►│                │               │            │
   │            │               │──createTransaction()──────────►│            │
   │            │               │                │               │──save──────►│
   │            │               │                │               │            │
   │            │               │                │               │◄──confirm──│
   │            │               │◄──────notify success──────────│            │
   │            │◄──update UI───│                │               │            │
   │◄──success──│               │                │               │            │
```

#### 3.3.3 Luồng thêm chi tiêu
```
    User      AddExpenseScreen   ExpenseProvider    Database
     │              │                  │              │
     │──nhập info───►│                  │              │
     │              │──addExpense()────►│              │
     │              │                  │──save────────►│
     │              │                  │              │
     │              │                  │◄──confirm────│
     │              │◄──notify success─│              │
     │◄──update UI──│                  │              │
```

#### 3.3.4 Luồng xem thống kê
```
    User      StatisticsScreen   ExpenseProvider   ChartService   Database
     │              │                  │              │            │
     │──chọn filter─►│                  │              │            │
     │              │──getStatistics()─►│              │            │
     │              │                  │──query──────►│            │
     │              │                  │              │──fetch────►│
     │              │                  │              │            │
     │              │                  │              │◄──data────│
     │              │                  │◄──process───│            │
     │              │◄──chart data───│              │            │
     │◄──hiển thị───│                  │              │            │
     │   biểu đồ     │                  │              │            │
```

### 3.4 Sơ đồ Use Case chi tiết
#### 3.4.1 Sơ đồ Use Case mở rộng cho Quản lý ví
```
                    ┌─────────────────────────────────────────────────────────┐
                    │                    Quản lý ví                     │
                    └─────────────────────────────────────────────────────────┘
                                           │
                    ┌─────────────────────────┼────────────────────────────────┐
                    │                         │                         │
               ┌────▼────┐              ┌────▼────┐              ┌────▼────┐
               │ Thêm ví  │              │ Sửa ví  │              │ Xóa ví  │
               └─────────┘              └─────────┘              └─────────┘
                    │                         │                         │
                    │                         │                         │
               ┌────▼────┐              ┌────▼────┐              ┌────▼────┐
               │Validate  │              │Validate  │              │Xác nhận  │
               │thông tin │              │thông tin │              │ xóa     │
               └─────────┘              └─────────┘              └─────────┘
                    │                         │                         │
                    └─────────────────────────┼────────────────────────────────┘
                                           │
                                      ┌────▼────┐
                                      │Cập nhật │
                                      │database │
                                      └─────────┘
```

### 3.5 Sơ đồ hoạt động (Activity Diagram)
#### 3.5.1 Quy trình đăng nhập
```
                    ┌─────────┐
                    │  Start  │
                    └────┬────┘
                         │
                    ┌────▼────┐
                    │ Nhập    │
                    │email/pwd│
                    └────┬────┘
                         │
                    ┌────▼────┐
                    │Validate │
                    │ input   │
                    └────┬────┘
                         │
                    ┌────▼────┐
               ┌────┤ Valid?  │
               │    └─────────┘
               │No        │Yes
               │          │
          ┌────▼────┐     │
          │Hiển thị │     │
          │  lỗi    │     │
          └────┬────┘     │
               │          │
               └──────────┘
                         │
                    ┌────▼────┐
                    │Gửi req  │
                    │đăng nhập│
                    └────┬────┘
                         │
                    ┌────▼────┐
                    │Xác thực │
                    │ server  │
                    └────┬────┘
                         │
                    ┌────▼────┐
               ┌────┤Success? │
               │    └─────────┘
               │No        │Yes
               │          │
          ┌────▼────┐     │
          │Hiển thị │     │
          │lỗi đăng │     │
          │ nhập    │     │
          └─────────┘     │
                         │
                    ┌────▼────┐
                    │Lưu      │
                    │session  │
                    └────┬────┘
                         │
                    ┌────▼────┐
                    │Chuyển   │
                    │đến Home │
                    └────┬────┘
                         │
                    ┌────▼────┐
                    │   End   │
                    └─────────┘
```

#### 3.5.2 Quy trình chuyển tiền
```
     ┌─────────┐
     │  Start  │
     └────┬────┘
          │
     ┌────▼────┐    ┌────────┐    ┌────────┐
     │Chọn ví  │───►│Chọn ví │───►│Nhập số │
     │ nguồn   │    │  đích  │    │  tiền  │
     └─────────┘    └────────┘    └───┬────┘
                                      │
                                 ┌────▼────┐
                                 │Validate │
                                 │ số dư   │
                                 └────┬────┘
                                      │
                                 ┌────▼────┐
                            ┌────┤Đủ số dư?│
                            │    └─────────┘
                            │No       │Yes
                            │         │
                       ┌────▼────┐    │
                       │Thông báo│    │
                       │  lỗi    │    │
                       └─────────┘    │
                                      │
                                 ┌────▼────┐
                                 │Xác nhận │
                                 │giao dịch│
                                 └────┬────┘
                                      │
                                 ┌────▼────┐
                                 │Tạo      │
                                 │transaction│
                                 └────┬────┘
                                      │
                                 ┌────▼────┐
                                 │Cập nhật │
                                 │ số dư   │
                                 └────┬────┘
                                      │
                                 ┌────▼────┐
                                 │Lưu lịch │
                                 │  sử     │
                                 └────┬────┘
                                      │
                                 ┌────▼────┐
                                 │Thông báo│
                                 │thành công│
                                 └────┬────┘
                                      │
                                 ┌────▼────┐
                                 │   End   │
                                 └─────────┘
```

### 3.6 Sơ đồ trạng thái (State Diagram)
#### 3.6.1 Trạng thái ứng dụng
```
                    ┌─────────────┐
                    │ Khởi động   │
                    └──────┬──────┘
                           │
                    ┌──────▼──────┐
                    │   Loading   │
                    └──────┬──────┘
                           │
                    ┌──────▼──────┐
              ┌─────┤Chưa đăng nhập├─────┐
              │     └─────────────┘     │
              │                         │
    ┌─────────▼─────────┐               │
    │ Đăng nhập thành   │               │
    │     công          │               │
    └─────────┬─────────┘               │
              │                         │
       ┌──────▼──────┐                  │
   ┌───┤Đã đăng nhập │                  │
   │   └─────────────┘                  │
   │                                    │
   │   ┌─────────┐  ┌─────────────┐     │
   ├──►│  Home   │◄─┤   Wallet    │     │
   │   └────┬────┘  │ Management  │     │
   │        │       └─────────────┘     │
   │        │                          │
   │   ┌────▼────┐  ┌─────────────┐     │
   ├──►│Transfer │◄─┤ Statistics  │     │
   │   └─────────┘  └─────────────┘     │
   │                                    │
   │        ┌─────────────┐             │
   └────────┤ Đăng xuất   ├─────────────┘
            └─────────────┘
```

#### 3.6.2 Trạng thái giao dịch
```
    ┌─────────┐
    │Tạo mới  │
    └────┬────┘
         │
    ┌────▼────┐
    │ Pending │
    └────┬────┘
         │
    ┌────▼────┐
    │Đang xử lý│
    └────┬────┘
         │
    ┌────▼────┐
 ┌──┤ Kết quả │──┐
 │  └─────────┘  │
 │               │
▼               ▼
┌─────────┐ ┌─────────┐ ┌─────────┐
│Thành công│ │Thất bại │ │ Hủy bỏ  │
└────┬────┘ └────┬────┘ └────┬────┘
     │           │           │
     └───────────┼───────────┘
                 │
            ┌────▼────┐
            │Hoàn thành│
            └─────────┘
```

#### 3.6.3 Trạng thái ví điện tử
```
    ┌─────────┐
    │Tạo mới  │
    └────┬────┘
         │
    ┌────▼────┐
 ┌──┤Hoạt động│──┐
 │  └─────────┘  │
 │               │
 │  ┌─────────┐  │
 └─►│Tạm khóa │◄─┘
    └────┬────┘
         │
    ┌────▼────┐
    │  Xóa    │
    └────┬────┘
         │
    ┌────▼────┐
    │ Đã xóa  │
    └─────────┘
```

### 3.7 Thiết kế kiến trúc hệ thống
#### 3.7.1 Kiến trúc tổng thể
- **Pattern:** MVVM (Model-View-ViewModel) với Provider
- **Presentation Layer:** Screens và Widgets (View)
- **Business Logic Layer:** Providers (ViewModel) và Services
- **Data Layer:** Models và Local Storage

#### 3.7.2 Cấu trúc thư mục
```
lib/
├── models/          # Data Models
├── providers/       # State Management (ViewModel)
├── services/        # Business Logic
├── screens/         # UI Screens (View)
├── widgets/         # Reusable Components
└── utils/           # Utilities và Constants
```

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
#### 5.1.1 Tổ chức thư mục
```
lib/
├── models/
│   ├── user.dart
│   ├── wallet.dart
│   ├── transaction.dart
│   ├── expense.dart
│   ├── financial_goal.dart
│   └── notification.dart
├── providers/
│   ├── user_provider.dart
│   ├── wallet_provider.dart
│   ├── transaction_provider.dart
│   ├── expense_provider.dart
│   ├── notification_provider.dart
│   └── settings_provider.dart
├── services/
│   ├── auth_service.dart
│   ├── wallet_service.dart
│   ├── transaction_service.dart
│   ├── notification_service.dart
│   ├── qr_service.dart
│   └── security_service.dart
├── screens/
│   ├── authentication/
│   │   ├── login_screen.dart
│   │   ├── register_screen.dart
│   │   └── forgot_password_screen.dart
│   ├── home_screen.dart
│   ├── wallet/
│   │   ├── wallet_screen.dart
│   │   └── add_wallet_screen.dart
│   ├── transfer/
│   │   └── transfer_screen.dart
│   ├── expenses/
│   │   ├── add_expense_screen.dart
│   │   ├── expense_detail_screen.dart
│   │   └── statistics_screen.dart
│   ├── calendar/
│   │   └── calendar_screen.dart
│   └── settings/
│       ├── settings_screen.dart
│       └── profile_screen.dart
├── widgets/
│   ├── expense_card.dart
│   ├── expense_list.dart
│   ├── add_expense_form.dart
│   └── edit_expense_form.dart
├── utils/
│   ├── constants.dart
│   └── translations.dart
└── main.dart
```

### 5.2 Triển khai các tính năng chính
#### 5.2.1 Xác thực người dùng
- **LoginScreen:** Giao diện đăng nhập với animation
- **RegisterScreen:** Đăng ký tài khoản mới
- **ForgotPasswordScreen:** Khôi phục mật khẩu
- **AuthService:** Xử lý logic xác thực

#### 5.2.2 Quản lý ví điện tử
- **WalletProvider:** State management cho ví
- **WalletService:** Business logic quản lý ví
- **WalletScreen:** Hiển thị danh sách ví
- **AddWalletScreen:** Thêm ví mới

#### 5.2.3 Giao dịch và chuyển tiền
- **TransactionProvider:** Quản lý state giao dịch
- **TransferScreen:** Màn hình chuyển tiền
- **TransactionService:** Xử lý logic giao dịch

#### 5.2.4 Quản lý chi tiêu
- **ExpenseProvider:** State management chi tiêu
- **AddExpenseScreen:** Thêm khoản chi tiêu
- **StatisticsScreen:** Thống kê với biểu đồ
- **ExpenseDetailScreen:** Chi tiết khoản chi tiêu

### 5.3 Cài đặt và chạy ứng dụng
#### 5.3.1 Yêu cầu hệ thống
- Flutter SDK ≥ 3.0.0
- Dart SDK ≥ 2.17.0
- Android Studio hoặc VS Code
- Android SDK / iOS SDK

#### 5.3.2 Các bước cài đặt
1. Clone repository
2. Chạy `flutter pub get`
3. Chạy `flutter run`

---

## **CHƯƠNG 6: THIẾT KẾ GIAO DIỆN NGƯỜI DÙNG**

### 6.1 Nguyên tắc thiết kế
#### 6.1.1 Design System
- **Material Design 3:** Guidelines mới nhất
- **Color Scheme:** Gradient teal, indigo, purple
- **Typography:** Roboto font family
- **Spacing:** 8dp grid system

#### 6.1.2 Nguyên tắc UX
- Đơn giản, trực quan
- Nhất quán trong toàn bộ ứng dụng
- Phản hồi nhanh với người dùng
- Accessibility friendly

### 6.2 Các màn hình chính
#### 6.2.1 Màn hình đăng nhập
- Logo và branding
- Form đăng nhập với validation
- Nút đăng nhập với loading state
- Link đăng ký và quên mật khẩu

#### 6.2.2 Dashboard chính
- Header với tổng tài sản
- Quick actions (chuyển tiền, quét QR)
- Giao dịch gần đây
- Bottom navigation

#### 6.2.3 Quản lý ví
- Danh sách ví dạng card
- Thông tin số dư và loại ví
- Nút thêm ví mới
- Swipe actions (sửa/xóa)

#### 6.2.4 Thống kê
- Tab layout (danh mục, xu hướng, so sánh)
- Biểu đồ tròn cho chi tiêu theo danh mục
- Biểu đồ đường cho xu hướng
- Filter theo thời gian

### 6.3 Animations và Transitions
- **Hero animations:** Chuyển đổi giữa màn hình
- **Fade transitions:** Hiệu ứng mờ dần
- **Scale animations:** Phóng to/thu nhỏ
- **Loading animations:** Spinner và skeleton

---

## **CHƯƠNG 7: QUẢN LÝ DỮ LIỆU**

### 7.1 Chiến lược dữ liệu
#### 7.1.1 Local Storage
- **SharedPreferences:** Settings và preferences
- **Mock Data:** Dữ liệu mẫu cho demo
- **JSON Serialization:** Chuyển đổi object ↔ JSON

#### 7.1.2 State Management với Provider
- **ChangeNotifier:** Thông báo thay đổi state
- **Consumer:** Lắng nghe thay đổi
- **Provider.of:** Truy cập provider
- **MultiProvider:** Quản lý nhiều provider

### 7.2 Data Models
#### 7.2.1 Thiết kế Models
- Immutable objects
- JSON serialization
- Validation logic
- Copy methods

#### 7.2.2 Sample Data
- Ví mẫu với các loại khác nhau
- Giao dịch mẫu
- Chi tiêu theo danh mục
- Dữ liệu thống kê

---

## **CHƯƠNG 8: TESTING VÀ DEBUGGING**

### 8.1 Chiến lược kiểm thử
#### 8.1.1 Unit Testing
- Test models và serialization
- Test business logic trong services
- Test utility functions
- Test providers

#### 8.1.2 Widget Testing
- Test giao diện người dùng
- Test user interactions
- Test navigation flows
- Test form validation

#### 8.1.3 Integration Testing
- Test end-to-end workflows
- Test data flow giữa các layer
- Test performance

### 8.2 Debugging và Optimization
#### 8.2.1 Performance Optimization
- Widget rebuilding optimization
- Memory management
- Asset optimization
- Build size optimization

#### 8.2.2 Error Handling
- Try-catch blocks
- User-friendly error messages
- Logging và monitoring
- Graceful degradation

---

## **CHƯƠNG 9: KẾT QUẢ VÀ ĐÁNH GIÁ**

### 9.1 Kết quả đạt được
#### 9.1.1 Tính năng hoàn thành
- ✅ Xác thực người dùng (đăng nhập/đăng ký)
- ✅ Quản lý ví điện tử
- ✅ Theo dõi chi tiêu
- ✅ Thống kê với biểu đồ
- ✅ Lịch tài chính
- ✅ Giao diện responsive

#### 9.1.2 Screenshots và Demo
- Màn hình đăng nhập
- Dashboard chính
- Quản lý ví
- Thống kê chi tiêu
- Lịch tài chính

### 9.2 Đánh giá và nhận xét
#### 9.2.1 Ưu điểm
- Giao diện đẹp, hiện đại
- Trải nghiệm người dùng mượt mà
- Cấu trúc code rõ ràng, dễ maintain
- Responsive trên nhiều thiết bị
- Animations và transitions đẹp mắt

#### 9.2.2 Hạn chế và cải tiến
- Chưa có backend thực tế
- Một số tính năng còn đơn giản
- Chưa có push notifications
- Chưa có tích hợp thanh toán thực

### 9.3 Bài học kinh nghiệm
- Hiểu sâu về Flutter và Dart
- Nắm vững state management với Provider
- Kỹ năng thiết kế UI/UX
- Quản lý dự án và timeline
- Debug và optimize performance

---

## **CHƯƠNG 10: KẾT LUẬN VÀ HƯỚNG PHÁT TRIỂN**

### 10.1 Kết luận
#### 10.1.1 Tóm tắt đề tài
SmartWallet là ứng dụng ví điện tử được phát triển bằng Flutter, cung cấp các tính năng quản lý tài chính cá nhân cơ bản với giao diện hiện đại và trải nghiệm người dùng tốt.

#### 10.1.2 Đánh giá mục tiêu
- ✅ Hoàn thành ứng dụng demo với đầy đủ tính năng cơ bản
- ✅ Áp dụng thành công Flutter và các công nghệ liên quan
- ✅ Thiết kế giao diện đẹp, tuân thủ Material Design
- ✅ Cấu trúc code tốt, dễ bảo trì và mở rộng

### 10.2 Hướng phát triển tương lai
#### 10.2.1 Tính năng mở rộng
- **Backend Integration:** Kết nối với server thực tế
- **Real-time Sync:** Đồng bộ dữ liệu real-time
- **Push Notifications:** Thông báo đẩy
- **Biometric Auth:** Xác thực sinh trắc học
- **Multi-currency:** Hỗ trợ nhiều loại tiền tệ
- **AI Insights:** Phân tích thông minh với AI

#### 10.2.2 Cải tiến kỹ thuật
- **Database:** Tích hợp SQLite hoặc Firebase
- **API Integration:** Kết nối với banking APIs
- **Security:** Tăng cường bảo mật
- **Performance:** Tối ưu hiệu năng
- **Testing:** Tăng coverage testing

#### 10.2.3 Mở rộng business
- **Monetization:** Chiến lược kiếm tiền
- **User Acquisition:** Thu hút người dùng
- **Market Research:** Nghiên cứu thị trường
- **Competitive Analysis:** Phân tích đối thủ

---

## **TÀI LIỆU THAM KHẢO**

### Tài liệu kỹ thuật
1. Flutter Documentation - https://flutter.dev/docs
2. Dart Language Tour - https://dart.dev/guides/language/language-tour
3. Material Design 3 - https://m3.material.io/
4. Provider Package - https://pub.dev/packages/provider

### Tài liệu thiết kế
1. Material Design Guidelines
2. Flutter UI/UX Best Practices
3. Mobile App Design Patterns

### Source Code
- GitHub Repository: [Link to repository]
- Demo APK: [Link to APK file]

---

**Developed with ❤️ by Nguyễn Minh Dương - 23010441**

*SmartWallet - Quản lý tài chính thông minh, cuộc sống tài chính tự do!*