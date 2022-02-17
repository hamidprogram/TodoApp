import 'package:flutter/material.dart';
import 'package:matabapp/context.dart';
import 'package:hive/hive.dart';

import '../BE/tasks.dart';

class todoscreen extends StatelessWidget {
  todoscreen({Key? key, required this.type, required this.index, required this.text}) : super(key: key);

  final String type;
  final int index;
  final String text;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if(type == 'edit'){
      controller.text = text;
    }
    return Scaffold(
      appBar: AppBar(
          backgroundColor: kBackGroundColor,
          elevation: 0,
          title: Text(
            type == 'add'?'Add Todo':'Edit Todo',
            style: const TextStyle(color: kTextColor),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
            color: kTextColor,
          )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(width: 2, color: Colors.grey),
                  ),
                  labelText: 'Add Task content'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                onPress(controller.text);
              },
              child: Text(type == 'add'?'Add Todo':'Edit Todo',style: const TextStyle(color: Colors.white),),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(kPinkColor),
                  fixedSize: MaterialStateProperty.all(
                      const Size(100,40)
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
  void onPress(String title){
    if(type == 'add'){
      add(title);
    }
    else{
      edit(title);
    }
  }
  add(String title)async{
    var box = await Hive.openBox('todo');
    Task task = Task(title,false);
    box.add(task);
    controller.clear();
  }
  edit(String title)async{
    var box = await Hive.openBox('todo');
    Task task = Task(title,false);
    box.putAt(index,task);
  }
}
