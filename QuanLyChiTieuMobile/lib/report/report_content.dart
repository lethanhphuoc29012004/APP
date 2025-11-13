import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../home/transaction.dart';
import '../home/transaction_provider.dart';

class ReportContent extends StatefulWidget {
   ReportContent({super.key});

  @override
  State<ReportContent> createState() => _ReportContentState();
}

class _ReportContentState extends State<ReportContent> {
  DateTime? fromDate;
  DateTime? toDate;

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, _) {
        // Lọc theo khoảng ngày
        final filteredTransactions = provider.transactions.where((tx) {
          if (fromDate != null && tx.date.isBefore(fromDate!)) return false;
          if (toDate != null && tx.date.isAfter(toDate!)) return false;
          return true;
        }).toList();

        // Nhóm dữ liệu
        final groupedData = _groupDataByDate(filteredTransactions);

        final totalIncome = filteredTransactions
            .where((tx) => tx.isIncome)
            .fold(0.0, (sum, tx) => sum + tx.amount);

        final totalExpense = filteredTransactions
            .where((tx) => !tx.isIncome)
            .fold(0.0, (sum, tx) => sum + tx.amount);

        final balance = totalIncome - totalExpense;

        final dayCount = groupedData.length;
         double dayWidth = 60;
        final chartWidth = dayCount * dayWidth + 32;

        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            title: Row(
              children:  [
                Icon(Icons.bar_chart_outlined, color: Colors.white, size: 45),
                SizedBox(width: 15),
                Text('Báo cáo theo ngày',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
            backgroundColor: Colors.green,
          ),
          body: Padding(
            padding:  EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildDateFilter(context),
                 SizedBox(height: 10),
                _buildSummaryCard(totalIncome, totalExpense, balance),
                 SizedBox(height: 20),
                 Text(
                  'Biểu đồ Thu & Chi theo ngày',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                 SizedBox(height: 16),
                if (groupedData.isEmpty)
                   Expanded(
                    child: Center(child: Text("Không có dữ liệu để hiển thị.")),
                  )
                else
                  SizedBox(
                    height: 300,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: chartWidth,
                        child: BarChart(
                          BarChartData(
                            maxY: _calculateMaxY(groupedData),
                            barTouchData: BarTouchData(enabled: true),
                            gridData: FlGridData(show: true),
                            borderData: FlBorderData(show: true),
                            alignment: BarChartAlignment.spaceBetween,
                            barGroups: _buildBarGroupsByDate(groupedData),
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 36,
                                  getTitlesWidget: (value, meta) {
                                    final dates = groupedData.keys.toList();
                                    final idx = value.toInt();
                                    if (idx >= 0 && idx < dates.length) {
                                      return Padding(
                                        padding:  EdgeInsets.only(top: 4),
                                        child: Text(
                                          dates[idx],
                                          style:  TextStyle(fontSize: 10),
                                        ),
                                      );
                                    }
                                    return  SizedBox.shrink();
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 56,
                                  getTitlesWidget: (value, meta) {
                                    String formatted;
                                    if (value >= 1000000) {
                                      formatted = '${(value / 1000000).toStringAsFixed(1)}M';
                                    } else if (value >= 1000) {
                                      formatted = '${(value / 1000).toStringAsFixed(1)}K';
                                    } else {
                                      formatted = value.toStringAsFixed(0);
                                    }
                                    return Text(
                                      formatted,
                                      style:  TextStyle(fontSize: 12),
                                    );
                                  },
                                ),
                              ),
                              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                 SizedBox(height: 16),
                _buildLegend(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDateFilter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDatePicker(
          label: "Từ ngày",
          date: fromDate,
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: fromDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            if (picked != null) setState(() => fromDate = picked);
          },
        ),
        _buildDatePicker(
          label: "Đến ngày",
          date: toDate,
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: toDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            if (picked != null) setState(() => toDate = picked);
          },
        ),
        IconButton(
          icon:  Icon(Icons.clear),
          onPressed: () {
            setState(() {
              fromDate = null;
              toDate = null;
            });
          },
        )
      ],
    );
  }

  Widget _buildDatePicker({required String label, DateTime? date, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style:  TextStyle(fontSize: 12)),
          Container(
            padding:  EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              date != null ? DateFormat('dd/MM/yyyy').format(date) : 'Chọn ngày',
              style:  TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, Map<String, double>> _groupDataByDate(List<Transaction> txs) {
    final Map<String, Map<String, double>> data = {};
    for (final tx in txs) {
      final dateKey = DateFormat('dd/MM').format(tx.date);
      data.putIfAbsent(dateKey, () => {'income': 0, 'expense': 0});
      final type = tx.isIncome ? 'income' : 'expense';
      data[dateKey]![type] = data[dateKey]![type]! + tx.amount;
    }
    final sortedEntries = data.entries.toList()
      ..sort((a, b) {
        final da = DateFormat('dd/MM').parse(a.key);
        final db = DateFormat('dd/MM').parse(b.key);
        return da.compareTo(db);
      });
    return {for (var e in sortedEntries) e.key: e.value};
  }

  List<BarChartGroupData> _buildBarGroupsByDate(Map<String, Map<String, double>> data) {
    int idx = 0;
    return data.entries.map((e) {
      final inc = e.value['income']!;
      final exp = e.value['expense']!;
      return BarChartGroupData(
        x: idx++,
        barsSpace: 8,
        barRods: [
          BarChartRodData(toY: inc, width: 12, color: Colors.green, borderRadius: BorderRadius.circular(4)),
          BarChartRodData(toY: exp, width: 12, color: Colors.red, borderRadius: BorderRadius.circular(4)),
        ],
      );
    }).toList();
  }

  double _calculateMaxY(Map<String, Map<String, double>> data) {
    double maxY = 0;
    for (var v in data.values) {
      maxY = [maxY, v['income']!, v['expense']!].reduce((a, b) => a > b ? a : b);
    }
    return maxY * 1.2;
  }

  Widget _buildSummaryCard(double income, double expense, double balance) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding:  EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSummaryRow("Tổng thu:", income, Colors.green),
            _buildSummaryRow("Tổng chi:", expense, Colors.red),
             Divider(),
            _buildSummaryRow("Chênh lệch:", balance, balance >= 0 ? Colors.blue : Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style:  TextStyle(fontSize: 14)),
        Text(
          "${value.toStringAsFixed(0)} đ",
          style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:  [
        _LegendItem(color: Colors.green, label: 'Thu'),
        SizedBox(width: 16),
        _LegendItem(color: Colors.red, label: 'Chi'),
      ],
    );
  }
}
class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

   _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 14, height: 14, color: color),
         SizedBox(width: 4),
        Text(label),
      ],
    );
  }
}
