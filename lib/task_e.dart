// ignore_for_file: prefer_const_constructors, unnecessary_import, prefer_interpolation_to_compose_strings, unnecessary_string_interpolations, unnecessary_null_comparison, file_names

import 'package:flutter/material.dart';
import 'package:flutter_task_main/customWidgets.dart';
import 'package:flutter_task_main/homepage.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:number_to_words/number_to_words.dart';

class TaskEScreen extends StatefulWidget {
  const TaskEScreen({super.key});

  @override
  State<TaskEScreen> createState() => _TaskAScreenState();
}

class _TaskAScreenState extends State<TaskEScreen> {
  final CurrencyController controller = Get.put(CurrencyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task E'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: controller.inputController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter amount',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            customWidgets(
              ontap: () {
                if (controller.inputController.value.text.isEmpty) {
                  ErrorSuccessSnackbar.show(
                    isError: true,
                    message: "Please enter input value",
                  );
                } else {
                  controller.convertToCurrencyInWords(
                      double.tryParse(controller.inputController.text) ?? 0);
                }
              },
              title: "Convert",
            ),
            SizedBox(height: 20),
            Obx(() => Text('Output: ${controller.output}')),
            SizedBox(height: 20),
            Container(
                height: 55,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black)),
                child: Center(
                    child: Text(
                  'History',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.black),
                ))),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: controller.taskEhistory.length,
                  itemBuilder: (context, index) {
                    String total = controller.taskEhistory[index];

                    return ListTile(
                      title: Text(
                        total.split("=")[0].trim(),
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        total.split("=")[1].trim(),
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CurrencyController extends GetxController {
  TextEditingController inputController = TextEditingController();
  RxString output = ''.obs;
  RxList<String> taskEhistory = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  void loadHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    taskEhistory.addAll(prefs.getStringList('taskEhistory') ?? []);
  }

  void saveHistory(String input, String output) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    taskEhistory.insert(0, '$input = $output');
    prefs.setStringList('taskEhistory', taskEhistory.toList());
  }

  void convertToCurrencyInWords(double amount) {
    String result = '';
    if (amount == null) {
      output.value = '';
      return;
    }

    int paise = ((amount - amount.floor()) * 100).toInt();
    if (paise > 0) {
      result += ' ${_convertToWords(paise)} Paise';
    }

    int rupees = amount.floor();
    if (rupees > 0) {
      result = _convertToWords(rupees) +
          ' Indian Rupees' +
          (paise > 0 ? ' and ' : '') +
          result;
    }

    output.value = result;
    saveHistory(inputController.text, output.value);
  }

  String _convertToWords(int number) {
    String words = '';
    if (number >= 1000000000) {
      words += '${convertToWords(number ~/ 1000000000)} Billion ';
      number %= 1000000000;
    }
    if (number >= 10000000) {
      words += '${convertToWords(number ~/ 10000000)} Crore ';
      number %= 10000000;
    }
    if (number >= 100000) {
      words += '${convertToWords(number ~/ 100000)} Lakh ';
      number %= 100000;
    }
    if (number >= 1000) {
      words += '${convertToWords(number ~/ 1000)} Thousand ';
      number %= 1000;
    }
    if (number > 0) {
      words += '${convertToWords(number)}';
    }
    return words.trim();
  }

  String convertToWords(int number) {
    return NumberToWord().convert("en-in", number);
  }
}
