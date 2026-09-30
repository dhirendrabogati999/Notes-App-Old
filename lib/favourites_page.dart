import 'package:flutter/material.dart';
import 'package:notes/database_manager.dart';
import 'package:notes/models/todo_model.dart';

class FavouritesPage extends StatefulWidget{
  final Function onTapDiscover;

  const FavouritesPage({super.key, required this.onTapDiscover});

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  
  List<Todo> favouriteTodos = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getFavouriteTodos();
  }

  void getFavouriteTodos() async {
    isLoading = true;
    setState(() {});
    favouriteTodos = await DatabaseManager.instance.fetchTodos(favourite: true);
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      backgroundColor: Color.fromARGB(255, 237, 234, 234),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Favourites',
              style: TextStyle(fontSize: 40,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 10,),
            const Text('Refining your most curated thoughts and inspirations.',
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
            ),
            SizedBox(height: 20,),
            Expanded(
              child: isLoading ?
              
              Center(child: CircularProgressIndicator(),) :
              
               favouriteTodos.isEmpty ?
              
               Container(
                padding: EdgeInsets.only(top: 60,left: 60,right: 60),
                height: 400,
                width:double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[350],
                  borderRadius: BorderRadius.circular(25)
                ),             
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.star,color: Colors.blue,size: 30,),
                    ),
                    SizedBox(height: 20,),
                    const Text('No favourite notes yet',
                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10,),
                    const Text('Start curating your thoughts by tapping the star icon on your most important entries.',
                    style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(height: 10,),
                    ElevatedButton(onPressed:(){
                      widget.onTapDiscover();
                    } , child: Text('Discover Notes',style: TextStyle(fontWeight: FontWeight.bold),)
                    )
                ],),
              ) 
              : 
              ListView.builder(
                itemCount: favouriteTodos.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(favouriteTodos[index].title, style: 
                        TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                        Text(favouriteTodos[index].note, style: 
                        TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              child: Icon(Icons.favorite, color: Colors.red),
                              onTap: () async {
                                await DatabaseManager.instance.markFavourite(favouriteTodos[index].id, false);
                                getFavouriteTodos();
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
     );
  }
}
