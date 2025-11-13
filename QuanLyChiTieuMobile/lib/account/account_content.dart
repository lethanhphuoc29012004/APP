import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../page_login.dart';

class AccountContent extends StatelessWidget {
   AccountContent({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) =>  LoginScreen()),
              (route) => false,
        );
      });
      return  SizedBox.shrink();
    }

    final email = user.email ?? '';
    final displayName = email.contains('@') ? email.split('@')[0] : email;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Thông tin người dùng
          Container(
            color: Colors.green,
            width: double.infinity,
            padding:  EdgeInsets.all(16),
            child: Row(
              children: [
                 CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Colors.green),
                ),
                 SizedBox(width: 16),
                // Xin chào + tên, khác màu và cỡ nhỏ hơn
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Xin chào ',
                          style:  TextStyle(
                            color: Colors.white,
                            fontSize: 18,      // giảm font
                          ),
                        ),
                        Text(
                          displayName,
                          style:  TextStyle(
                            color: Colors.yellowAccent,
                            fontSize: 18,      // cùng size
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

           SizedBox(height: 16),

          // Các mục trong Account
          Container(
            margin:  EdgeInsets.symmetric(horizontal: 16),
            padding:  EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                AccountItem(
                  icon: Icons.logout,
                  text: 'Logout',
                  iconColor: Colors.red,
                  isLogout: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AccountItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? iconColor;
  final bool isLogout;

   AccountItem({
    super.key,
    required this.icon,
    required this.text,
    this.iconColor,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? Colors.black),
      title: Text(text),
      trailing:  Icon(Icons.arrow_forward_ios),
      onTap: () {
        if (isLogout) {
          Supabase.instance.client.auth.signOut();
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) =>  LoginScreen()),
                (Route<dynamic> route) => false,
          );
        }
      },
    );
  }
}
