// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, unnecessary_import, no_leading_underscores_for_local_identifiers, unnecessary_string_interpolations

import 'dart:convert';
import 'dart:ui';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_task_main/homepage.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskAScreen extends StatelessWidget {
  const TaskAScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.put(UserController());
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Task A'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) return 'Please enter your name';
                    return null;
                  },
                  onChanged: (value) {
                    userController.name.value = value;
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    } else if (!EmailValidator.validate(value)) {
                      return 'Please valid enter your email';
                    }

                    return null;
                  },
                  onChanged: (value) {
                    userController.email.value = value;
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your phone';
                    } else if (value.length <= 9) {
                      return "Please enter your 10-digits number";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    userController.phone.value = value;
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Age',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(2),
                  ],
                  validator: (value) {
                    if (value!.isEmpty) return 'Please enter your age';
                    int? age = int.tryParse(value);
                    if (age == null || age < 18 || age > 25) {
                      return 'Age must be between 18 and 25';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    userController.age.value = int.tryParse(value) ?? 18;
                  },
                ),
                SizedBox(height: 20),
                customWidgets(
                  ontap: () {
                    if (_formKey.currentState!.validate()) {
                      userController._savedata();
                      userController.lisofmap.add({
                        "name": "${userController.name.toString()}",
                        "email": "${userController.email.toString()}",
                        "phone": "${userController.phone.toString()}",
                        "age": "${userController.age.toString()}"
                      });
                      Get.to(SecondPage());
                    }
                  },
                  title: "Submit",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  final UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Record List'),
        centerTitle: true,
      ),
      body: Padding(
          padding: EdgeInsets.all(18.0),
          child: Obx(
            () => Center(
                child: ListView.builder(
              itemCount: userController.lisofmap.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Expanded(
                        child: Text(userController.lisofmap[index]["email"]
                            .toString())),
                    ElevatedButton(
                        onPressed: () {
                          Get.defaultDialog(
                            title: 'View Data',
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Name: ${userController.lisofmap[index]["name"].toString()}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                    'Email: ${userController.lisofmap[index]["email"].toString()}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                                Text(
                                    'Phone: ${userController.lisofmap[index]["phone"].toString()}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                                Text(
                                    'Age: ${userController.lisofmap[index]["age"].toString()}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            confirm: ElevatedButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text('Close'),
                            ),
                          );
                        },
                        child: Text("View Button"))
                  ],
                );
              },
            )),
          )),
    );
  }
}

class UserController extends GetxController {
  List<Map<String, dynamic>> lisofmap = [
    {
      "name": "jayesh",
      "email": "jay@gmail.com",
      "phone": "8989998989",
      "age": "18"
    }
  ];

  void onInit() {
    super.onInit();
    _loadata();
  }

  Future<void> _loadata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? joiningString = prefs.getString("listofMap");
    if (joiningString != null) {
      List<dynamic> jsonLiist = json.decode(joiningString);
      lisofmap = jsonLiist.map((e) => Map<String, dynamic>.from(e)).toList();
    }
  }

  Future<void> _savedata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = json.encode(lisofmap);
    prefs.setString("listofmap", jsonString);
  }

  final RxString name = ''.obs;
  final RxString email = ''.obs;
  final RxString phone = ''.obs;
  final RxInt age = 18.obs;

  // void saveData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('name', name.value);
  //   await prefs.setString('email', email.value);
  //   await prefs.setString('phone', phone.value);
  //   await prefs.setInt('age', age.value);
  // }
}
