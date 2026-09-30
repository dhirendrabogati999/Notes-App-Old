import 'package:flutter/material.dart';
import 'package:notes/database_manager.dart';
import 'package:notes/deleted_page.dart';
import 'package:notes/favourites_page.dart';
import 'package:notes/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseManager.instance.database;
  runApp(FlutterApp());
}

class FlutterApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      debugShowCheckedModeBanner: false,
      home: TabBar(),
    );
  }

}

class TabBar extends StatefulWidget{
  @override
  State<TabBar> createState() => _TabBarState();
}

class _TabBarState extends State<TabBar> {
  int _selecteditem = 0;
  late List _pagesdata;

  @override
  void initState() {
    super.initState();
    _pagesdata = [HomePage(), FavouritesPage(onTapDiscover: onDiscoverTapped), DeletedPage(onTabChange: onItemTapped,)];
  }

  void onDiscoverTapped(){
    setState(() {
     _selecteditem = 0;
    });
  }  

  void onItemTapped(int index) {
  setState(() {
    _selecteditem = index;
  });
}

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(       
        leading: Icon(Icons.menu,color: Colors.blue),
        title: Row(
          children: [
            Text('The Editorial archive',style: TextStyle(color: Colors.blue),),
            Spacer(),
            IconButton(onPressed: (){}, icon: Icon(Icons.search,color: Colors.blue,))
          ],
        ), 
        backgroundColor: Colors.white,      
      ),
      body: _pagesdata[_selecteditem],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home,),label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.star,),label: 'favourites'),
          BottomNavigationBarItem(icon: Icon(Icons.delete,),label: 'Deleted'),
        ],
        currentIndex: _selecteditem,
        onTap: (value){
          setState((){
            _selecteditem = value;               
          });
        },
      ),
    );
  }
}


