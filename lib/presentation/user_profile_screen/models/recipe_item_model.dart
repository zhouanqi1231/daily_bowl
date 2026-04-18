import '../../../core/app_export.dart';

/// This class is used for recipe items in the [UserProfileScreen] screen with GetX.

class RecipeItemModel {
  Rx<String>? title;
  Rx<String>? description;
  Rx<String>? imagePath;

  RecipeItemModel({this.title, this.description, this.imagePath}) {
    title = title ?? Rx("Stir-fried Tomato and Eggs");
    description = description ?? Rx("This is a simple and classic dish ...");
    imagePath = imagePath ?? Rx(ImageConstant.imgMedia);
  }
}
