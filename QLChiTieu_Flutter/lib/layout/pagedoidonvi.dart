import 'package:flutter/material.dart';

class MyPageCalculator extends StatefulWidget {
  const MyPageCalculator({super.key});

  @override
  State<MyPageCalculator> createState() => _MyPageCalculatorState();
}

class _MyPageCalculatorState extends State<MyPageCalculator> {
  final TextEditingController centimetController = TextEditingController();
  final TextEditingController inchController = TextEditingController();
  final List<String> result = [];

  void inchToCentimet() {
    double inch = double.tryParse(inchController.text) ?? 0;
    double centimet = inch * 2.54;

    setState(() {
      centimetController.text = centimet.toStringAsFixed(2);
      result.insert(0,"${inch.toStringAsFixed(1)} inches = ${centimet.toStringAsFixed(2)} cm");
    });
  }

  void centimetToInch() {
    double centimet = double.tryParse(centimetController.text) ?? 0;
    double inch = centimet / 2.54;

    setState(() {
      inchController.text = inch.toStringAsFixed(2);
      result.insert(0,"${centimet.toStringAsFixed(1)} cm = ${inch.toStringAsFixed(3)} inches");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LPT"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Centimet:"),
                      TextField(
                        controller: centimetController,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {

                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      IconButton(
                          onPressed: () {
                            inchToCentimet();
                          },
                          icon: Icon(Icons.arrow_back, size: 30)),
                      IconButton(
                          onPressed: () {
                            centimetToInch();
                          },
                          icon: Icon(Icons.arrow_forward, size: 30)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Inch:"),
                      TextField(
                        controller: inchController,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
            Row(
              children: [
                Text("Kết quả tính toán:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(result[index]),
                      );
                    },
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: result.length)
            )
          ],
        ),
      ),
    );
  }
}