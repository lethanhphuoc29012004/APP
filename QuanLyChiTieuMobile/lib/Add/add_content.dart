import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../home/transaction.dart';
import '../page_home.dart';

class AddContent extends StatefulWidget {
  final Transaction? transaction;

  const AddContent({super.key, this.transaction});

  @override
  State<AddContent> createState() => _AddContentState();
}

class _AddContentState extends State<AddContent> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = 'Ăn uống';
  DateTime _selectedDate = DateTime.now();
  bool _isIncome = false;

  final List<Map<String, String>> _incomeCategories = [
    {'label': 'Tiền lương', 'icon': 'money'},
    {'label': 'Tiền thưởng', 'icon': 'emoji_events'},
    {'label': 'Quà tặng', 'icon': 'gift'},
    {'label': 'Lợi nhuận đầu tư', 'icon': 'show_chart'},
    {'label': 'Tặng tiền', 'icon': 'account_balance_wallet'},
    {'label': 'Thu nhập từ kinh doanh', 'icon': 'business'},
    {'label': 'Thu nhập từ tài khoản phụ', 'icon': 'credit_card'},
  ];

  final List<Map<String, String>> _expenseCategories = [
    {'label': 'Nhà cửa', 'icon': 'house'},
    {'label': 'Đám tiệc', 'icon': 'celebration'},
    {'label': 'Đi lại', 'icon': 'directions_car'},
    {'label': 'Thực phẩm', 'icon': 'food_bank'},
    {'label': 'Sức khỏe', 'icon': 'local_hospital'},
    {'label': 'Học tập', 'icon': 'school'},
    {'label': 'Du lịch', 'icon': 'airplane_ticket'},
    {'label': 'Tiền thuê nhà', 'icon': 'home'},
    {'label': 'Hóa đơn điện nước', 'icon': 'electric_bolt'},
    {'label': 'Mua sắm', 'icon': 'shopping_bag'},
    {'label': 'Giải trí', 'icon': 'sports_esports'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      final tx = widget.transaction!;
      _amountController.text = tx.amount.toString();
      _descriptionController.text = tx.description ?? '';
      _selectedCategory = tx.category;
      _selectedDate = tx.date;
      _isIncome = tx.isIncome;
    }
  }

  Future<void> _saveTransaction() async {
    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập số tiền hợp lệ')),
      );
      return;
    }

    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không tìm thấy người dùng')),
      );
      return;
    }

    final data = {
      'user_id': userId,
      'category': _selectedCategory,
      'amount': amount,
      'date': _selectedDate.toIso8601String(),
      'is_income': _isIncome,
      'description': _descriptionController.text.trim(),
    };

    try {
      if (widget.transaction == null) {
        // Insert mới
        await Supabase.instance.client.from('transactions').insert(data);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Thêm giao dịch thành công')));
      } else {
        // Update
        await Supabase.instance.client
            .from('transactions')
            .update(data)
            .eq('id', widget.transaction!.id);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cập nhật giao dịch thành công')));
      }

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  IconData _getCategoryIcon(String iconName) {
    switch (iconName) {
      case 'restaurant':
        return Icons.restaurant;
      case 'shopping_bag':
        return Icons.shopping_bag;
      case 'house':
        return Icons.house;
      case 'celebration':
        return Icons.celebration;
      case 'directions_car':
        return Icons.directions_car;
      case 'local_hospital':
        return Icons.local_hospital;
      case 'school':
        return Icons.school;
      case 'money':
        return Icons.monetization_on;
      case 'emoji_events':
        return Icons.emoji_events;
      case 'gift':
        return Icons.card_giftcard;
      case 'show_chart':
        return Icons.show_chart;
      case 'electric_bolt':
        return Icons.electric_bolt;
      case 'home':
        return Icons.home;
      case 'airplane_ticket':
        return Icons.airplane_ticket;
      case 'food_bank':
        return Icons.food_bank;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.transaction != null;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Row(
          children: [
            Icon(isEditing ? Icons.edit_note : Icons.add_circle_outline, color: Colors.white, size: 45),
            const SizedBox(width: 15),
            Text(isEditing ? 'Sửa giao dịch' : 'Thêm giao dịch',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Số tiền (VND)',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) => value!.isEmpty ? 'Vui lòng nhập số tiền' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Mô tả giao dịch',
                  prefixIcon: Icon(Icons.description),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text('Ngày: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                onTap: _pickDate,
              ),
              const SizedBox(height: 16),
              const Text('Loại giao dịch:', style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Radio<bool>(
                    value: true,
                    groupValue: _isIncome,
                    onChanged: (value) => setState(() => _isIncome = value!),
                  ),
                  const Text('Thu'),
                  Radio<bool>(
                    value: false,
                    groupValue: _isIncome,
                    onChanged: (value) => setState(() => _isIncome = value!),
                  ),
                  const Text('Chi'),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Chọn danh mục:', style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: (_isIncome ? _incomeCategories : _expenseCategories).map((cat) {
                  final isSelected = _selectedCategory == cat['label'];
                  return ChoiceChip(
                    label: Text(cat['label']!),
                    avatar: Icon(_getCategoryIcon(cat['icon']!), size: 20),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedCategory = cat['label']!),
                    selectedColor: Colors.green[300],
                    backgroundColor: Colors.grey[200],
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: Icon(isEditing ? Icons.save : Icons.add),
                label: Text(isEditing ? 'Lưu thay đổi' : 'Thêm giao dịch', style: const TextStyle(fontSize: 16)),
                onPressed: _saveTransaction,
              ),
            ],
          ),
        ),
      ),
    );
  }
}