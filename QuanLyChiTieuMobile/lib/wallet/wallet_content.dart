import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../home/transaction_provider.dart';
import 'history.dart';

class WalletContent extends StatefulWidget {
   WalletContent({super.key});

  @override
  State<WalletContent> createState() => _WalletContentState();
}

class _WalletContentState extends State<WalletContent> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  double spendingLimit = 0;
  double totalSpent = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TransactionProvider>(context, listen: false).fetchMonthlyStats();
    });
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? startDate : endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
        _updateTotalSpent();
      });
    }
  }

  void _addSpendingLimit() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:  Text('Nhập giới hạn tiêu dùng'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration:  InputDecoration(hintText: 'Nhập số tiền (VND)'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                spendingLimit = double.tryParse(controller.text) ?? 0;
              });
              _updateTotalSpent();
              Navigator.pop(context);
            },
            child:  Text('Xác nhận'),
          ),
        ],
      ),
    );
  }

  void _updateTotalSpent() {
    final transactions = Provider.of<TransactionProvider>(context, listen: false).totalExpense;
    totalSpent = transactions;
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final totalIncome = transactionProvider.totalIncome;
    final totalExpense = transactionProvider.totalExpense;
    final balance = transactionProvider.balance;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Row(
          children:  [
            Icon(Icons.account_balance_wallet_outlined, color: Colors.white, size: 35),
            SizedBox(width: 12),
            Text('Ví tiêu dùng', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: _buildViTieuDung(totalIncome, totalExpense, balance),
      floatingActionButton: FloatingActionButton(
        onPressed: _addSpendingLimit,
        backgroundColor: Colors.green,
        tooltip: 'Nhập giới hạn tiêu dùng',
        child:  Icon(Icons.add),
      ),
    );
  }

  Widget _buildViTieuDung(double totalIncome, double totalExpense, double balance) {
    final remaining = (spendingLimit - totalExpense).clamp(0, double.infinity);
    final exceeded = totalExpense > spendingLimit ? totalExpense - spendingLimit : 0;

    return SingleChildScrollView(
      padding:  EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildDatePicker(startDate, () => _selectDate(context, true))),
               SizedBox(width: 16),
              Expanded(child: _buildDatePicker(endDate, () => _selectDate(context, false))),
            ],
          ),
           SizedBox(height: 20),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding:  EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildInfoRow('Số tiền giới hạn:', "${spendingLimit.toStringAsFixed(0)} VND"),
                   Divider(),
                  _buildInfoRow('Số tiền đã tiêu:', "${totalExpense.toStringAsFixed(0)} VND"),
                   Divider(),
                  _buildInfoRow('Số tiền còn lại:', "${remaining.toStringAsFixed(0)} VND"),
                   Divider(),
                  _buildInfoRow('Vượt ngân sách:', "${exceeded.toStringAsFixed(0)} VND", highlight: exceeded > 0),
                ],
              ),
            ),
          ),
           SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) =>  HistoryScreen()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyanAccent,
              foregroundColor: Colors.black,
              padding:  EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            icon:  Icon(Icons.history),
            label:  Text("Xem lịch sử", style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker(DateTime date, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:  EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow:  [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Center(
          child: Text("${date.day}-${date.month}-${date.year}",
              style:  TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, {bool highlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style:  TextStyle(fontSize: 16)),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: highlight ? Colors.red : Colors.black,
          ),
        ),
      ],
    );
  }
}
