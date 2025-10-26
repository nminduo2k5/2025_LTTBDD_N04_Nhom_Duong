class Transaction {
  final String id;
  final String
      type; // 'transfer', 'payment', 'topup', 'withdraw'
  final double amount;
  final String fromWalletId;
  final String? toWalletId;
  final String?
      recipientInfo; // Số điện thoại, email, số tài khoản
  final String? recipientName;
  final String description;
  final DateTime createdAt;
  final String
      status; // 'pending', 'completed', 'failed', 'cancelled'
  final String? transactionCode;
  final double? fee;
  final String? qrCode;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.fromWalletId,
    this.toWalletId,
    this.recipientInfo,
    this.recipientName,
    required this.description,
    required this.createdAt,
    this.status = 'pending',
    this.transactionCode,
    this.fee,
    this.qrCode,
  });

  factory Transaction.fromJson(
      Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      amount:
          (json['amount'] as num?)?.toDouble() ??
              0.0,
      fromWalletId: json['fromWalletId'] ?? '',
      toWalletId: json['toWalletId'],
      recipientInfo: json['recipientInfo'],
      recipientName: json['recipientName'],
      description: json['description'] ?? '',
      createdAt: DateTime.parse(
          json['createdAt'] ??
              DateTime.now().toIso8601String()),
      status: json['status'] ?? 'pending',
      transactionCode: json['transactionCode'],
      fee: (json['fee'] as num?)?.toDouble(),
      qrCode: json['qrCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'fromWalletId': fromWalletId,
      'toWalletId': toWalletId,
      'recipientInfo': recipientInfo,
      'recipientName': recipientName,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
      'transactionCode': transactionCode,
      'fee': fee,
      'qrCode': qrCode,
    };
  }
}
