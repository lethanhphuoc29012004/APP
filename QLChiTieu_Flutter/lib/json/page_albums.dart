import 'package:flutter/material.dart';

import 'jsondata.dart';

class PageAlbums extends StatelessWidget {
  const PageAlbums({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: Text("Json Album"),
        backgroundColor: Theme.of(context).colorScheme.inverseSurface,
      ),
      body: FutureBuilder <List<Album>>(
          future: docDL(),
          builder: (context,snapshot){
            if(snapshot.hasError){
              print(snapshot.error);
              return Center(
                child: Text("Loi roi",style: TextStyle(color:Colors.red),),
              );
            }
            if(!snapshot.hasData){
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Text("Xe dop oi.."),
                  ],
                ),
              );
            }
            var data= snapshot.data!;
            return ListView.separated(
                itemBuilder: (context,index){
                  Album album = data[index];
                  return ListTile(
                    title: Text(album.title),
                  );
                },
                separatorBuilder: (context, index)=> Divider(),
                itemCount: data.length
            );
          }
      ),
    );
  }
}
