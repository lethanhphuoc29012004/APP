import 'package:flutter/material.dart';
import 'package:thanhphuoc_flutter/commercial_app/model/model.dart';

class PageChiTiet extends StatelessWidget {
  const PageChiTiet ({super.key, required Fruit Fruit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chi tiet"),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: (){
              Navigator.of(context).pop
                ("Bye Bye");
            },
            child: Text("Go back")
        ),
      ),
    );
  }
}