// import 'package:get/get.dart';
// import 'package:hiphuoc/commercial_app/model/model.dart';
//
//
// class ControllerFruit extends GetxController{
//   // var fruits = <Fruit>[];
//   var _map = <int, Fruit>{};
//   var gh = <GH_item>[];
//
//   int get slMHGH => gh.length;
//   static ControllerFruit get()=> Get.find();
//   Iterable<Fruit> get fruits => _map.values;
//   @override
//   void onReady() async{
//     // TODO: implement onReady
//     super.onReady();
//     // fruits = FruitSnapshot.getAll();
//     _map= await FruitSnapshot.getFruit();
//     update(["fruits"]);
//   }
//
//   themMHGH(Fruit f){
//     for(var item in gh){
//       if(item.fruit.id == f.id){
//         item.sl++;
//         return;
//       }
//     }
//     gh.add(GH_item(fruit: f, sl: 1));
//     update(['gh']);
//
//   }
//
// }
//
// class BindingsAppFruitStore extends Bindings{
//
//   @override
//   void dependencies() {
//     Get.lazyPut(() => ControllerFruit(),);
//   }
// }
//
// class GH_item{
//   Fruit fruit;
//   int sl;
//
//   GH_item({required this.fruit, required this.sl});
// }