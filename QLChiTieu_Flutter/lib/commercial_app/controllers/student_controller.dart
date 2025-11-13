import 'package:flutter/material.dart';
import 'package:get/get.dart';


class Student {
  String subject;
  String credit;
  String fee;

  Student({
    required this.subject,
    required this.credit,
    required this.fee
  });
}
//tạo controler getx
class StudentController extends GetxController {
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController creditController = TextEditingController();
  final TextEditingController feeController = TextEditingController();
  //3 bộ điều khiển TextEditingController để nhập thông tin.
  final List<Student> students = [];

  void addStudent() {
    var student = Student(
        subject: subjectController.text,
        credit: creditController.text,
        fee: feeController.text
    );

    students.add(student);//them
    update();//cap nhat
  }
}