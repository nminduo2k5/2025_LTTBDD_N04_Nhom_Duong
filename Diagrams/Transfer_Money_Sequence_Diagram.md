# Sơ đồ Trình Tự - Chức năng Chuyển tiền và Giao dịch

## 1. Sơ đồ Sequence - Quy trình Chuyển tiền Hoàn chỉnh

```mermaid
sequenceDiagram
    participant User
    participant TransferScreen
    participant TransactionProvider
    participant TransactionService
    participant ValidationService
    participant WalletService
    participant SecurityService
    participant Database

    User->>TransferScreen: Mở màn hình chuyển tiền
    TransferScreen->>TransactionProvider: Lấy danh sách ví
    TransactionProvider->>WalletService: getAllWallets()
    WalletService->>Database: Query wallets
    Database-->>WalletService: Return wallet list
    WalletService-->>TransactionProvider: List<Wallet>
    TransactionProvider-->>TransferScreen: Cập nhật UI

    User->>TransferScreen: Chọn ví nguồn
    User->>TransferScreen: Chọn ví đích
    User->>TransferScreen: Nhập số tiền
    User->>TransferScreen: Nhập mô tả
    User->>TransferScreen: Nhấn "Chuyển tiền"

    TransferScreen->>TransactionProvider: processTransfer(request)
    TransactionProvider->>ValidationService: validateTransferRequest(request)
    
    ValidationService->>ValidationService: validateAmount()
    ValidationService->>ValidationService: validateWalletIds()
    ValidationService->>WalletService: getWalletById(fromWalletId)
    WalletService-->>ValidationService: Wallet
    ValidationService->>ValidationService: validateBalance()
    ValidationService-->>TransactionProvider: ValidationResult

    alt Validation Failed
        TransactionProvider-->>TransferScreen: Error message
        TransferScreen-->>User: Hiển thị lỗi
    else Validation Success
        TransactionProvider->>SecurityService: verifyPin(pin)
        SecurityService-->>TransactionProvider: Pin verified
        
        TransactionProvider->>TransactionService: processTransfer(request)
        TransactionService->>TransactionService: createTransaction()
        
        TransactionService->>WalletService: updateWalletBalance(fromWallet, -amount)
        WalletService->>Database: Update balance
        Database-->>WalletService: Success
        
        TransactionService->>WalletService: updateWalletBalance(toWallet, +amount)
        WalletService->>Database: Update balance
        Database-->>WalletService: Success
        
        TransactionService->>Database: saveTransaction()
        Database-->>TransactionService: Transaction saved
        
        TransactionService-->>TransactionProvider: Transaction completed
        TransactionProvider-->>TransferScreen: Success
        TransferScreen-->>User: Hiển thị thành công
    end
```

## 2. Sơ đồ Sequence Chi Tiết - Xác thực và Bảo mật

```
User    TransferScreen  TransactionProvider  SecurityService  ValidationService  WalletService  Database
 │           │                │                 │                │               │            │
 │──input────►│                │                 │                │               │            │
 │ transfer   │                │                 │                │               │            │
 │ details    │                │                 │                │               │            │
 │           │──validate──────►│                 │                │               │            │
 │           │  input()        │                 │                │               │            │
 │           │                │──validate───────►│                │               │            │
 │           │                │  request()       │                │               │            │
 │           │                │                 │──check─────────►│               │            │
 │           │                │                 │  amount()      │               │            │
 │           │                │                 │               │──get──────────►│            │
 │           │                │                 │               │  wallet()     │            │
 │           │                │                 │               │               │──query────►│
 │           │                │                 │               │               │           │
 │           │                │                 │               │               │◄─result───│
 │           │                │                 │               │◄─wallet───────│            │
 │           │                │                 │◄─valid/───────│               │            │
 │           │                │                 │  error        │               │            │
 │           │                │◄─result()───────│                │               │            │
 │           │                │                 │                │               │            │
 │           │──request───────►│                 │                │               │            │
 │           │  pin()          │                 │                │               │            │
 │           │                │──verify─────────►│                │               │            │
 │           │                │  pin()          │                │               │            │
 │           │                │                 │──hash──────────►│               │            │
 │           │                │                 │  pin()         │               │            │
 │           │                │                 │◄─hashed────────│               │            │
 │           │                │                 │  pin           │               │            │
 │           │                │◄─verified/──────│                │               │            │
 │           │                │  failed         │                │               │            │
 │           │◄─result()───────│                 │                │               │            │
 │◄─success/─│                │                 │                │               │            │
 │  error    │                │                 │                │               │            │
```

## 3. Sơ đồ Sequence - Xử lý Giao dịch và Cập nhật Số dư

```
TransactionService  WalletService  Database  NotificationService  AuditService
        │               │           │              │                │
        │──begin────────►│           │              │                │
        │  transaction() │           │              │                │
        │               │──lock─────►│              │                │
        │               │  wallets() │              │                │
        │               │           │──lock────────►│                │
        │               │           │  records     │                │
        │               │           │◄─locked──────│                │
        │               │◄─locked───│              │                │
        │               │           │              │                │
        │──update───────►│           │              │                │
        │  from_wallet() │           │              │                │
        │               │──update───►│              │                │
        │               │  balance() │              │                │
        │               │           │──execute─────►│                │
        │               │           │  update      │                │
        │               │           │◄─success─────│                │
        │               │◄─updated──│              │                │
        │               │           │              │                │
        │──update───────►│           │              │                │
        │  to_wallet()   │           │              │                │
        │               │──update───►│              │                │
        │               │  balance() │              │                │
        │               │           │──execute─────►│                │
        │               │           │  update      │                │
        │               │           │◄─success─────│                │
        │               │◄─updated──│              │                │
        │               │           │              │                │
        │──save─────────►│           │              │                │
        │  transaction() │           │              │                │
        │               │──insert───►│              │                │
        │               │  record()  │              │                │
        │               │           │──execute─────►│                │
        │               │           │  insert      │                │
        │               │           │◄─success─────│                │
        │               │◄─saved────│              │                │
        │               │           │              │                │
        │──commit───────►│           │              │                │
        │  transaction() │           │              │                │
        │               │──unlock───►│              │                │
        │               │  wallets() │              │                │
        │               │           │──commit──────►│                │
        │               │           │              │                │
        │               │           │◄─committed───│                │
        │               │◄─unlocked─│              │                │
        │               │           │              │                │
        │──notify───────────────────────────────────►│                │
        │  success()                               │                │
        │                                         │──send────────────►│
        │                                         │  notification()  │
        │──log──────────────────────────────────────────────────────►│
        │  transaction()                                             │
        │                                                           │──audit──►│
        │                                                           │  log()   │
```

## 4. Sơ đồ Sequence - Xử lý Lỗi và Rollback

```
TransactionService  WalletService  Database  ErrorHandler  NotificationService
        │               │           │           │               │
        │──process──────►│           │           │               │
        │  transfer()    │           │           │               │
        │               │──update───►│           │               │
        │               │  balance() │           │               │
        │               │           │──execute──►│               │
        │               │           │           │               │
        │               │           │◄─error────│               │
        │               │◄─failed───│           │               │
        │◄─error────────│           │           │               │
        │               │           │           │               │
        │──handle───────────────────────────────►│               │
        │  error()                              │               │
        │                                       │──log──────────►│
        │                                       │  error()      │
        │                                       │               │
        │──rollback─────►│           │           │               │
        │  changes()     │           │           │               │
        │               │──restore──►│           │               │
        │               │  balance() │           │               │
        │               │           │──rollback─►│               │
        │               │           │           │               │
        │               │           │◄─restored─│               │
        │               │◄─restored─│           │               │
        │◄─rollback─────│           │           │               │
        │  complete     │           │           │               │
        │               │           │           │               │
        │──notify───────────────────────────────────────────────►│
        │  failure()                                           │
        │                                                     │──send──►│
        │                                                     │ alert() │
```

## 5. Sơ đồ Activity - Quy trình Chuyển tiền

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