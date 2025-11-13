import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Getxmyapp extends StatelessWidget {
  const Getxmyapp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "My Getx App",
      home: PageGetxHome(),
    );
  }
}

class PageGetxHome extends StatelessWidget {
  const PageGetxHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Getx Home"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () async{
                  var data= await Get.to(PageGoBack());
                  log(data);
                },
                child: Text("Get to")
            ),
            ElevatedButton(
                onPressed: () async{
                  var data= await Get.to(PageGoBack());
                  log(data);
                },
                child: Text("Get off")
            ),
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
        title: Text("Page go back"),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              Get.back();
            },
            child: Text("Go back")
        ),
      ),
    );
  }
}