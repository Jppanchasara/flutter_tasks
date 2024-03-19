// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorSuccessSnackbar {
  static void show({required String message, bool isError = false}) {
    Get.snackbar(
      isError ? "Error" : "Success",
      message,
      backgroundColor: isError ? Colors.red.withOpacity(0.4) : Colors.green.withOpacity(0.4),
      colorText: Colors.black,
      borderRadius: 10,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 3),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    );
  }
}
