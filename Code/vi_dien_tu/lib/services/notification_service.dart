import 'package:vi_dien_tu/models/notification.dart';

class NotificationService {
  static final List<AppNotification>
      _notifications = [
    AppNotification(
      id: '1',
      title: 'Giao dịch thành công',
      message:
          'Bạn đã chuyển 500.000đ thành công',
      type: 'transaction',
      createdAt: DateTime.now()
          .subtract(Duration(minutes: 30)),
      data: {
        'transactionId': 'TXN001',
        'amount': 500000
      },
    ),
    AppNotification(
      id: '2',
      title: 'Nhắc nhở mục tiêu',
      message:
          'Bạn cần tiết kiệm thêm 200.000đ để đạt mục tiêu tháng này',
      type: 'goal',
      createdAt: DateTime.now()
          .subtract(Duration(hours: 2)),
      isRead: true,
    ),
    AppNotification(
      id: '3',
      title: 'Cảnh báo bảo mật',
      message:
          'Phát hiện đăng nhập từ thiết bị mới',
      type: 'security',
      createdAt: DateTime.now()
          .subtract(Duration(hours: 5)),
    ),
    AppNotification(
      id: '4',
      title: 'Khuyến mãi đặc biệt',
      message:
          'Giảm 50% phí chuyển tiền trong tuần này!',
      type: 'promotion',
      createdAt: DateTime.now()
          .subtract(Duration(days: 1)),
      actionUrl: '/promotions/special-offer',
    ),
  ];

  Future<List<AppNotification>>
      getAllNotifications() async {
    await Future.delayed(
        Duration(milliseconds: 300));
    return List.from(_notifications);
  }

  Future<void> markAsRead(
      String notificationId) async {
    await Future.delayed(
        Duration(milliseconds: 200));

    final index = _notifications.indexWhere(
        (n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] =
          _notifications[index]
              .copyWith(isRead: true);
    } else {
      throw Exception('Không tìm thấy thông báo');
    }
  }

  Future<void> markAllAsRead() async {
    await Future.delayed(
        Duration(milliseconds: 300));

    for (int i = 0;
        i < _notifications.length;
        i++) {
      _notifications[i] = _notifications[i]
          .copyWith(isRead: true);
    }
  }

  Future<void> deleteNotification(
      String notificationId) async {
    await Future.delayed(
        Duration(milliseconds: 200));

    final initialLength = _notifications.length;
    _notifications.removeWhere(
        (n) => n.id == notificationId);
    if (_notifications.length == initialLength) {
      throw Exception(
          'Không tìm thấy thông báo để xóa');
    }
  }

  Future<AppNotification> addNotification(
      AppNotification notification) async {
    await Future.delayed(
        Duration(milliseconds: 200));

    final newNotification = AppNotification(
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(),
      title: notification.title,
      message: notification.message,
      type: notification.type,
      createdAt: DateTime.now(),
      isRead: false,
      data: notification.data,
      actionUrl: notification.actionUrl,
    );

    _notifications.insert(0, newNotification);
    return newNotification;
  }

  Future<void> sendTransactionNotification(
      String transactionId,
      double amount,
      String type) async {
    String title = '';
    String message = '';

    switch (type) {
      case 'transfer':
        title = 'Chuyển tiền thành công';
        message =
            'Bạn đã chuyển ${_formatCurrency(amount)} thành công';
        break;
      case 'payment':
        title = 'Thanh toán thành công';
        message =
            'Bạn đã thanh toán ${_formatCurrency(amount)} thành công';
        break;
      case 'topup':
        title = 'Nạp tiền thành công';
        message =
            'Bạn đã nạp ${_formatCurrency(amount)} thành công';
        break;
      default:
        title = 'Giao dịch thành công';
        message =
            'Giao dịch ${_formatCurrency(amount)} đã hoàn tất';
    }

    final notification = AppNotification(
      id: '',
      title: title,
      message: message,
      type: 'transaction',
      createdAt: DateTime.now(),
      data: {
        'transactionId': transactionId,
        'amount': amount
      },
    );

    await addNotification(notification);
  }

  String _formatCurrency(double amount) {
    return '${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ';
  }
}
