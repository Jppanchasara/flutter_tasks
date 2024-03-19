// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_task_main/task_a.dart';
import 'package:flutter_task_main/task_b.dart';
import 'package:flutter_task_main/task_c.dart';
import 'package:flutter_task_main/task_d.dart';
import 'package:flutter_task_main/task_e.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Practice"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              customWidgets(
                ontap: () {
                  Get.to(TaskAScreen());
                },
                title: "Task A",
              ),
              customWidgets(
                ontap: () {
                  Get.to(TaskBScreen());
                },
                title: "Task B",
              ),
              customWidgets(
                ontap: () {
                  Get.to(TaskCScreen());
                },
                title: "Task C",
              ),
              customWidgets(
                ontap: () {
                  Get.to(TaskDScreen());
                },
                title: "Task D",
              ),
              customWidgets(
                ontap: () {
                  Get.to(TaskEScreen());
                },
                title: "Task E",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class customWidgets extends StatelessWidget {
  final String title;
  final VoidCallback ontap;
  const customWidgets({
    super.key,
    required this.title,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        height: 55,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: Colors.black),
        clipBehavior: Clip.hardEdge,
        child: Material(
          color: Colors.transparent,
          child: Ink(
            child: InkWell(
              onTap: ontap,
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
