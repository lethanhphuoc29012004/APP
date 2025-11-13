import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import '../commercial_app/model/supabase_helper.dart';
import '../diaglog/dialog.dart';

AuthResponse? response;


class PageAuthUser extends StatelessWidget {
  const PageAuthUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: Container(),
              ),
              SupaEmailAuth(
                onSignInComplete: (res) {
                  response = res;
                  Navigator.of(context).pop();
                },
                onSignUpComplete: (response) {
                  if (response.user != null) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PageVerifyOTP(email: response.user!.email!),
                      ),
                    );
                  }
                },
                showConfirmPasswordField: true,
              ),
              Expanded(
                child: Container(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Xác thực mã OTP"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OtpTextField(
            numberOfFields: 6,
            borderColor: Color(0xFF512DA8),
            //set to true to show as box or false to show as dash
            showFieldAsBox: true,
            //runs when a code is typed in
            onCodeChanged: (String code) {
              //handle validation or checks here
            },
            //runs when every textfield is filled
            onSubmit: (String verificationCode) async {
              response = await Supabase.instance.client.auth.verifyOTP(
                email: email,
                token: verificationCode,
                type: OtpType.email,
              );
              if(response?.session != null && response?.user != null){
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => PageThongTinKH()), (route) => false,
                );
              }
            }, // end onSubmit
          ),
          SizedBox(height: 50,),
          ElevatedButton(
            onPressed: () async {
              showSnackBar(context, message: "Đang gửi mã OTP...", seconds: 600);
              final response = await supabase.auth.signInWithOtp(
                email: email,
              );
              showSnackBar(context, message: "Mã OTP đã gửi vào $email của bạn", seconds: 3);
            },
            child: Text("Gửi lại mã OTP"),
          )
        ],
      ),
    );
  }
}

class PageThongTinKH extends StatefulWidget {
  const PageThongTinKH({super.key});

  @override
  State<PageThongTinKH> createState() => _PageThongTinKHState();
}

class _PageThongTinKHState extends State<PageThongTinKH> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thông tin khách hàng"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
    );
  }
}