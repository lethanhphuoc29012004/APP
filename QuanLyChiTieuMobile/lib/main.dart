import 'package:flutter/material.dart';
import 'home/transaction_provider.dart';
import 'page_login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://kspsvgbzawpbnwjcwbfs.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtzcHN2Z2J6YXdwYm53amN3YmZzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDIzNzYyNzQsImV4cCI6MjA1Nzk1MjI3NH0.mhSBZ0A-IQ5gRMm0tU04nreDszjZ0X0GLM5r0D30N1Q',
  );
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ],
        child: MyApp(),
      ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ứng Dụng Đăng Nhập',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  ReportContent(),
    );
  }
}

class MyHomePage extends StatefulWidget {
   MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child:  Icon(Icons.add),
      ),
    );
  }
}
