import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'getx_counter.dart';


class AppGetX extends StatelessWidget {
  const AppGetX({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: BindingAppGetx(),
      title: "My GetX App",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,),
      home: PageCounter(),
    );
  }
}
class PageGetxHome extends StatelessWidget {
  const PageGetxHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Page Getx Home"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: () async {
              var data = await Get.to(PageGoBack());
              log(data);
            }, child: Text("Get to")),

            ElevatedButton(onPressed: (){
              Get.off(PageGoBack());
            }, child: Text("Get off")),
          ],
        ),
      ),
    );
  }
}
class PageGoBack extends StatelessWidget {
  const PageGoBack({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Page GoBack"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: ()=> Get.back(
                result: "Bye Bye"
            ), child: Text("Go back")),
          ],
        ),
      ),
    );
  }
}

class PageCounter extends StatelessWidget {
  const PageCounter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Page Counter"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GetBuilder(
                id:"01",
                init: ControllerCounter.get(),
                builder:(controller) => Text("${controller.count}",style: TextStyle(fontSize: 20),)

            ),
            ElevatedButton(onPressed: () {

              ControllerCounter.get().increment01();
            },
                child: Text("Increment")

            ),ElevatedButton(onPressed: () {
              Get.to(PageNext(),binding: BindingPageNext(),);
            },
                child: Text("Next Page")
            ),

          ],
        ),
      ),
    );
  }
}
class PageNext extends StatelessWidget {
  const PageNext({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Page Next"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          children: [
            GetBuilder(
              init: ControllerCounter.get(),
              id: "01",
              builder:(controller) => Text("01:${controller.count}",style: TextStyle(fontSize: 20),),

            ),  GetBuilder(
              init: ControllerCounter.get(),
              id: "02",
              builder:(controller) => Text("02:${controller.count}",style: TextStyle(fontSize: 20),),
            ),
            ElevatedButton(onPressed: () {
              ControllerCounter.get().increment01();
              ControllerCounterNext.get().increment02();
            }, child: Text("Increment"))
          ],
        ),
      ),
    );
  }
}