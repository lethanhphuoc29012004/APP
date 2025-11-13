// import 'package:get/get.dart';
//
// import '../model/model.dart';
//
//
// class ControllerFruit extends GetxController{
//   // var fruits = <Fruit>[];
//   var _map = <int, Fruit>{};
//   var gh = <GH_Item>[];
//
//   int get slMHGH => gh.length; // khai báo số lượng phần tử có trong giỏ hàng
//
//   static ControllerFruit get()=> Get.find();
//   Iterable<Fruit> get fruits => _map.values;
//
//   @override
//   void onReady() async{
//     // TODO: implement onReady
//     super.onReady();
//     // fruits = FruiSnapshot.getAll();
//     _map = await FruitSnapshot.getMapFruit();
//     update(["fruits"]);
//     FruitSnapshot.listenDataChange(_map, updateUI: () => update(["fruits"]),);
//   }
//
//   themMHGH(Fruit fruit){
//     for(var f in gh){
//       if(f.fruit.id == fruit.id){
//         f.sl++;
//         return;
//       }
//     }
//     gh.add(GH_Item(fruit: fruit, sl: 1));
//     update(["gh"]);
//   }
//
//   void auth(){
//     update(["drawer_header"]);
//   }
//
//   @override
//   void onClose() {
//     super.onClose();
//     FruitSnapshot.unsubriceListenFruitChange();
//   }
// }
//
// class BingdingAppFruitStore extends Bindings{
//
//   @override
//   void dependencies() {
//     Get.lazyPut(() => ControllerFruit(),);
//   }
// }
//
// class GH_Item{
//   fruits fruit;
//   int sl;
//
//   GH_Item({required this.fruit,required this.sl});
// }