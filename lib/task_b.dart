// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, unnecessary_import, file_names

import 'package:flutter/material.dart';
import 'package:flutter_task_main/customWidgets.dart';
import 'package:flutter_task_main/homepage.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskBScreen extends StatefulWidget {
  const TaskBScreen({super.key});

  @override
  State<TaskBScreen> createState() => _TaskBScreenState();
}

class _TaskBScreenState extends State<TaskBScreen> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _skipController = TextEditingController();
  final HistoryController _historyController = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task B'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _inputController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelText: 'Enter Paragraph',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _skipController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Skip Number (N)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            customWidgets(
              ontap: () {
                if (_inputController.value.text.isEmpty) {
                  ErrorSuccessSnackbar.show(
                    message: "Please enter paragraph",
                    isError: true,
                  );
                } else if (_skipController.value.text.isEmpty) {
                  ErrorSuccessSnackbar.show(
                    message: "Please enter skip number",
                    isError: true,
                  );
                } else if (_skipController.value.text.isEmpty &&
                    _inputController.value.text.isEmpty) {
                  ErrorSuccessSnackbar.show(
                    message: "Please enter input value",
                    isError: true,
                  );
                } else {
                  String input = _inputController.text;
                  int skipNumber = int.tryParse(_skipController.text) ?? 0;
                  String output = reverseSentences(input, skipNumber);
                  _historyController.addToHistory(input, output);
                  _inputController.clear();
                  _skipController.clear();
                  ErrorSuccessSnackbar.show(
                    message: output,
                    isError: false,
                  );
                }
              },
              title: "Reverse Sentences",
            ),
            SizedBox(height: 16.0),
            Obx(() {
              return Expanded(
                child: ListView.builder(
                  itemCount: _historyController.taskBhistory.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_historyController.taskBhistory[index]),
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

  String reverseSentences(String paragraph, int skipNumber) {
    List<String> sentences = paragraph.split('. ');
    List<String> reversedSentences = [];

    for (String sentence in sentences) {
      List<String> words = sentence.split(' ');
      if (words.length > skipNumber) {
        List<String> reversedWords =
            words.sublist(0, words.length - skipNumber).reversed.toList();
        reversedWords.addAll(words.sublist(words.length - skipNumber));
        reversedSentences.add(reversedWords.join(' '));
      } else {
        reversedSentences.add(sentence);
      }
    }

    return reversedSentences.join('. ');
  }
}

class HistoryController extends GetxController {
  RxList<String> taskBhistory = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  void loadHistory() async {
    SharedPreferences taskc = await SharedPreferences.getInstance();
    List<String>? savedHistory = taskc.getStringList('taskBhistory');
    if (savedHistory != null) {
      taskBhistory.value = savedHistory;
    }
  }

  void addToHistory(String input, String output) async {
    taskBhistory.insert(0, 'Input: $input  \nOutput: $output');
    SharedPreferences taskc = await SharedPreferences.getInstance();
    await taskc.setStringList('taskBhistory', taskBhistory.toList());
  }
}
