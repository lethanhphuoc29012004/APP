import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_transaction.dart';
import 'transaction_provider.dart';

class HomeContent extends StatefulWidget {
   HomeContent({super.key});

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Fetch the monthly statistics as soon as HomeContent is initialized
    final provider = Provider.of<TransactionProvider>(context, listen: false);
    provider.fetchMonthlyStats();

    Future.microtask(() {
      provider.fetchTransactionsFromSupabase();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);
    double tienChi = provider.totalExpense;
    double tienThu = provider.totalIncome;
    double soDu = provider.balance;
    double tileChi = tienThu == 0 ? 0 : tienChi / tienThu;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            // Sau khi chỉnh
            Container(
              color: Colors.green,
              padding:  EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.home, size: 40, color: Colors.green), // đổi thành icon Home
                  ),
                  SizedBox(width: 16),
                  Text(
                    'Trang Chủ',                                             // đổi text
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

             SizedBox(height: 16),

            // Số dư
            Container(
              margin:  EdgeInsets.symmetric(horizontal: 16),
              padding:  EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: Column(
                children: [
                   Text(
                    'Tổng số dư trong tháng:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                   SizedBox(height: 8),
                  Text(
                    '${soDu.toStringAsFixed(0)} VNĐ',
                    style:  TextStyle(fontSize: 25, color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
             SizedBox(height: 10),

            // Tình hình thu chi
            Container(
              margin:  EdgeInsets.symmetric(horizontal: 16),
              padding:  EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Tỉ lệ khoản chi / thu:", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${tienChi.toStringAsFixed(0)}',
                          style:  TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                         TextSpan(
                          text: '/ ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: '${tienThu.toStringAsFixed(0)} ',
                          style:  TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                         TextSpan(
                          text: 'vnđ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                   SizedBox(height: 8),
                  Stack(
                    children: [
                      Container(
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.green[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: tileChi > 1 ? 1 : tileChi,
                        child: Container(
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.red[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
             SizedBox(height: 16),

            // Các hạng mục Thu
             Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Khoản Thu:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
             SizedBox(height: 10),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics:  NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.5,
                children:  [
                  CategoryItem(icon: Icons.card_giftcard, label: 'Cho tặng', isIncome: true),
                  CategoryItem(icon: Icons.percent, label: 'Lãi suất', isIncome: true),
                  CategoryItem(icon: Icons.work, label: 'Làm thêm', isIncome: true),
                  CategoryItem(icon: Icons.trending_up, label: 'Đầu tư', isIncome: true),
                ],
              ),
            ),
             SizedBox(height: 20),

            // Các hạng mục Chi
             Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Khoản Chi:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
             SizedBox(height: 10),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics:  NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.5,
                children:  [
                  CategoryItem(icon: Icons.restaurant, label: 'Ăn uống', isIncome: false),
                  CategoryItem(icon: Icons.shopping_bag, label: 'Mua sắm', isIncome: false),
                  CategoryItem(icon: Icons.house, label: 'Nhà cửa', isIncome: false),
                  CategoryItem(icon: Icons.celebration, label: 'Đám tiệc', isIncome: false),
                ],
              ),
            ),
             SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isIncome;

   CategoryItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.isIncome,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 1,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTransactionScreen(
                category: label,
                isIncome: isIncome,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding:  EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[200],
                child: Icon(icon, size: 24, color: isIncome ? Colors.green : Colors.red),
              ),
               SizedBox(height: 8),
              Text(
                label,
                style:  TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}