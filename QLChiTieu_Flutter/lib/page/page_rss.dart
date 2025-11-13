import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thanhphuoc_flutter/commercial_app/controllers/rss_controller.dart';
import 'package:thanhphuoc_flutter/commercial_app/controllers/rss_resource.dart';
import 'package:thanhphuoc_flutter/commercial_app/model/rss_item.dart';
import 'package:thanhphuoc_flutter/page/page_url.dart';



class PageRss extends StatelessWidget {
  PageRss({super.key});

  final controller = Get.put(RssController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RSS"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          GetBuilder(
            init: controller,
            id: "rss",
            builder: (controller) {
              var data = controller
                  .currentResources[controller.currentResIndex].resourceHeaders;

              return DropdownButton<String>(
                value: controller.currentUrl,
                items: data.keys
                    .map(
                      (k) => DropdownMenuItem<String>(
                      value: data[k], child: Text(k)),
                )
                    .toList(),
                onChanged: (value) =>
                {controller.currentUrl = value, controller.refresh()},
              );
            },
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
      drawer: GetBuilder(
          init: controller,
          id: "rss",
          builder: (controller) => Drawer(
            child: Column(
              children: [
                UserAccountsDrawerHeader(
                    currentAccountPicture: CircleAvatar(
                        child: Text(
                          "AK",
                        )),
                    accountName: Text("Thanh Phước"),
                    accountEmail: Text("phuoc.lt.64cntt@ntu.edu.vn")),
                Text("Chọn nguồn báo"),
                Divider(),
                RadioListTile(
                  title: Text("VN Express"),
                  value: 0,
                  groupValue: controller.currentResIndex,
                  onChanged: (value) async {
                    controller.changeRss(newIndex: value!);
                    Navigator.pop(context);
                  },
                ),
                RadioListTile(
                  title: Text("Tuổi trẻ"),
                  value: 1,
                  groupValue: controller.currentResIndex,
                  onChanged: (value) async {
                    controller.changeRss(newIndex: value!);
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          )),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.refresh();
        },
        child: GetBuilder(
          init: controller,
          id: "rss",
          builder: (controller) => FutureBuilder<List<RssItem>>(
            future: controller.readRss(),
            builder: (context, snapshot) {
              if (snapshot.hasError)
                return Center(
                  child: Text("Loi roi"),
                );

              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );

              List<RssItem> list = snapshot.data!.toList();

              return ListView.separated(
                  itemBuilder: (context, index) {
                    RssItem item = list[index];

                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PageUrl(
                                url: item.link ?? "",
                              ),
                            ));
                          },
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: item.imageUrl == null
                                      ? Center(
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.image,
                                          size: 60,
                                        ),
                                        Text("No Image Available!")
                                      ],
                                    ),
                                  )
                                      : Image.network(item.imageUrl!)),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                    item.title ?? "",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue),
                                  ))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(item.description ?? "")
                      ],
                    );
                  },
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: list.length);
            },
          ),
        ),
      ),
    );
  }
}