import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'transaction_provider.dart';

class AddTransactionScreen extends StatefulWidget {
  final String category;
  final bool isIncome;

   AddTransactionScreen({super.key, required this.category, required this.isIncome});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final TextEditingController _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tiền ${widget.category}'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding:  EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _pickDate,
              icon:  Icon(Icons.calendar_today),
              label: Text(
                '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                style:  TextStyle(fontSize: 18),
              ),
            ),
             SizedBox(height: 16),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Số tiền',
                suffixText: 'VND',
                filled: true,
                fillColor: Colors.green[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
             SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                double amount = double.tryParse(_amountController.text) ?? 0;

                if (amount <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: Text('Vui lòng nhập số tiền hợp lệ')),
                  );
                  return;
                }

                final provider = Provider.of<TransactionProvider>(context, listen: false);
                await provider.addTransactionToSupabase(
                  amount: amount,
                  category: widget.category,
                  date: _selectedDate,
                  isIncome: widget.isIncome,
                );

                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:  EdgeInsets.symmetric(vertical: 14, horizontal: 40),
              ),
              child:  Text('Lưu', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}