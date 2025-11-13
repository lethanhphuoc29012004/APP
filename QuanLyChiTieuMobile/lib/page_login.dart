import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


import 'page_home.dart';
import 'page_register.dart';

class LoginScreen extends StatefulWidget {
   const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true; // Trạng thái ẩn/hiện mật khẩu
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  // Hàm đăng nhập
  Future<void> _signIn() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Vui lòng nhập đầy đủ thông tin';
      });
      return;
    }

    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        setState(() {
          _errorMessage = 'Đăng nhập không thành công, vui lòng kiểm tra lại thông tin';
        });
      } else {
        // Nếu đăng nhập thành công, chuyển đến trang chủ
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  HomeScreen()),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Đăng nhập không thành công, vui lòng thử lại: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration:  BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.greenAccent, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding:  EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            children: [
               SizedBox(height: 80),

              // Logo
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/logo.png'), // Thay thế đúng đường dẫn
              ),
               SizedBox(height: 40),

              // Email
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  prefixIcon:  Icon(Icons.person),
                  hintText: 'Email',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
               SizedBox(height: 20),

              // Password
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  prefixIcon:  Icon(Icons.lock),
                  hintText: 'Mật khẩu',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
               SizedBox(height: 10),

              // Hiển thị lỗi nếu có
              if (_errorMessage != null)
                Padding(
                  padding:  EdgeInsets.all(8.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),

               SizedBox(height: 20),

              // Đăng nhập button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _signIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child:  Text(
                    'ĐĂNG NHẬP',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),

               SizedBox(height: 20),

              // Đăng ký link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text('Chưa có tài khoản? '),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) =>  RegisterScreen()),
                      );
                    },
                    child:  Text('Đăng ký'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
