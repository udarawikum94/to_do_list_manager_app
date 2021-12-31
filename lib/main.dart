import 'package:to_do_list_manager_app/screens/home_screen.dart';
import 'package:flutter/material.dart';

/**
 * @author: udaraw
 * @since: 22/12/2021 11.47PM
 * @version 1.0.0
 */

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter To Do List-(CW 1)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
