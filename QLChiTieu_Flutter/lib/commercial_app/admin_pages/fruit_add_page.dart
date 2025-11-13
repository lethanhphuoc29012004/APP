import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thanhphuoc_flutter/commercial_app/model/model.dart';
import 'package:thanhphuoc_flutter/commercial_app/model/supabase_helper.dart';
import 'package:thanhphuoc_flutter/helpers/permission_grant.dart';

class PageAddFruit extends StatefulWidget {
  const PageAddFruit({super.key});

  @override
  State<PageAddFruit> createState() => _PageAddFruitState();
}

class _PageAddFruitState extends State<PageAddFruit> {
  TextEditingController txtID = TextEditingController();
  TextEditingController txtTen = TextEditingController();
  TextEditingController txtGia = TextEditingController();
  TextEditingController txtMota = TextEditingController();
  XFile? _xFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thêm Sản Phẩm"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      // SingleChildScrollView để hiện bàn phím ko bị chèn đẩy mất màn hình theo chiều dọc
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                height: 300,
                child: _xFile == null
                    ? Icon(Icons.image)
                    : Image.file(File(_xFile!.path)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (await requestPermission(Permission.photos)) {
                        var image = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          setState(() {
                            _xFile = image;
                          });
                        }
                      }
                    },
                    child: Text("Chọn ảnh"),
                  ),
                ],
              ),
              TextField(
                controller: txtID,
                decoration: InputDecoration(labelText: "ID"),
                keyboardType: TextInputType.numberWithOptions(
                  decimal: false,
                  signed: false,
                ),
              ),
              TextField(
                controller: txtTen,
                decoration: InputDecoration(labelText: "Tên"),
                keyboardType: TextInputType.numberWithOptions(

                ),
              ),
              TextField(
                controller: txtGia,
                decoration: InputDecoration(labelText: "Giá"),
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                  signed: false,
                ),
              ),
              TextField(
                controller: txtMota,
                decoration: InputDecoration(labelText: "Mô tả"),
                keyboardType: TextInputType.numberWithOptions(

                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_xFile != null) {
                        // Upload ảnh lấy đường dẫn
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Đang thêm... ${txtTen.text}..."),
                          ),
                        );
                        var imageUrl = await uploadImage(
                          image: File(_xFile!.path),
                          bucket: "fruit",
                          path: "fruit_${txtID.text}",
                        );
                        // 2. Tạo đối tượng Fruit
                        Fruit fruit = Fruit(
                          id: int.parse(txtID.text),
                          ten: txtTen.text,
                          gia: int.parse(txtGia.text),
                          moTa: txtMota.text,
                          anh: imageUrl,
                        );
                        // 3. Thêm vào CSDL
                        await FruitSnapshot.insert(fruit);
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Đã thêm ${txtTen.text}..."),
                            duration: Duration(seconds: 3),
                          ),
                        );
                        // Thêm mới Fruit
                      }
                    },
                    child: Text("Thêm"),
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
