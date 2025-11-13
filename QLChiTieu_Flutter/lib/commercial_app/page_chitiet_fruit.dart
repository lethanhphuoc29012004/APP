// import 'dart:math';
//
// import 'package:badges/badges.dart' as badges;
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:get/get_state_manager/src/simple/get_state.dart';
// import 'controllers/controller.dart';
// import 'model/model.dart';
//
//
// class PageChitietFruit extends StatelessWidget {
//   PageChitietFruit({super.key,required this.fruit});
//   Fruit fruit;
//   double rating =getRating();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(fruit.ten),
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         actions: [
//           GetBuilder(
//             id: 'gh',
//             init: ControllerFruit.get(),
//             builder: (controller) => badges.Badge(
//               showBadge: controller.slMHGH>0,
//               badgeContent: Text('${controller.slMHGH}',style: TextStyle(color: Colors.white),),
//               child: Icon(Icons.shopping_cart, size: 30,),
//             ),
//           ),
//           SizedBox(width: 20,)
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 width: MediaQuery.of(context).size.width,
//                 child: Image.network(fruit.anh??"Link anh mac dinh",fit: BoxFit.fitWidth,),
//               ),
//               SizedBox(height: 10,),
//               Text(fruit.ten),
//               SizedBox(height: 10,),
//               Row(
//                 children: [
//                   Text("${fruit.gia?? 0} vnd"),
//                   SizedBox(width: 10,),
//                   Text("${(fruit.gia?? 0)*1.2} vnd", style: TextStyle(decoration: TextDecoration.lineThrough),),
//
//
//
//                 ],
//               ),
//               SizedBox(height: 10,),
//               Text("${fruit.moTa??""}"),
//               SizedBox(height: 10,),
//               Row(
//                 children: [
//                   RatingBarIndicator(
//                     rating: rating,
//                     itemBuilder: (context, index) => Icon(
//                       Icons.star,
//                       color: Colors.amber,
//                     ),
//                     itemCount: 5,
//                     itemSize: 30,
//                     direction: Axis.horizontal,
//                   ),
//                   SizedBox(width: 10,),
//                   Text("$rating", style: TextStyle(color: Colors.red),),
//                   SizedBox(width: 10,),
//                   Expanded(child: Text("${Random().nextInt(1000) +1} đánh giá")),
//                 ],
//               )
//             ],
//           ),
//         ),
//
//       ),
//       floatingActionButton: FloatingActionButton(
//           onPressed: (){
//             ControllerFruit.get().themMHGH(fruit);
//             /////
//           },
//         child: Icon(Icons.add_shopping_cart),
//       ),
//     );
//   }
// }
//
// double getRating(){
//   return Random().nextInt(201)/100 + 3;
// }