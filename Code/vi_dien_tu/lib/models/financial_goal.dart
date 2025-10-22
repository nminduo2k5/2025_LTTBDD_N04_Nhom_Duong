class FinancialGoal {
  final String id;
  final String name;
  final String description;
  final double targetAmount;
  final double currentAmount;
  final DateTime startDate;
  final DateTime targetDate;
  final String category; // 'savings', 'investment', 'purchase', 'debt'
  final String priority; // 'low', 'medium', 'high'
  final bool isCompleted;
  final String? imageUrl;

  FinancialGoal({
    required this.id,
    required this.name,
    required this.description,
    required this.targetAmount,
    this.currentAmount = 0.0,
    required this.startDate,
    required this.targetDate,
    required this.category,
    this.priority = 'medium',
    this.isCompleted = false,
    this.imageUrl,
  });

  double get progressPercentage {
    if (targetAmount <= 0) return 0.0;
    return (currentAmount / targetAmount * 100).clamp(0.0, 100.0);
  }

  int get daysRemaining {
    final now = DateTime.now();
    if (targetDate.isBefore(now)) return 0;
    return targetDate.difference(now).inDays;
  }

  double get dailyRequiredAmount {
    if (daysRemaining <= 0) return 0.0;
    final remaining = targetAmount - currentAmount;
    return remaining > 0 ? remaining / daysRemaining : 0.0;
  }

  factory FinancialGoal.fromJson(Map<String, dynamic> json) {
    return FinancialGoal(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      targetAmount: (json['targetAmount'] as num?)?.toDouble() ?? 0.0,
      currentAmount: (json['currentAmount'] as num?)?.toDouble() ?? 0.0,
      startDate: DateTime.parse(json['startDate'] ?? DateTime.now().toIso8601String()),
      targetDate: DateTime.parse(json['targetDate'] ?? DateTime.now().toIso8601String()),
      category: json['category'] ?? 'savings',
      priority: json['priority'] ?? 'medium',
      isCompleted: json['isCompleted'] ?? false,
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'startDate': startDate.toIso8601String(),
      'targetDate': targetDate.toIso8601String(),
      'category': category,
      'priority': priority,
      'isCompleted': isCompleted,
      'imageUrl': imageUrl,
    };
  }
}