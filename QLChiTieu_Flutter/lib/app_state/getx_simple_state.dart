import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ControllerGetXSimple extends GetxController{
  int count=0;


  increment01()
  {
    count++;
    update(["01"], count<=1000);
  }
  increment02()
  {
    count++;
    update(["02"]);
  }

  incrementAll()
  {
    count++;
    update(["01","02"]);//co the ko can phan[] no cung tang all
  }
}

class PageCounterSimple  extends StatelessWidget {
   PageCounterSimple ({super.key});
  final controller = Get.put(ControllerGetXSimple());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GetX Simple Counter"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GetBuilder(
              id:"01",
              init: controller,
              builder: (controller)=>Text("01: ${controller.count}",style: TextStyle(fontSize: 20),),
            ),

            GetBuilder<ControllerGetXSimple>(//co ControllerGetXSimple cung duoc
              id:"02",
              init: controller,
              builder: (controller)=>Text("02: ${controller.count}",style: TextStyle(fontSize: 20),),
            ),

            ElevatedButton(
                onPressed:(){
                  controller.increment01();
                },
                child: Text("Inc 01")
            ),
            ElevatedButton(
                onPressed:(){
                  controller.increment02();
                },
                child: Text("Inc 02")
            ),
            ElevatedButton(
                onPressed:(){
                  controller.incrementAll();
                },
                child: Text("Inc all")
            ),
            ElevatedButton(
                onPressed: (){
                  //setState();
                },
                child: Text("Call build method")
            ),
          ],
        ),
      ),
    );
  }
}
