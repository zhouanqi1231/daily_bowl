import 'package:get/get.dart';

class CategoryModel {
  Rx<String> cuisineType;
  Rx<int> recipeCount;
  Rx<String> imagePath;

  CategoryModel({
    required String cuisineType,
    required int recipeCount,
    String imagePath = "",
  })  : cuisineType = Rx(cuisineType),
        recipeCount = Rx(recipeCount),
        imagePath = Rx(imagePath);
}
