import 'package:flutter/services.dart';

class CategoryModel {
  int id;
  String name;
  Uint8List image;
  int imageId;

  CategoryModel(
      {required this.id,
        required this.name,
        required this.image,
        required this.imageId});

  factory CategoryModel.mapToModel({required Map<String, dynamic> m1}) {
    return CategoryModel(
      id: m1['category_id'],
      name: m1['category_name'],
      image: m1['category_image'],
      imageId: m1['category_image_id'],
    );
  }
}