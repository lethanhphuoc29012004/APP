class Transaction {
  final String id; // 🔹 Thêm ID để hỗ trợ update/delete
  final double amount;
  final String category;
  final DateTime date;
  final bool isIncome;
  final String? description;

  Transaction({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
    required this.isIncome,
    this.description,
  });

  // Convert from Supabase response to Transaction
  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'], // 🔹 Lấy ID từ Supabase
      amount: map['amount'].toDouble(),
      category: map['category'],
      date: DateTime.parse(map['date']),
      isIncome: map['is_income'] == true,
      description: map['description'],
    );
  }

  // Convert Transaction to map for Supabase
  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'is_income': isIncome,
      'description': description,
    };
  }
}
