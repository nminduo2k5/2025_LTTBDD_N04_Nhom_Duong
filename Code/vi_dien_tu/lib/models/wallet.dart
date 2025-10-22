class Wallet {
  final String id;
  final String name;
  final String type; // 'cash', 'bank', 'credit', 'savings'
  final double balance;
  final String currency;
  final String? bankName;
  final String? accountNumber;
  final String? cardNumber;
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
    this.accountNumber,
    this.cardNumber,
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
      accountNumber: json['accountNumber'],
      cardNumber: json['cardNumber'],
      isDefault: json['isDefault'] ?? false,
      color: json['color'] ?? '#2196F3',
      icon: json['icon'] ?? 'wallet',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'balance': balance,
      'currency': currency,
      'bankName': bankName,
      'accountNumber': accountNumber,
      'cardNumber': cardNumber,
      'isDefault': isDefault,
      'color': color,
      'icon': icon,
    };
  }

  Wallet copyWith({
    String? id,
    String? name,
    String? type,
    double? balance,
    String? currency,
    String? bankName,
    String? accountNumber,
    String? cardNumber,
    bool? isDefault,
    String? color,
    String? icon,
  }) {
    return Wallet(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      bankName: bankName ?? this.bankName,
      accountNumber: accountNumber ?? this.accountNumber,
      cardNumber: cardNumber ?? this.cardNumber,
      isDefault: isDefault ?? this.isDefault,
      color: color ?? this.color,
      icon: icon ?? this.icon,
    );
  }
}