import 'package:vi_dien_tu/models/expense.dart';

class ApiService {
  static final List<Expense> _expenses = [
    // Thu nhập
    Expense(
      id: '1',
      title: 'Lương tháng 12',
      amount: 8500000,
      category: 'Lương',
      date: DateTime.now()
          .subtract(Duration(days: 5)),
      description: 'Lương cơ bản + thưởng',
      type: 'Thu nhập',
    ),
    Expense(
      id: '2',
      title: 'Freelance',
      amount: 2000000,
      category: 'Lương',
      date: DateTime.now()
          .subtract(Duration(days: 10)),
      description: 'Dự án thiết kế website',
      type: 'Thu nhập',
    ),
    Expense(
      id: '3',
      title: 'Bán đồ cũ',
      amount: 500000,
      category: 'Khác',
      date: DateTime.now()
          .subtract(Duration(days: 15)),
      description: 'Bán laptop cũ',
      type: 'Thu nhập',
    ),

    // Chi tiêu - Ăn uống
    Expense(
      id: '4',
      title: 'Ăn sáng',
      amount: -25000,
      category: 'Ăn uống',
      date: DateTime.now()
          .subtract(Duration(days: 1)),
      description: 'Bánh mì và cà phê',
      type: 'Chi tiêu',
    ),
    Expense(
      id: '5',
      title: 'Ăn trưa',
      amount: -45000,
      category: 'Ăn uống',
      date: DateTime.now()
          .subtract(Duration(days: 1)),
      description: 'Cơm văn phòng',
      type: 'Chi tiêu',
    ),
    Expense(
      id: '6',
      title: 'Ăn cưới vợ cũ👰',
      amount: -350000,
      category: 'Ăn uống',
      date: DateTime.now()
          .subtract(Duration(days: 3)),
      description: 'Chúc em hạnh phúc👰',
      type: 'Chi tiêu',
    ),

    // Chi tiêu - Di chuyển
    Expense(
      id: '7',
      title: 'Xăng xe',
      amount: -150000,
      category: 'Di chuyển',
      date: DateTime.now()
          .subtract(Duration(days: 2)),
      description: 'Đổ xăng xe máy',
      type: 'Chi tiêu',
    ),
    Expense(
      id: '8',
      title: 'Grab',
      amount: -85000,
      category: 'Di chuyển',
      date: DateTime.now()
          .subtract(Duration(days: 4)),
      description: 'Về nhà muộn',
      type: 'Chi tiêu',
    ),

    // Chi tiêu - Nhà cửa
    Expense(
      id: '9',
      title: 'Tiền điện',
      amount: -450000,
      category: 'Nhà cửa',
      date: DateTime.now()
          .subtract(Duration(days: 7)),
      description: 'Hóa đơn điện tháng 12',
      type: 'Chi tiêu',
    ),
    Expense(
      id: '10',
      title: 'Tiền nước',
      amount: -120000,
      category: 'Nhà cửa',
      date: DateTime.now()
          .subtract(Duration(days: 8)),
      description: 'Hóa đơn nước tháng 12',
      type: 'Chi tiêu',
    ),
    Expense(
      id: '11',
      title: 'Internet',
      amount: -200000,
      category: 'Nhà cửa',
      date: DateTime.now()
          .subtract(Duration(days: 12)),
      description: 'Cước internet FPT',
      type: 'Chi tiêu',
    ),

    // Chi tiêu - Sức khỏe
    Expense(
      id: '12',
      title: 'Khám bệnh',
      amount: -300000,
      category: 'Sức khỏe',
      date: DateTime.now()
          .subtract(Duration(days: 6)),
      description: 'Khám tổng quát',
      type: 'Chi tiêu',
    ),
    Expense(
      id: '13',
      title: 'Mua thuốc',
      amount: -85000,
      category: 'Sức khỏe',
      date: DateTime.now()
          .subtract(Duration(days: 9)),
      description: 'Thuốc cảm cúm',
      type: 'Chi tiêu',
    ),

    // Chi tiêu - Giải trí
    Expense(
      id: '14',
      title: 'Xem phim',
      amount: -120000,
      category: 'Giải trí',
      date: DateTime.now()
          .subtract(Duration(days: 11)),
      description: 'Rạp CGV',
      type: 'Chi tiêu',
    ),
    Expense(
      id: '15',
      title: 'Game',
      amount: -200000,
      category: 'Giải trí',
      date: DateTime.now()
          .subtract(Duration(days: 14)),
      description: 'Mua game Steam',
      type: 'Chi tiêu',
    ),

    // Chi tiêu - Quần áo
    Expense(
      id: '16',
      title: 'Áo sơ mi',
      amount: -450000,
      category: 'Quần áo',
      date: DateTime.now()
          .subtract(Duration(days: 16)),
      description: 'Áo công sở',
      type: 'Chi tiêu',
    ),
    Expense(
      id: '17',
      title: 'Giày thể thao',
      amount: -1200000,
      category: 'Quần áo',
      date: DateTime.now()
          .subtract(Duration(days: 20)),
      description: 'Nike Air Force 1',
      type: 'Chi tiêu',
    ),

    // Chi tiêu - Giáo dục
    Expense(
      id: '18',
      title: 'Khóa học online',
      amount: -500000,
      category: 'Giáo dục',
      date: DateTime.now()
          .subtract(Duration(days: 18)),
      description: 'Khóa học Flutter',
      type: 'Chi tiêu',
    ),
    Expense(
      id: '19',
      title: 'Mua sách',
      amount: -150000,
      category: 'Giáo dục',
      date: DateTime.now()
          .subtract(Duration(days: 22)),
      description: 'Sách lập trình',
      type: 'Chi tiêu',
    ),

    // Chi tiêu - Du lịch
    Expense(
      id: '20',
      title: 'Vé máy bay',
      amount: -2500000,
      category: 'Du lịch',
      date: DateTime.now()
          .subtract(Duration(days: 25)),
      description: 'HN - ĐN khứ hồi',
      type: 'Chi tiêu',
    ),
    Expense(
      id: '21',
      title: 'Khách sạn',
      amount: -800000,
      category: 'Du lịch',
      date: DateTime.now()
          .subtract(Duration(days: 26)),
      description: '2 đêm tại Đà Nẵng',
      type: 'Chi tiêu',
    ),


  ];

  Future<List<Expense>> getAllExpenses() async {
    await Future.delayed(
        Duration(milliseconds: 300));
    return List.from(_expenses);
  }

  Future<Expense> addExpense(
      Expense expense) async {
    await Future.delayed(
        Duration(milliseconds: 300));

    final newExpense = Expense(
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(),
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

  Future<void> updateExpense(
      Expense expense) async {
    await Future.delayed(
        Duration(milliseconds: 300));

    final index = _expenses
        .indexWhere((e) => e.id == expense.id);
    if (index != -1) {
      _expenses[index] = expense;
    } else {
      throw Exception(
          'Không tìm thấy giao dịch để cập nhật');
    }
  }

  Future<void> deleteExpense(
      Expense expense) async {
    await Future.delayed(
        Duration(milliseconds: 300));

    final initialLength = _expenses.length;
    _expenses
        .removeWhere((e) => e.id == expense.id);
    if (_expenses.length == initialLength) {
      throw Exception(
          'Không tìm thấy giao dịch để xóa');
    }
  }

  // Bills data
  Future<List<Map<String, dynamic>>>
      getBills() async {
    await Future.delayed(
        Duration(milliseconds: 300));
    return [
      {
        'id': '1',
        'name': 'Hóa đơn điện EVN',
        'type': 'electric',
        'amount': '450,000',
        'dueDate': '25/01/2024',
      },
      {
        'id': '2',
        'name': 'Hóa đơn nước SAWACO',
        'type': 'water',
        'amount': '120,000',
        'dueDate': '28/01/2024',
      },
      {
        'id': '3',
        'name': 'Internet FPT',
        'type': 'internet',
        'amount': '200,000',
        'dueDate': '30/01/2024',
      },
      {
        'id': '4',
        'name': 'Gas Petrolimex',
        'type': 'gas',
        'amount': '350,000',
        'dueDate': '15/02/2024',
      },
    ];
  }

  // Mobile topup packages
  Future<List<Map<String, dynamic>>>
      getTopupPackages() async {
    await Future.delayed(
        Duration(milliseconds: 300));
    return [
      {
        'amount': '10,000',
        'description': 'Nạp cơ bản'
      },
      {
        'amount': '20,000',
        'description': 'Nạp tiết kiệm'
      },
      {
        'amount': '50,000',
        'description': 'Nạp phổ biến'
      },
      {
        'amount': '100,000',
        'description': 'Nạp cao cấp'
      },
      {
        'amount': '200,000',
        'description': 'Nạp VIP'
      },
      {
        'amount': '500,000',
        'description': 'Nạp doanh nghiệp'
      },
    ];
  }

  // Data packages
  Future<List<Map<String, dynamic>>>
      getDataPackages() async {
    await Future.delayed(
        Duration(milliseconds: 300));
    return [
      {
        'name': 'Data 1GB/ngày',
        'description':
            '1GB/ngày, không giới hạn cuộc gọi',
        'price': '15,000',
        'type': 'daily',
      },
      {
        'name': 'Data 2GB/ngày',
        'description': '2GB/ngày, miễn phí SMS',
        'price': '25,000',
        'type': 'daily',
      },
      {
        'name': 'Data 3GB/tuần',
        'description': '3GB/tuần, tốc độ cao',
        'price': '50,000',
        'type': 'weekly',
      },
      {
        'name': 'Data 6GB/tuần',
        'description': '6GB/tuần, không giới hạn',
        'price': '80,000',
        'type': 'weekly',
      },
      {
        'name': 'Data 10GB/tháng',
        'description': '10GB/tháng, tốc độ 4G',
        'price': '120,000',
        'type': 'monthly',
      },
      {
        'name': 'Data 20GB/tháng',
        'description': '20GB/tháng, tốc độ 5G',
        'price': '200,000',
        'type': 'monthly',
      },
    ];
  }

  // Movies data
  Future<List<Map<String, dynamic>>>
      getMovies() async {
    await Future.delayed(
        Duration(milliseconds: 300));
    return [
      {
        'id': '1',
        'title': 'Avatar: The Way of Water',
        'genre': 'Sci-Fi, Adventure',
        'rating': 8.5,
        'duration': 192,
      },
      {
        'id': '2',
        'title': 'Black Panther: Wakanda Forever',
        'genre': 'Action, Adventure',
        'rating': 7.8,
        'duration': 161,
      },
      {
        'id': '3',
        'title': 'Top Gun: Maverick',
        'genre': 'Action, Drama',
        'rating': 8.9,
        'duration': 130,
      },
      {
        'id': '4',
        'title': 'Minions: The Rise of Gru',
        'genre': 'Animation, Comedy',
        'rating': 7.2,
        'duration': 87,
      },
    ];
  }

  // Travel services
  Future<List<Map<String, dynamic>>>
      getTravelServices() async {
    await Future.delayed(
        Duration(milliseconds: 300));
    return [
      {
        'name': 'Vé máy bay',
        'description': 'Đặt vé máy bay giá rẻ',
        'type': 'flight',
      },
      {
        'name': 'Khách sạn',
        'description': 'Đặt phòng khách sạn',
        'type': 'hotel',
      },
      {
        'name': 'Xe khách',
        'description': 'Vé xe khách liên tỉnh',
        'type': 'bus',
      },
      {
        'name': 'Tàu hỏa',
        'description': 'Vé tàu hỏa toàn quốc',
        'type': 'train',
      },
      {
        'name': 'Thuê xe',
        'description': 'Thuê xe tự lái',
        'type': 'car',
      },
      {
        'name': 'Tour du lịch',
        'description': 'Gói tour trọn gói',
        'type': 'tour',
      },
    ];
  }
}
