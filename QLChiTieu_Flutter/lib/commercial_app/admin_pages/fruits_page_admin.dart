import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:thanhphuoc_flutter/commercial_app/admin_pages/fruit_add_page.dart';
import 'package:thanhphuoc_flutter/commercial_app/model/model.dart';

import 'fruit_update_page.dart';

class PageFruitsAdmin extends StatelessWidget {
  PageFruitsAdmin({super.key});
  late BuildContext myContext; // khi xoá hiển thị bảng thông báo bấm cancel không được nên khai báo

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fruits Admin"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => PageAddFruit()),
              );
            },
            icon: Icon(Icons.add_circle_outline, size: 30),
          ),
        ],
      ),
      body: StreamBuilder<List<Fruit>>(
        stream: FruitSnapshot.getFruitStream(),
        builder: (context, snapshot) {
          var list = snapshot.data! as List<Fruit>;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
              itemBuilder: (context, index) {
                myContext = context;
                Fruit fruit = list[index];
                return Slidable(
                  key: const ValueKey(0),
                  endActionPane: ActionPane(
                    extentRatio: 0.6,
                    motion: ScrollMotion(),
                    children: [
                      SlidableAction(
                        flex: 3,
                        onPressed: (context) {
                          // Chỗ cập nhật
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => PageUpdateFruit(fruit: fruit),)
                          );
                        },
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Cập nhật',
                      ),
                      SlidableAction(
                        flex: 2,
                        onPressed: (context) async {
                          var xacNhan = await showAdaptiveDialog(
                            context: myContext,
                            builder: (context) => AlertDialog(
                              title: Text("Xác nhận"),
                              content: Text("Bạn có muốn xóa ${fruit.ten}?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop('cancel');
                                  },
                                  child: Text("Hủy"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop('ok');
                                  },
                                  child: Text("Đồng ý"),
                                ),
                              ],
                            ),
                          );
                          if (xacNhan == "ok") {
                            await FruitSnapshot.delete(fruit.id);
                            ScaffoldMessenger.of(myContext).clearSnackBars();
                            ScaffoldMessenger.of(myContext).showSnackBar(
                              SnackBar(
                                content: Text("Đã xóa ${fruit.ten}..."),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Xóa',
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Image.network(fruit.anh ?? "link mặc định"),
                      ),
                      SizedBox(width: 10), // đổi height -> width nếu nằm ngang
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${fruit.id}'),
                            Text(
                              fruit.ten,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${fruit.gia}',
                              style: TextStyle(color: Colors.red),
                            ),
                            Text(fruit.moTa ?? ""),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(thickness: 1.5),
              itemCount: list.length,
            ),
          );
        },
      ),
    );
  }
}
