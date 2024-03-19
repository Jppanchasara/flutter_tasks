// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, file_names

import 'package:flutter/material.dart';
import 'package:flutter_task_main/customWidgets.dart';
import 'package:flutter_task_main/homepage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskCScreen extends StatefulWidget {
  const TaskCScreen({super.key});

  @override
  State<TaskCScreen> createState() => _TaskCScreenState();
}

class _TaskCScreenState extends State<TaskCScreen> {
  final TextEditingController _inputController = TextEditingController();
  final HistoryController _historyController = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task C'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _inputController,
              decoration: InputDecoration(
                labelText: 'Enter Input',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            customWidgets(
              ontap: () {
                if (_inputController.value.text.isEmpty) {
                  ErrorSuccessSnackbar.show(
                    isError: true,
                    message: "Please enter input value",
                  );
                } else {
                  String input = _inputController.text;
                  String output = reverseWords(input);
                  _historyController.addToHistory(input, output);
                  _inputController.clear();
                  ErrorSuccessSnackbar.show(
                    isError: false,
                    message: output,
                  );
                  // Get.snackbar('Output', output,
                  //     snackPosition: SnackPosition.BOTTOM);
                }
              },
              title: "Reverse Words",
            ),
            SizedBox(height: 16.0),
            Obx(() {
              return Expanded(
                child: ListView.builder(
                  itemCount: _historyController.taskChistory.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_historyController.taskChistory[index]),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  String reverseWords(String input) {
    List<String> words = input.split(RegExp(r'\b'));
    List<String> reversedWords = [];

    for (String word in words) {
      if (word.isNotEmpty) {
        String reversedWord = word.endsWith(';')
            ? word.substring(0, word.length - 1).split('').reversed.join('') +
                ';'
            : word.endsWith('.')
                ? word
                        .substring(0, word.length - 1)
                        .split('')
                        .reversed
                        .join('') +
                    '.'
                : word.split('').reversed.join('');
        reversedWords.add(reversedWord);
      }
    }

    return reversedWords.join('');
  }
}

class HistoryController extends GetxController {
  RxList<String> taskChistory = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  void loadHistory() async {
    SharedPreferences taskc = await SharedPreferences.getInstance();
    List<String>? savedHistory = taskc.getStringList('taskChistory');
    if (savedHistory != null) {
      taskChistory.value = savedHistory;
    }
  }

  void addToHistory(String input, String output) async {
    taskChistory.insert(0, 'INPUT: $input  \nOUTPUT: $output');
    SharedPreferences taskc = await SharedPreferences.getInstance();
    await taskc.setStringList('taskChistory', taskChistory.toList());
  }
}
