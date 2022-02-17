import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:matabapp/BE/tasks.dart';
import 'package:matabapp/context.dart';
import 'package:matabapp/screens/todo_screen.dart';

class MyHomeApp extends StatefulWidget {
  const MyHomeApp({Key? key}) : super(key: key);

  @override
  _MyHomeAppState createState() => _MyHomeAppState();
}

class _MyHomeAppState extends State<MyHomeApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kBackGroundColor,
          elevation: 0,
          title: const Text(
            'ToDo App',
            style: TextStyle(fontSize: 30),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => todoscreen(
                        type: 'add',
                        index: -1,
                        text: '',
                      )),
            );
          },
          child: const Icon(
            Icons.add_task_outlined,
            color: Colors.white,
          ),
          backgroundColor: kPinkColor,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                "ToDay's Task",
                style: TextStyle(color: kTextColor),
              ),
              const SizedBox(
                height: 10,
              ),
              FutureBuilder(
                future: Hive.openBox('todo'),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    return todoList();
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )
            ],
          ),
        ));
  }

  Widget todoList() {
    Box todoBox = Hive.box('todo');
    return ValueListenableBuilder(
        valueListenable: todoBox.listenable(),
        builder: (context, Box box, child) {
          if (box.values.isEmpty) {
            return const Center(
                child: Text(
              'No Task',
              style: TextStyle(color: Colors.white),
            ));
          } else {
            return SizedBox(
              height: 400,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: todoBox.length,
                itemBuilder: (context, index) {
                  final Task task = box.getAt(index);
                  return GestureDetector(
                    onTap: () {
                      if (task.isdo == false) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => todoscreen(
                                      type: 'edit',
                                      index: index,
                                      text: task.tasktitle,
                                    )));
                      }
                    },
                    child: Card(
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          width: 0,
                        ),
                      ),
                      color: kDarkBlueColor,
                      child: ListTile(
                        leading: IconButton(
                          icon: Icon(
                            task.isdo == false
                                ? Icons.brightness_1_outlined
                                : Icons.check_circle,
                            color: kPinkColor,
                          ),
                          onPressed: () {
                            if (task.isdo == true) {
                              checkButo(false, task.tasktitle, index);
                            } else {
                              checkButo(true, task.tasktitle, index);
                            }
                          },
                        ),
                        title: Text(
                          task.tasktitle,
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            remove(index);
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        });
  }

  checkButo(bool pros, String title, int index) {
    if (pros == false) {
      var box = Hive.box('todo');
      Task task = Task(title, false);
      box.putAt(index, task);
    } else {
      var box = Hive.box('todo');
      Task task = Task(title, true);
      box.putAt(index, task);
    }
  }

  void remove(int index) {
    var box = Hive.box('todo');
    box.deleteAt(index);
  }
}
