import 'package:flutter/material.dart';
import 'package:notes/database_manager.dart';

class AddNotePage extends StatefulWidget{
  final Function onSaved;

  const AddNotePage({super.key, required this.onSaved});
  @override
  State<StatefulWidget> createState() => _AddNotePage();
  

}
class _AddNotePage extends State<AddNotePage>{

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AddNote'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(  
              controller: titleController,        
              decoration: InputDecoration(
                hintText: 'Title',  
                border:OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),             
                ) ,         
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),             
                )
              ),
            ),
            SizedBox(height: 10,),
            TextField( 
              controller: contentController, 
              maxLines: 4,        
              decoration: InputDecoration(
               hintText: 'Content',  
               border:OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),             
               ),
               focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),             
               ),
              ),
            ),
        SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
             onPressed: ()async {

              String title = titleController.text;
              String note = contentController.text;

              if (title.isEmpty){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Title is required."))
                );
                return;
              }
              if (note.isEmpty){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Note is required."))
                );
                return;
              }

              DateTime now = DateTime.now();
              String formattedTime = '${now.hour}:${now.minute}';

              Map<String,dynamic> todo = {
                "title" : title,
                'note': note,
                'time': formattedTime,
              };
             
              int? isSaved = await DatabaseManager.instance.insertTodo(todo);
              print("todo saved in table: $isSaved");
              if (isSaved > 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Todo saved."))
                );
                widget.onSaved();
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Todo not saved."))
                );
              } 
            },
            child: Text("Save"),),        
          SizedBox(width: 50,),
          ElevatedButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text('Cancel')),
         ],)
      ],),
     ),
    );
  }
}