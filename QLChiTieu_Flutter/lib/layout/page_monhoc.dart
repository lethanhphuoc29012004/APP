import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:thanhphuoc_flutter/commercial_app/controllers/student_controller.dart';

class PageStudent extends StatefulWidget {
  const PageStudent({super.key});

  @override
  State<PageStudent> createState() => _PageStudentState();
}

class _PageStudentState extends State<PageStudent> {
  final StudentController studentController = Get.put(StudentController());
//khởi tạo controller ,Dùng Get.put(StudentController()) để đăng ký controller.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Quản lý học sinh"),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            //Người dùng có thể nhập thông tin môn học, số tín chỉ và học phí bằng TextField:
            children: [
              Text("Môn học"),
              TextField(
                controller: studentController.subjectController,
              ),
              SizedBox(height: 30,),
              Text("Số tín chỉ"),
              TextField(
                controller: studentController.creditController,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 30,),
              Text("Học phí̉"),
              TextField(
                controller: studentController.feeController,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        studentController.addStudent();
                      },
                      child: Text("Thêm học sinh mới")
                  )
                ],
              ),
              //danh sách
              //GetBuilder<StudentController>() //cập nhật giao diện mỗi khi danh sách thay đổi.
              //init: studentController, //khởi tạo controller
              //builder: (controller){} //Xây dựng giao diện dựa trên dữ liệu mới
              Expanded(
                child: GetBuilder<StudentController>(
                  init: studentController,//khởi tạo controller
                  builder: (controller) {
                    return ListView.separated(
                        // itemBuilder: (context, index) { ... },   // Xây dựng từng mục

                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Text("${index + 1}"),
                            title: Text(controller.students[index].subject),
                            subtitle: Text("Học phí: " + controller.students[index].fee),
                            trailing: Text("Số tín chỉ: " + controller.students[index].credit),
                          );
                        },
                        // separatorBuilder: (context, index) => Divider(), // Thêm đường kẻ giữa các mục
                        // itemCount: controller.students.length    // Số lượng phần tử
                        separatorBuilder: (context, index) => Divider(),
                        itemCount: controller.students.length
                    );
                  },
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: GetBuilder<StudentController>(
          init: studentController,
          builder: (controller) {
            return Container(
              height: 70,
              padding: EdgeInsets.all(20),
              child: Text("Danh sách có ${controller.students.length} sinh viên"),
            );
          },
        )
    );
  }
}