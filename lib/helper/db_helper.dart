import 'package:budget_tracker/model/category_model.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

import '../model/spending_model.dart';

class DBHelper {
  DBHelper._();
  static DBHelper dbHelper = DBHelper._();

  Database? db;

  String categoryTable = 'category';
  String categoryName = 'category_name';
  String categoryImage = 'category_image';
  String imageId = 'category_image_id';

  String spendingTable = 'spending';
  String spendingId = 'spending_id';
  String spendingAmount = 'spending_amount';
  String spendingDate = 'spending_date';
  String spendingDesc = "spending_desc";
  String spendingMode = "spending_mode";
  String spendingCategory = 'spending_category_id';

  Future<void> initDB() async {
    String dbPath = await getDatabasesPath();
    String path = '$dbPath/budget.db';

    db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, _) {
        String query = ''' CREATE TABLE $categoryTable(
          category_id INTEGER PRIMARY KEY AUTOINCREMENT,
          $categoryName TEXT NOT NULL,
          $categoryImage BLOB NOT NULL,
          $imageId INTEGER NOT NULL
        );''';

        db
            .execute(query)
            .then(
              (value) => print("1 Table Create"),
        )
            .onError((error, _) => print(error.toString()));

        String query2 = '''CREATE TABLE $spendingTable(
          $spendingId INTEGER PRIMARY KEY AUTOINCREMENT,
          $spendingAmount NUMERIC NOT NULL,
          $spendingDate TEXT NOT NULL,
          $spendingDesc TEXT NOT NULL,
          $spendingMode TEXT NOT NULL,
          $spendingCategory INTEGER NOT NULL
        );''';

        db
            .execute(query2)
            .then(
              (value) => print("2 Table Created"),
        )
            .onError((error, _) => print(error.toString()));
      },
    );
  }

  Future<int?> insertCategory({
    required String name,
    required Uint8List image,
    required int imageId,
  }) async {
    if (db == null) await initDB();
    String query =
        "INSERT INTO $categoryTable($categoryName, $categoryImage, ${this.imageId}) VALUES(?, ? , ?);";
    List values = [name, image, imageId];
    try {
      int? result = await db?.rawInsert(query, values);
      print("Insert Success: ID $result");
      return result;
    } catch (e) {
      print("Insert failed: $e");
      return null;
    }
  }

  Future<int?> insertSpendingData({required SpendingModel model}) async {
    if (db == null) await initDB();
    String query =
        "INSERT INTO $spendingTable($spendingAmount, $spendingDate, $spendingDesc, $spendingMode, $spendingCategory) VALUES(?, ?, ?, ?, ?);";
    List values = [
      model.amount,
      model.date,
      model.descripsion,
      model.mode,
      model.categoryId
    ];
    return await db?.rawInsert(query, values);
  }

  Future<List<CategoryModel>> fetchCategoryData() async {
    await initDB();
    String query = "SELECT * FROM $categoryTable";
    List<Map<String, dynamic>> result = await db?.rawQuery(query) ?? [];
    return result
        .map((Map<String, dynamic> e) => CategoryModel.mapToModel(m1: e))
        .toList();
  }

  Future<List<SpendingModel>> fetchSpendingData() async {
    await initDB();
    String query = "SELECT * FROM $spendingTable";
    List<Map<String, dynamic>> result = await db?.rawQuery(query) ?? [];
    return result
        .map((Map<String, dynamic> e) => SpendingModel.mapToModel(m1: e))
        .toList();
  }

  Future<CategoryModel?> getSpendingById({required int id}) async {
    await initDB();
    String query = "SELECT * FROM $categoryTable WHERE category_id = $id;";

    List<Map<String, dynamic>> res = await db?.rawQuery(query) ?? [];

    return CategoryModel(
        id: res[0]['category_id'],
        name: res[0][categoryName],
        image: res[0][categoryImage],
        imageId: res[0][imageId]);
  }

  Future<List<CategoryModel>> searchCategory({required String search}) async {
    await initDB();
    String query =
        "SELECT * FROM $categoryTable WHERE $categoryName LIKE '%$search%'";
    List<Map<String, dynamic>> result = await db?.rawQuery(query) ?? [];
    return result
        .map((Map<String, dynamic> e) => CategoryModel.mapToModel(m1: e))
        .toList();
  }

  Future<int?> updateCategory({
    required CategoryModel model,
  }) async {
    if (db == null) await initDB();
    String query1 =
        "UPDATE $categoryTable SET $categoryName = ?, $categoryImage = ?, $imageId = ? WHERE category_id = ${model.id}";
    List values = [model.name, model.image, model.imageId];
    return await db?.rawUpdate(query1, values);
  }

  Future<int?> updateSpending({
    required SpendingModel model,
  }) async {
    if (db == null) await initDB();
    String query2 =
        "UPDATE $spendingTable SET $spendingAmount = ?, $spendingDate = ?, $spendingDesc = ?, $spendingMode = ? WHERE spending_id = ${model.id}";
    List values = [
      model.amount,
      model.date,
      model.descripsion,
      model.mode,
    ];
    return await db?.rawUpdate(query2, values);
  }

  Future<int?> deleteCategory({required int id}) async {
    if (db == null) await initDB();
    String query = "DELETE FROM $categoryTable WHERE category_id = $id";
    return await db?.rawDelete(query);
  }

  Future<int?> deleteSpending({required int id}) async {
    if (db == null) await initDB();
    String query = "DELETE FROM $spendingTable WHERE spending_id = $id";
    return await db?.rawDelete(query);
  }
}
