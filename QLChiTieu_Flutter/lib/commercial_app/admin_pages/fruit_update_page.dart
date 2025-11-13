import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thanhphuoc_flutter/commercial_app/model/model.dart';
import 'package:thanhphuoc_flutter/commercial_app/model/supabase_helper.dart';
import 'package:thanhphuoc_flutter/diaglog/dialog.dart';
import 'package:thanhphuoc_flutter/helpers/permission_grant.dart';


class PageUpdateFruit extends StatefulWidget {
  PageUpdateFruit({super.key, required this.fruit});
  Fruit fruit;

  @override
  State<PageUpdateFruit> createState() => _PageUpdateFruitState();
}

class _PageUpdateFruitState extends State<PageUpdateFruit> {
  TextEditingController txtID = TextEditingController();
  TextEditingController txtTen = TextEditingController();
  TextEditingController txtGia = TextEditingController();
  TextEditingController txtMota = TextEditingController();
  XFile? xFile;
  String? imageUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cập nhật sản phẩm"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                height: 300,
                child: xFile==null ? Image.network(widget.fruit.anh?? "Link mac dinh") :
                Image.file(File(xFile!.path)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: () async{
                        if(await requestPermission(Permission.photos)){
                          var image = await ImagePicker().pickImage(source: ImageSource.gallery);
                          if(image!=null)
                            setState(() {
                              xFile = image;
                            });
                        }
                      },
                      child: Text("Chọn ảnh")
                  ),
                  SizedBox(width: 10,)
                ],
              ),
              TextField(
                readOnly: true,
                controller: txtID,
                decoration: InputDecoration(
                    labelText: "Id"
                ),
                keyboardType: TextInputType.numberWithOptions(
                    decimal: false, signed: false
                ),
              ),
              TextField(
                controller: txtTen,
                decoration: InputDecoration(
                    labelText: "Tên"
                ),
                keyboardType: TextInputType.text,
              ),
              TextField(
                controller: txtGia,
                decoration: InputDecoration(
                    labelText: "Giá"
                ),
                keyboardType: TextInputType.numberWithOptions(
                    decimal: false, signed: false
                ),
              ),
              TextField(
                controller: txtMota,
                decoration: InputDecoration(
                    labelText: "Mô tả"
                ),
                keyboardType: TextInputType.text,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        //Thông báo đang cập nhật
                        Fruit fruit = widget.fruit;
                        showSnackBar(context, message: "Đang cập nhật ${fruit.ten}", seconds: 10);
                        if(xFile != null){
                          //1. Thêm ảnh và lấy đường dẫn
                          imageUrl = await updateImage(
                              image: File(xFile!.path),
                              bucket: "fruit",
                              path: "fruit_${txtID.text}"
                          );
                          fruit.anh = imageUrl;
                        }
                        fruit.ten = txtTen.text;
                        fruit.gia = int.parse(txtGia.text);
                        fruit.moTa = txtMota.text;
                        await FruitSnapshot.update(fruit);
                        //Thông báo đã cập nhật
                        showSnackBar(context, message: "Đã cập nhật ${fruit.ten}");
                      },
                      child: Text("Cập nhật")
                  ),
                  SizedBox(width: 10,)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    txtID.text = widget.fruit.id.toString();
    txtTen.text = widget.fruit.ten;
    txtGia.text = widget.fruit.gia.toString();
    txtMota.text = widget.fruit.moTa?? "";
  }
}