import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UnitConverterScreen(),
    );
  }
}

class UnitConverterScreen extends StatefulWidget {
  @override
  _UnitConverterScreenState createState() => _UnitConverterScreenState();
}

class _UnitConverterScreenState extends State<UnitConverterScreen> {
  final TextEditingController inputController = TextEditingController();
  List<String> conversionResults = [];

  void convertCmToInches() {
    double? cm = double.tryParse(inputController.text);
    if (cm != null) {
      double inches = cm / 2.54;
      setState(() {
        conversionResults.insert(0, "$cm cm = ${inches.toStringAsFixed(3)} inches");
      });
    }
  }

  void convertInchesToCm() {
    double? inches = double.tryParse(inputController.text);
    if (inches != null) {
      double cm = inches * 2.54;
      setState(() {
        conversionResults.insert(0, "$inches inches = ${cm.toStringAsFixed(3)} cm");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Unit Converter")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: inputController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter value",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: convertCmToInches,
                  child: Row(
                    children: [
                      Icon(Icons.arrow_forward),
                      SizedBox(width: 5),
                      Text("CM to Inches"),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: convertInchesToCm,
                  child: Row(
                    children: [
                      Icon(Icons.arrow_back),
                      SizedBox(width: 5),
                      Text("Inches to CM"),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: conversionResults.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(conversionResults[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
