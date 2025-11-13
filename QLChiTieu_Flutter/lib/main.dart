import 'package:flutter/material.dart';
import 'package:thanhphuoc_flutter/layout/page_home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'layout/page_gridview.dart';


void main() async {
  await Supabase.initialize(
    url: 'https://jugcfubeqqqxcebuscxz.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp1Z2NmdWJlcXFxeGNlYnVzY3h6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDIzNzU3MDMsImV4cCI6MjA1Nzk1MTcwM30.hyVExbiy2L4xQT9tyntPzlwAqOE9MzeLb0o5AdoY9bA',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home:  PageHome(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String message = "Thanh Phuoc";
  TextEditingController txtName= TextEditingController();
  TextEditingController txtDate= TextEditingController();
  String imageURL = "https://i.ytimg.com/vi/yv4SsFK0v5E/sddefault.jpg";


  @override
  void initState(){
    super. initState();
    txtName.text="Thanh Phuoc";
    txtDate.text="8/3/2004";
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
          useMaterial3: true,
        ),
        home: PageGridview()
    );
  }
}


class SanPham{
  String ten;
  int gia;



  SanPham({
    required this.ten,
    required this.gia,
  });
}

var data= [
  SanPham(ten: "Me", gia: 35000),
  SanPham(ten: "Chanh", gia: 31000),
  SanPham(ten: "Xoài", gia: 25000),
  SanPham(ten: "Sơ ri", gia: 27000),
  SanPham(ten: "Chùm ruột", gia: 15000),
  SanPham(ten: "Lê", gia: 55000),
  SanPham(ten: "Thị", gia: 35000),
  SanPham(ten: "Hồng", gia: 37000),
  SanPham(ten: "Đào", gia: 57000),
  SanPham(ten: "Bưởi", gia: 31000),
  SanPham(ten: "Cam", gia: 12000),
  SanPham(ten: "Dâu tây", gia: 50000),
  SanPham(ten: "Chuối", gia: 25000),
  SanPham(ten: "Sầu riêng", gia: 95000),
  SanPham(ten: "Mít", gia: 36000),
  SanPham(ten: "Ổi", gia: 26000),
];
