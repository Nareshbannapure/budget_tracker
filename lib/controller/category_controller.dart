import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../helper/db_helper.dart';
import '../model/category_model.dart';

class CategoryController extends GetxController {
  int? categoryIndex;
  Future<List<CategoryModel>>? categoryList;

  CategoryController() {
    fetchCategory();
  }

  void changeIndex({required int index}) {
    categoryIndex = index;
    update();
  }

  void updateIndex() {
    categoryIndex = null;
    update();
  }

  Future<void> addCategory(
      {required String name, required Uint8List images}) async {
    int? res = await DBHelper.dbHelper
        .insertCategory(name: name, image: images, imageId: categoryIndex!);
    if (res != null) {
      Get.snackbar('Adding Category', ' $name add Completed',
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

  void fetchCategory() async {
    categoryList = DBHelper.dbHelper.fetchCategoryData();
    update();
  }

  void searchCategory({required String search}) async {
    categoryList = DBHelper.dbHelper.searchCategory(search: search);
    update();
  }

  Future<void> updateCategory({required CategoryModel model}) async {
    int? res = await DBHelper.dbHelper.updateCategory(model: model);
    if (res != null) {
      fetchCategory();
      Get.snackbar('Updating Category', 'Category updating Completed',
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

  Future<void> deleteCategory({required int id}) async {
    int? res = await DBHelper.dbHelper.deleteCategory(id: id);
    if (res != null) {
      fetchCategory();
      Get.snackbar('Deleting Category', 'Category delete Completed',
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