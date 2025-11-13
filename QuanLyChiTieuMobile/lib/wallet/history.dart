// HistoryScreen.dart
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../Add/add_content.dart';
import '../home/transaction.dart';
import '../home/transaction_provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TransactionProvider>(context, listen: false)
          .fetchTransactionsFromSupabase();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);
    final incomeTransactions =
    provider.transactions.where((tx) => tx.isIncome).toList();
    final expenseTransactions =
    provider.transactions.where((tx) => !tx.isIncome).toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Lịch sử'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
                child: Text('Lịch sử chi',
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            Tab(
                child: Text('Lịch sử thu',
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          ],
        ),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
        controller: _tabController,
        children: [
          _buildTransactionList(expenseTransactions),
          _buildTransactionList(incomeTransactions),
        ],
      ),
    );
  }

  Widget _buildTransactionList(List<Transaction> transactions) {
    if (transactions.isEmpty) {
      return const Center(child: Text('Không có giao dịch'));
    }
    return ListView.separated(
      itemCount: transactions.length,
      separatorBuilder: (context, index) => const Divider(indent: 16, endIndent: 16),
      itemBuilder: (context, index) {
        final tx = transactions[index];
        return ListTile(
          title: Text(tx.category),
          subtitle: Text('${tx.date.day}/${tx.date.month}/${tx.date.year}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${tx.amount.toStringAsFixed(0)} đ'),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.orange),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddContent(transaction: tx),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  await Provider.of<TransactionProvider>(context, listen: false)
                      .deleteTransaction(tx.id);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}