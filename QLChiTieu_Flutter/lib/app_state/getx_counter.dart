import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ControllerCounter extends GetxController{
  final _counter = 0.obs;


  int get counter => _counter.value;

  increment(){
    _counter.value++;

  }

  var count =0;
  static ControllerCounter get() => Get.find();
  void increment01(){
    count ++ ;
    update(["01"]);
  }
}
class BindingAppGetx extends Bindings{

  @override
  void dependencies(){
    Get.lazyPut(() => ControllerCounter(),);
  }
}

class ControllerCounterNext extends GetxController {
  var count =0;

  static ControllerCounterNext get() => Get.find();
  void increment02(){
    count ++ ;
    update(["02"]);
  }
}

class BindingPageNext extends Bindings{

  @override
  void dependencies(){
    Get.put(() => ControllerCounterNext(),permanent: true);
  }
}


class PageCounterGetX extends StatelessWidget {
  PageCounterGetX({super.key});
  final controller = Get.put(ControllerCounter());
  final controller2 = Get.put(ControllerCounter(), tag: "my tag");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Getx Counter"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Text("${controller.counter}",style: TextStyle(fontSize: 20),),),
            GetX<ControllerCounter>(
              tag: "my tag",
              builder:  (controller) => Text
                ("${controller.counter}"),),

            ElevatedButton(
                onPressed: ()
    {
    controller.increment();
    controller2.increment();

    },
                  child: Text
                ("+", style: TextStyle(fontSize: 20),),
            )
          ],
        ),
      ),
    );
  }
}