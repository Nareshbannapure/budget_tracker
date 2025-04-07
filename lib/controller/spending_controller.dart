import 'package:budget_tracker/helper/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/spending_model.dart';

class SpendingController extends GetxController {
  String? spendingMode;
  DateTime? spendingDate;
  int? spendingIndex;
  int categoryId = 0;
  Future<List<SpendingModel>>? spendingList;

  SpendingController() {
    getSpendingData();
  }

  void setSpendingIndex({required int index, required int id}) {
    spendingIndex = index;
    categoryId = id;
    update();
  }

  void setSpendingMode({String? mode}) {
    spendingMode = mode;
    update();
  }

  void setSpendingDate({required DateTime date}) {
    spendingDate = date;
    update();
  }

  void resetValues() {
    spendingMode = null;
    spendingDate = null;
    spendingIndex = null;
    categoryId = 0;
    update();
  }

  Future<void> addSpendings({required SpendingModel model}) async {
    int? result = await DBHelper.dbHelper.insertSpendingData(model: model);
    if (result != null) {
      Get.snackbar('Adding Spending', 'Spending Add Completed',
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.green);
    } else {
      Get.snackbar('Error', 'failed',
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red);
    }
    update();
  }

  void getSpendingData() {
    spendingList = DBHelper.dbHelper.fetchSpendingData();
    update();
  }

  void updateSpendings({required SpendingModel model}) async {
    int? res = await DBHelper.dbHelper.updateSpending(model: model);
    if (res != null) {
      getSpendingData();
      Get.snackbar('Updating Spending', 'Spending updated Completed',
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.green);
    } else {
      Get.snackbar('Error', 'failed',
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red);
    }
    update();
  }

  Future<void> deleteSpendings({required int id}) async {
    int? res = await DBHelper.dbHelper.deleteSpending(id: id);
    if (res != null) {
      getSpendingData();
      Get.snackbar('Deleting Spending', 'Spending delete Completed',
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.green);
    } else {
      Get.snackbar('Error', 'failed',
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red);
    }
    update();
  }
}