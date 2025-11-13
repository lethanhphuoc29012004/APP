import 'package:flutter/material.dart';
import 'package:thanhphuoc_flutter/commercial_app/model/model.dart';

class PageFruitStream extends StatelessWidget {
  const PageFruitStream({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fruit Stream"),
      ),
      body: StreamBuilder<List<Fruit>>(
        stream: FruitSnapshot.getFruitStream(),
        builder: (context, snapshot) {
          if(snapshot.hasError){
            print(snapshot.error.toString());
            return Center(child: Text("Lỗi"),);
          }
          if(!snapshot.hasData){
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text("Xe dap oi")
                ],
              ),
            );
          }
          var fruits = snapshot.data!;
          return GridView.extent(
              maxCrossAxisExtent: 300,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              childAspectRatio: 0.75,
              children: fruits.map(
                    (e) =>  Column(
                  children: [
                    Expanded(
                      child: Container(
                        child: Image.network(e.anh??"Link mac dinh"),
                      ),
                    ),
                    Text(e.ten,style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    Text("${e.gia?? 0} vnd",style: TextStyle(color: Colors.red),),

                  ],
                ),

              ).toList()
          );
        },
      ),
    );
  }
}