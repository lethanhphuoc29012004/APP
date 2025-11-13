import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../home/transaction.dart';
import 'dart:collection';

class TransactionProvider extends ChangeNotifier {
  double totalIncome = 0;
  double totalExpense = 0;
  double balance = 0;

  final supabase = Supabase.instance.client;

  List<Transaction> _transactions = [];
  bool _isLoading = false;

  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;

  Future<void> addTransactionToSupabase({
    required double amount,
    required String category,
    required DateTime date,
    required bool isIncome,
    String? description,
  }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      await supabase.from('transactions').insert({
        'user_id': userId,
        'amount': amount,
        'category': category,
        'date': date.toIso8601String(),
        'is_income': isIncome,
        'description': description,
      });

      await fetchTransactionsFromSupabase();
      await fetchMonthlyStats();
    } catch (e) {
      print('Lỗi khi thêm giao dịch: $e');
    }
  }

  Future<void> fetchTransactionsFromSupabase() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await supabase
          .from('transactions')
          .select()
          .eq('user_id', userId)
          .order('date', ascending: true); // sắp xếp tăng dần để hỗ trợ biểu đồ

      _transactions = response.map<Transaction>((item) {
        return Transaction(
          id: item['id'], // 🛠 Thêm dòng này để truyền id
          amount: (item['amount'] as num).toDouble(),
          category: item['category'] ?? '',
          date: DateTime.parse(item['date']),
          isIncome: item['is_income'] ?? false,
          description: item['description'],
        );
      }).toList();
    } catch (e) {
      print('Lỗi khi lấy giao dịch: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMonthlyStats() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month, 1);
    final lastDay = DateTime(now.year, now.month + 1, 0);

    try {
      final response = await supabase
          .from('transactions')
          .select()
          .eq('user_id', userId)
          .gte('date', firstDay.toIso8601String())
          .lte('date', lastDay.toIso8601String());

      double income = 0;
      double expense = 0;

      for (final item in response) {
        final amt = (item['amount'] as num).toDouble();
        if (item['is_income'] == true) {
          income += amt;
        } else {
          expense += amt;
        }
      }

      totalIncome = income;
      totalExpense = expense;
      balance = income - expense;
      notifyListeners();
    } catch (e) {
      print('Lỗi khi lấy thống kê: $e');
    }
  }

  /// ⚡️ Hàm bổ sung: Nhóm giao dịch để hiển thị trong biểu đồ (dùng trong ReportContent)
  Map<String, Map<String, double>> groupTransactionsBy(
      List<Transaction> transactions, String type) {
    final Map<String, Map<String, double>> result = {};

    for (var tx in transactions) {
      String key;
      final date = tx.date;

      switch (type) {
        case 'year':
          key = '${date.year}';
          break;
        case 'month':
          key = '${date.month}/${date.year}';
          break;
        case 'week':
          final week = (date.day / 7).ceil();
          key = 'W$week-${date.month}/${date.year}';
          break;
        case 'day':
          key = '${date.day}/${date.month}/${date.year}';
          break;
        default:
          key = '${date.year}';
      }

      result.putIfAbsent(key, () => {'income': 0, 'expense': 0});
      if (tx.isIncome) {
        result[key]!['income'] = result[key]!['income']! + tx.amount;
      } else {
        result[key]!['expense'] = result[key]!['expense']! + tx.amount;
      }
    }

    return SplayTreeMap.from(result); // Tự động sắp xếp theo key
  }


  Future<void> deleteTransaction(String id) async {
    try {
      await Supabase.instance.client.from('transactions').delete().eq('id', id);
      await fetchTransactionsFromSupabase(); // Tải lại danh sách sau khi xóa
    } catch (e) {
      print('Lỗi khi xóa: $e');
    }
  }
}