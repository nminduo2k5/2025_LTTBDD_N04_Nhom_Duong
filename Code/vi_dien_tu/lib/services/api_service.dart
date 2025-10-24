import 'package:quan_ly_chi_tieu/models/expense.dart';

class ApiService {
  static final List<Expense> _expenses = [
    // Thu nhập
    Expense(
      id: '1',
      title: 'Lương tháng 12',
      amount: 8500000,
      category: 'Lương',
      date: DateTime.now().subtract(Duration(days: 5)),
      description: 'Lương cơ bản + thưởng',
      type: 'Thu nhập',
    ),
    Expense(
      id: '2',
      title: 'Freelance',
      amount: 2000000,
      category: 'Lương',
      date: DateTime.now().subtract(Duration(days: 10)),
      description: 'Dự án thiết kế website',
      type: 'Thu nhập',
    ),
    Expense(
      id: '3',
      title: 'Bán đồ cũ',
      amount: 500000,
      category: 'Khác',
      date: DateTime.now().subtract(Duration(days: 15)),
      description: 'Bán laptop cũ',
      type: 'Thu nhập',
    ),
    
    // Chi tiêu - Ăn uống
    Expense(
      id: '4',
      title: 'Ăn sáng',
      amount: -25000,
      category: 'Ăn uống',
      date: DateTime.now().subtract(Duration(days: 1)),
      description: 'Bánh mì và cà phê',
      type: 'Chi tiêu',
    ),
    Expense(
      id: '5',
      title: 'Ăn trưa',
      amount: -45000,
      category: 'Ăn uống',
      date: DateTime.now().subtract(Duration(days: 1)),
      description: 'Cơm văn phòng',
      type: 'Chi tiêu',
    ),
    Expense(
      id: '6',
      title: 'Đi nhậu',
      amount: -350000,
      category: 'Ăn uống',
      date: DateTime.now().subtract(Duration(days: 3)),
      description: 'Tiệc công ty',
      type: 'Chi tiêu',
    ),
    
    // Chi tiêu - Di chuyển
    Expense(
      id: '7',
      title: 'Xăng xe',
      amount: -150000,
      category: 'Di chuyển',
      date: DateTime.now().subtract(Duration(days: 2)),
      description: 'Đổ xăng xe máy',
      type: 'Chi tiêu',
    ),
    Expense(
      id: '8',
      title: 'Grab',
      amount: -85000,
      category: 'Di chuyển',
      date: DateTime.now().subtract(Duration(days: 4)),
      description: 'Về nhà muộn',
      type: 'Chi tiêu',
    ),
    
    // Chi tiêu - Nhà cửa
    Expense(
      id: '9',
      title: 'Tiền điện',
      amount: -450000,
      category: 'Nhà cửa',
      date: DateTime.now().subtract(Duration(days: 7)),
      description: 'Hóa đơn điện tháng 12',
      type: 'Chi tiêu',
    ),
    Expense(
      id: '10',
      title: 'Tiền nước',
      amount: -120000,
      category: 'Nhà cửa',
      date: DateTime.now().subtract(Duration(days: 8)),
      description: 'Hóa đơn nước tháng 12',
      type: 'Chi tiêu',
    ),
    Expense(
      id: '11',
      title: 'Internet',
      amount: -200000,
      category: 'Nhà cửa',
      date: DateTime.now().subtract(Duration(days: 12)),
      description: 'Cước internet FPT',
      type: 'Chi tiêu',
    ),
    
    // Chi tiêu - Sức khỏe
    Expense(
      id: '12',
      title: 'Khám bệnh',
      amount: -300000,
      category: 'Sức khỏe',
      date: DateTime.now().subtract(Duration(days: 6)),
      description: 'Khám tổng quát',
      type: 'Chi tiêu',
    ),
    Expense(
      id: '13',
      title: 'Mua thuốc',
      amount: -85000,
      category: 'Sức khỏe',
      date: DateTime.now().subtract(Duration(days: 9)),
      description: 'Thuốc cảm cúm',
      type: 'Chi tiêu',
    ),
    
    // Chi tiêu - Giải trí
    Expense(
      id: '14',
      title: 'Xem phim',
      amount: -120000,
      category: 'Giải trí',
      date: DateTime.now().subtract(Duration(days: 11)),
      description: 'Rạp CGV',
      type: 'Chi tiêu',
    ),
    Expense(
      id: '15',
      title: 'Game',
      amount: -200000,
      category: 'Giải trí',
      date: DateTime.now().subtract(Duration(days: 14)),
      description: 'Mua game Steam',
      type: 'Chi tiêu',
    ),
    
    // Chi tiêu - Quần áo
    Expense(
      id: '16',
      title: 'Áo sơ mi',
      amount: -450000,
      category: 'Quần áo',
      date: DateTime.now().subtract(Duration(days: 16)),
      description: 'Áo công sở',
      type: 'Chi tiêu',
    ),
    Expense(
      id: '17',
      title: 'Giày thể thao',
      amount: -1200000,
      category: 'Quần áo',
      date: DateTime.now().subtract(Duration(days: 20)),
      description: 'Nike Air Force 1',
      type: 'Chi tiêu',
    ),
    
    // Chi tiêu - Giáo dục
    Expense(
      id: '18',
      title: 'Khóa học online',
      amount: -500000,
      category: 'Giáo dục',
      date: DateTime.now().subtract(Duration(days: 18)),
      description: 'Khóa học Flutter',
      type: 'Chi tiêu',
    ),
    Expense(
      id: '19',
      title: 'Mua sách',
      amount: -150000,
      category: 'Giáo dục',
      date: DateTime.now().subtract(Duration(days: 22)),
      description: 'Sách lập trình',
      type: 'Chi tiêu',
    ),
    
    // Chi tiêu - Du lịch
    Expense(
      id: '20',
      title: 'Vé máy bay',
      amount: -2500000,
      category: 'Du lịch',
      date: DateTime.now().subtract(Duration(days: 25)),
      description: 'HN - ĐN khứ hồi',
      type: 'Chi tiêu',
    ),
    Expense(
      id: '21',
      title: 'Khách sạn',
      amount: -800000,
      category: 'Du lịch',
      date: DateTime.now().subtract(Duration(days: 26)),
      description: '2 đêm tại Đà Nẵng',
      type: 'Chi tiêu',
    ),
  ];

  Future<List<Expense>> getAllExpenses() async {
    await Future.delayed(Duration(milliseconds: 300));
    return List.from(_expenses);
  }

  Future<Expense> addExpense(Expense expense) async {
    await Future.delayed(Duration(milliseconds: 300));
    
    final newExpense = Expense(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: expense.title,
      amount: expense.amount,
      category: expense.category,
      date: expense.date,
      description: expense.description,
      type: expense.type,
    );
    
    _expenses.insert(0, newExpense);
    return newExpense;
  }

  Future<void> updateExpense(Expense expense) async {
    await Future.delayed(Duration(milliseconds: 300));
    
    final index = _expenses.indexWhere((e) => e.id == expense.id);
    if (index != -1) {
      _expenses[index] = expense;
    } else {
      throw Exception('Không tìm thấy giao dịch để cập nhật');
    }
  }

  Future<void> deleteExpense(Expense expense) async {
    await Future.delayed(Duration(milliseconds: 300));
    
    final initialLength = _expenses.length;
    _expenses.removeWhere((e) => e.id == expense.id);
    if (_expenses.length == initialLength) {
      throw Exception('Không tìm thấy giao dịch để xóa');
    }
  }


}
