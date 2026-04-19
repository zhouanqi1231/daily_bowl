import '../../../core/app_export.dart';

/// This class is used for individual recipe items in the recipe search results screen.
class RecipeItemModel {
  int? id;
  Rx<String>? userInitial;
  Rx<String>? userName;
  Rx<String>? userInfo;
  Rx<String>? recipeImage;
  Rx<String>? recipeName;
  Rx<bool>? isBookmarked;

  RecipeItemModel({
    this.id,
    this.userInitial,
    this.userName,
    this.userInfo,
    this.recipeImage,
    this.recipeName,
    this.isBookmarked,
  }) {
    userInitial = userInitial ?? Rx("A");
    userName = userName ?? Rx("Name");
    userInfo = userInfo ?? Rx("info");
    recipeImage = recipeImage ?? Rx(ImageConstant.imgMedia188x364);
    recipeName = recipeName ?? Rx("Recipe name");
    isBookmarked = isBookmarked ?? Rx(false);
  }
}
