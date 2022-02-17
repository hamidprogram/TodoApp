import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:matabapp/context.dart';
import 'package:matabapp/screens/home_screen.dart';

import 'BE/tasks.dart';

void main()async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomeApp(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: kBackGroundColor
      ),
    );
  }
}

