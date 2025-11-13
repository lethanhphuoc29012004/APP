import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../helpers/permission_grant.dart';

class PageRequestPermission extends StatelessWidget {
  const PageRequestPermission({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Permission Demo"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              String message;
              var statusPermission = await requestPermission(Permission.camera);

              if (statusPermission) {
                message = "Quyền sử dụng camera đã đươc bật";
              } else {
                message = "Quyền sử dụng camera đã bị từ chối";
              }

              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(message),
                duration: Duration(seconds: 2),
              ));
            },
            child: Text("Contact Permission Request")),
      ),
    );
  }
}