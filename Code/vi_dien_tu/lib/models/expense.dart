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
