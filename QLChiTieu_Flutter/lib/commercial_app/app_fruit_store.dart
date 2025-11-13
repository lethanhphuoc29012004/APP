// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:badges/badges.dart' as badges;
// import '../layout/page_auth_user.dart';
// import '../layout/page_chi_tiet.dart';
// import 'controllers/controller_fruit_cntt3.dart';
// import 'model/supabase_helper.dart';
//
// class AppFruitStore extends StatelessWidget {
//   const AppFruitStore({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: "Fruit Store",
//       debugShowCheckedModeBanner: false,
//       initialBinding: BingdingAppFruitStore(),
//       home: PageHomeFruitStore(),
//     );
//   }
// }
//
// class PageHomeFruitStore extends StatelessWidget {
//   const PageHomeFruitStore({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Fruit Store"),
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         actions: [
//           GetBuilder(
//             init: ControllerFruit.get(),
//             id: "gh",
//             builder: (controller) => badges.Badge(
//               showBadge: controller.slMHGH > 0, // điều kiện hiển thị số lượng giỏ hàng
//               badgeContent: Text('${controller.slMHGH}',style: TextStyle(color: Colors.white),),
//               child: Icon(Icons.shopping_cart, size: 30,),
//             ),
//           ),
//           SizedBox(width: 20,) // đẩy giỏ hàng qua bên trái
//         ],
//       ),
//       drawer: Drawer(
//         child: ListView(
//           children: [
//             GetBuilder(
//               id: "draw_header",
//               init: ControllerFruit(),
//               builder:(controller) =>  UserAccountsDrawerHeader(
//                   accountName: Text(""),
//                   accountEmail: Text("${response?.user?.email?? " "}")
//               ),
//             ),
//             Column(
//               children: [
//                 IconButton(
//                   onPressed: () {
//                     supabase.auth.signOut();
//                     response = null;
//                     ControllerFruit.get().auth();
//                   },
//                   icon: Icon(Icons.logout),
//                 ),
//                 Text("Đăng xuất khỏi Trái cây")
//               ],
//             )
//           ],
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.only(left: 5, right: 5),
//         child: GetBuilder(
//           init: ControllerFruit.get(),
//           id: "fruits",//Controller phương thức tĩnh
//           builder: (controller) {
//             var fruits = controller.fruits;
//             return GridView.extent(
//               maxCrossAxisExtent: 300,
//               mainAxisSpacing: 5,
//               crossAxisSpacing: 5,
//               childAspectRatio: 0.75,
//               children: fruits.map(
//                     (e) {
//                   return GestureDetector(
//                     onTap: () {
//                       Get.to(PageChiTiet(Fruit: e));
//                     },
//                     child: Column(
//                       children: [
//                         Expanded(
//                           child: Image.network(e.anh??"Link ảnh mặc định"),
//                         ),
//                         Text(e.ten),
//                         Text("${e.gia} vnd", style: TextStyle(color: Colors.red,),)
//                       ],
//                     ),
//                   );
//                 },
//               ).toList(),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//
//
