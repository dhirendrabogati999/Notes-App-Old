
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notes/database_manager.dart';
import 'package:notes/models/todo_model.dart';

class DeletedPage extends StatefulWidget{
  final Function onTabChange;
  const DeletedPage({super.key, required this.onTabChange});
  
  @override
  State<DeletedPage> createState(){
    return _DeletedPage();
  }
}

class _DeletedPage extends State<DeletedPage>{
  
  List<Todo> deletedTodos = [];
  bool isLoading = false;  
  @override
  void initState() {
    super.initState();
    getDeletedTodos();
  }

  void getDeletedTodos() async {
    isLoading = true;
    setState(() {});
    deletedTodos = await DatabaseManager.instance.fetchTodos(deleted: true);
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 237, 234, 234),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Deleted Notes',
              style: TextStyle(fontSize: 40,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 10,),
            const Text('Items in the trash are automatically removed after 30 days.',
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
            ),
            SizedBox(height: 20,),
            Expanded(
              child: isLoading ?
              
              Center(child: CircularProgressIndicator(),) :
              
               deletedTodos.isEmpty ?
              
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
                      child: Icon(Icons.delete,color: Colors.blue,size: 30,),
                    ),
                    SizedBox(height: 20,),
                    const Text('No Deleted notes yet',
                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10,),
                    const Text('Click on the delete icon to remove unnecessary notes.',
                    style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(height: 10,),
                   ElevatedButton(
                    onPressed: () {
                     widget.onTabChange(0); // Call the onTabChange function with the index of the Home tab
                    },
                    child: const Text('Discover Notes',
                    style: TextStyle(fontWeight: FontWeight.bold),
                 ),)
                ],),
              ) : ListView.builder(
                itemCount: deletedTodos.length,
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
                        Text(deletedTodos[index].title, style: 
                        TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                        Text(deletedTodos[index].note, style: 
                        TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                        SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                              onPressed: () async {
                                await DatabaseManager.instance.markDeleted(deletedTodos[index].id, false);
                                getDeletedTodos();
                              },
                              child: Text('Restore',style: TextStyle(color: Colors.black),),
                            ),
                            SizedBox(width: 10,),
                            OutlinedButton(                              
                              onPressed: () async {
                                showDialog(context: context, builder: (context){
                                  return AlertDialog(
                                    title: Text('Are you sure you want to delete this note permanently?'),
                                    actions: [
                                      ElevatedButton(onPressed: () async{
                                          await DatabaseManager.instance.deleteTodo(deletedTodos[index].id);
                                          getDeletedTodos();                                      
                                        Fluttertoast.showToast(
                                          msg: "Note deleted permanently",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                        );
                                        Navigator.pop(context);
                                      }, child: Text('Delete')),
                                      ElevatedButton(onPressed: () {
                                        Navigator.pop(context);
                                      }, child: Text('Cancel')),                                     
                                    ],
                                  );
                                });
                              
                              },
                              child: Text('Delete Permanently',style: TextStyle(color: Colors.white),),
                              style: OutlinedButton.styleFrom(backgroundColor: Colors.red),
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