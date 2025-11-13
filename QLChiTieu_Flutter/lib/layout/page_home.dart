import 'package:flutter/material.dart';
import 'package:thanhphuoc_flutter/json/page_albums.dart';
import 'package:thanhphuoc_flutter/layout/page_auth_user.dart';
import 'package:thanhphuoc_flutter/layout/page_cm.dart';
import 'package:thanhphuoc_flutter/layout/page_getxhome.dart';
import 'package:thanhphuoc_flutter/layout/page_gridview.dart';
import 'package:thanhphuoc_flutter/layout/page_monhoc.dart';
import 'package:thanhphuoc_flutter/layout/page_profile.dart';
import 'package:thanhphuoc_flutter/layout/pagedoidonvi.dart';
import 'package:thanhphuoc_flutter/main.dart';

import '../app_state/app_getx.dart';
import '../app_state/getx_counter.dart';
import '../app_state/getx_simple_state.dart';
import '../commercial_app/admin_pages/fruits_page_admin.dart';
import '../commercial_app/app_fruit_store.dart';
import '../commercial_app/controllers/rss_controller.dart';
import '../commercial_app/model/page_fruit_stream.dart';
import '../getx_app/GetxMyApp.dart';
import '../local_storage/page_get_storage.dart';
import '../page/page_rss.dart';
import '../permission/page_callphone.dart';
import '../permission/page_permission.dart';




class PageHome extends StatelessWidget {
  const PageHome({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("My Apps"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
          child: Center(
            child: Column(
            children: [

              buildButton(context,title: "My profile", destination: PageMyProfile()),
              buildButton(context,title: "My PageGridview", destination: PageGridview()),
              buildButton(context,title: "My PageCounterGetX", destination: PageCounterGetX()),

              buildButton(context,title: "My PageCounterSimple", destination: PageCounterSimple()),
              buildButton(context,title: "My Getxmyapp", destination: Getxmyapp()),
              buildButton(context,title: "My PageGetxhome", destination: PageGetxhome()),
              buildButton(context,title: "My AppGetX", destination: AppGetX()),
              buildButton(context,title: "My PageAlbums", destination: PageAlbums()),
              buildButton(context,title: "My PageStudent", destination: PageStudent()),
              buildButton(context,title: "My PageCalculator", destination: MyPageCalculator()),
              buildButton(context,title: "My PageRSS", destination: PageRss()),
              buildButton(context,title: "My PageFruitStream", destination: PageFruitStream()),
              buildButton(context,title: "My PageRequestPermission", destination: PageRequestPermission()),
              buildButton(context,title: "My PageGetStorage", destination: PageGetStorage()),
              buildButton(context,title: "My PageCallPhone", destination: PageCallPhone()),
              buildButton(context,title: "My PageFruitsAdmin", destination: PageFruitsAdmin()),
              buildButton(context, title: "Page Login", destination: PageAuthUser()),

            ]
                    ),
          ),
      ),
    );
  }

  Container buildButton(BuildContext context,{required String title, required Widget destination}) {
    return Container(
      width: MediaQuery.of(context).size.width*2/3,
      child: ElevatedButton(onPressed: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)
        => destination));
      },
          child: Text(title)
      ),
    );
  }
}

