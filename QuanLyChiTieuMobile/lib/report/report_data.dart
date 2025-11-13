class ReportData {
  final String label;
  final double income;
  final double expense;

  ReportData({required this.label, required this.income, required this.expense});

  double get profitLoss => income - expense;
}