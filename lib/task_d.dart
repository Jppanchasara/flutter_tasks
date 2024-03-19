// ignore_for_file: prefer_const_constructors, file_names

import 'package:flutter/material.dart';

class TaskDScreen extends StatelessWidget {
  const TaskDScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task D"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Center(
          child: Text(
            "Task D",
            style:
                TextStyle(fontSize: 32, color: Colors.black45.withOpacity(0.5)),
          ),
        ),
      ),
    );
  }
}
