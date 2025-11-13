import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'page_login.dart';


class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscurePassword = true;
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  Future<void> _signUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final fullName = _nameController.text.trim() + " " + _surnameController.text.trim();
    final phone = _phoneController.text.trim();

    if (email.isEmpty || password.isEmpty || fullName.isEmpty || phone.isEmpty) {
      setState(() {
        _errorMessage = 'Vui lòng điền đầy đủ thông tin';
      });
      return;
    }

    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );

      final user = response.user;

      if (user != null) {
        // Thêm dữ liệu vào bảng "users"
        await Supabase.instance.client.from('users').insert({
          'id': user.id,
          'full_name': fullName,
          'phone': phone,
        });

        // Chuyển sang trang xác thực OTP
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PageVerifyOTP(email: email),
          ),
        );
      } else {
        setState(() {
          _errorMessage = 'Đăng ký không thành công. Vui lòng thử lại.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Đã có lỗi xảy ra, vui lòng thử lại: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng ký'),
        backgroundColor: Colors.greenAccent,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.greenAccent, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30),
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/logo.png'),
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Họ và tên đệm',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: _surnameController,
                      decoration: InputDecoration(
                        hintText: 'Tên',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Số điện thoại',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
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
              Text(
                'Nếu bấm vào nút đăng ký, bạn đã đồng ý với Thỏa thuận phần mềm và Chính sách quyền riêng tư.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
              if (_errorMessage != null)
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: _signUp,
                  child: Text(
                    'ĐĂNG KÝ',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Đã có tài khoản? '),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text('Đăng nhập'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PageVerifyOTP extends StatelessWidget {
  final String email;
  PageVerifyOTP({super.key, required this.email});

  void showSnackBar(BuildContext context,
      {required String message, int seconds = 3}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: seconds)),
    );
  }

  Future<void> _verifyOTP(BuildContext context, String verificationCode) async {
    try {
      final response = await Supabase.instance.client.auth.verifyOTP(
        email: email,
        token: verificationCode,
        type: OtpType.email,
      );

      if (response.session != null && response.user != null) {
        showSnackBar(context, message: 'Xác thực OTP thành công!');
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()), // hoặc PageThongTinKH()
              (route) => false,
        );
      } else {
        showSnackBar(context, message: 'Xác thực thất bại, vui lòng thử lại.');
      }
    } catch (e) {
      showSnackBar(
          context, message: 'Lỗi khi xác thực OTP: ${e.toString()}');
    }
  }

  Future<void> _resendOTP(BuildContext context) async {
    try {
      showSnackBar(context, message: "Đang gửi mã OTP...", seconds: 600);
      await Supabase.instance.client.auth.signInWithOtp(email: email);
      showSnackBar(context,
          message: "Mã OTP đã gửi vào email $email của bạn", seconds: 3);
    } catch (e) {
      showSnackBar(context,
          message: "Gửi lại mã OTP thất bại: ${e.toString()}", seconds: 3);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Xác thực mã OTP"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Vui lòng nhập mã OTP đã được gửi đến email $email',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            OtpTextField(
              numberOfFields: 6,
              borderColor: Color(0xFF512DA8),
              showFieldAsBox: true,
              fieldWidth: 40,
              onCodeChanged: (String code) {

              },
              onSubmit: (String verificationCode) {
                _verifyOTP(context, verificationCode);
              },
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _resendOTP(context),
              child: Text("Gửi lại mã OTP"),
            )
          ],
        ),
      ),
    );
  }
}
