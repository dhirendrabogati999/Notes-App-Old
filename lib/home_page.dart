import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notes/addnote_page.dart';
import 'package:notes/database_manager.dart';
import 'package:notes/models/todo_model.dart';

class HomePage extends StatefulWidget{
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  List<Todo> todos = [];

  @override
  void initState() {
    super.initState();
    getTodos();
  }

  void getTodos() async {
    todos = await DatabaseManager.instance.fetchTodos(deleted: false);
   print("todos are : $todos");
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 237, 234, 234),
      floatingActionButton: FloatingActionButton(
      backgroundColor: Colors.blue,
      shape: CircleBorder(),   
      onPressed:(){
       Navigator.push(context, MaterialPageRoute(builder: (context) => AddNotePage(
       onSaved: (){
          getTodos();
        },
      )
    ));
  } ,
  child:Icon(Icons.add,color: Colors.white,) ,
  ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('All Notes',
            style: TextStyle(
              fontSize: 40,fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 10,),
            const Text('Curating your thoughts into clarity',
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
            ),
            SizedBox(height: 20,),
            Expanded(
              child: ListView.builder(
                itemCount: todos.length,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[ 
                      Row(
                        children: [
                          Text(todos[index].title,style: 
                          TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                          Spacer(),
                          Icon(Icons.edit_note_outlined,color: Colors.blue,),
                        ],
                      ),
                    
                      Text(todos[index].note,style: 
                      TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                      SizedBox(height: 10,),
                      Text(todos[index].time,style: 
                      TextStyle(fontSize: 12,fontWeight: FontWeight.w400, color: Colors.grey),),
                      SizedBox(height: 20,),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          child: todos[index].isFavourite ? Icon(Icons.favorite,color: Colors.red,) : Icon(Icons.favorite_border,),
                          onTap: () async {
                            bool currentFav = todos[index].isFavourite;
                            await DatabaseManager.instance.markFavourite(todos[index].id, !currentFav);
                            getTodos(); // Refresh the list
                          },
                        ),
                        SizedBox(width: 20,),
                        InkWell(
                          onTap: () async {
                            await DatabaseManager.instance.markDeleted(todos[index].id, true);
                            getTodos(); // Refresh the list
                          },
                          child: Icon(Icons.delete,color: Colors.red,),
                        ),
                      ],
                    )
                  
                  ]),
                );
              },),
            )
            
          ],
        ),
      ),
    );
  }
}