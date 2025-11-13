import 'package:flutter/material.dart';

class PageMyProfile extends StatefulWidget {
  const PageMyProfile ({super.key});

  @override
  State<PageMyProfile> createState() => _PageMyProfileState();
}

class _PageMyProfileState extends State<PageMyProfile> {
  DateTime ngaySinh = DateTime(2004, 4, 9);
  String? gioiTinh = "Nam";
  int index=0;
  List<String> nnlts= ["Tiếng Việt", "JAVA", "C#", "C/C++", "Python", "TypeScript","Khác"];
  String? nnlt = "JAVA";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Profile"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _buildBody(index),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
                accountName: Text("Le Thanh Phuoc"),
                accountEmail: Text("phuoc.lt@gmail.com"),
               currentAccountPicture: CircleAvatar(
                 backgroundImage: AssetImage("asset/images/R.jpg"),
               ),
            ),
            ListTile(
              leading: Icon(Icons.sms),
              title: Text("SMS"),
              trailing: Text("10"),
              onTap: (){
                Navigator.of(context).pop();
                setState(() {
                  index=1;
                });
              },
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
         unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.red,
      items:[
        BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home)),
        BottomNavigationBarItem(
            label: "SMS",
            icon: Icon(Icons.sms,color: Colors.orange,)),
        BottomNavigationBarItem(
            label: "Phone",
            icon: Icon(Icons.phone,color: Colors.green,)),
        ],
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
       ),

    );
  }
  Widget _buildHome(){
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width*3/4,
                child: Image.asset("asset/images/R.jpg"),
              ),
            ),
            SizedBox(height: 15,),
            Text("Họ và Tên:"),
            Text("Le Thanh Phuoc",style: TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.bold),),
            SizedBox(height: 15,),
            Text("Ngày sinh:"),
            Row(
              children: [
                Expanded(child: Text("${ngaySinh.day}/${ngaySinh.month}/${ngaySinh.year}",style: TextStyle(fontSize: 16),)),
                IconButton(
                    onPressed: () async{
                      DateTime? selectedDate = await
                      showDatePicker(
                          initialDate: ngaySinh,
                          context: context,
                          firstDate: DateTime(1990),
                          lastDate: DateTime(2040)
                      );
                      if(selectedDate!=null){
                        setState(() {
                          ngaySinh = selectedDate;
                        });
                      }
                    },
                    icon: Icon(Icons.calendar_month)
                ),
                SizedBox(width: 20,)
              ],
            ),
            SizedBox(height: 15,),
            Text("Giới Tính:"),
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    title: Text("Nam"),
                    value: "Nam", //gia tri Cố định, khi value = groupvalue thì Radio này sẽ được chọn
                    groupValue: gioiTinh,
                    onChanged: (value) {
                      setState(() {
                        gioiTinh = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: Text("Nữ"),
                    value: "Nu", //gia tri Cố định, khi value = groupvalue thì Radio này sẽ được chọn
                    groupValue: gioiTinh,
                    onChanged: (value) {
                      setState(() {
                        gioiTinh = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 15,),
            Text("Sở thích"),
            Text("Xem phim, nghe nhac, ngu nuong, kho noi",style: TextStyle(fontStyle: FontStyle.italic),),
            SizedBox(height: 15,),
            Text("Ngôn ngữ lập trình giỏi nhất của bạn:"),
            DropdownButton<String>(
                value: nnlt,
                items: nnlts.map(
                      (e){
                        return DropdownMenuItem<String>(
                        value: e,//Không thay đổi,
                        child: Text(e)
                        );
                        },
                        ).toList(),
                        onChanged: (value) {
                        setState(() {
                        nnlt=value;
                        });
                        },
                        ),


          ],
        ),
      ),
    );
  }
  Widget _buildSMS(){
    return Center(child: Text("SMS",style: TextStyle(fontSize: 20),),);
  }
  Widget _buildPhone(){
    return Center(child: Text("Phone",style: TextStyle(fontSize: 20),),);
  }
  Widget _buildBody(int index){
    switch(index){
      case 0: return _buildHome();
      case 1: return _buildSMS();
      case 2: return _buildPhone();
      default: return _buildHome();
    }
  }

}