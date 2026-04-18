import '../../../core/app_export.dart';
import '../models/saved_recipe_list_model.dart';

class SavedRecipeListController extends GetxController {
  // Observable variables
  final isLoading = false.obs;
  final recipeList = <SavedRecipeListModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    initializeRecipeList();
  }

  void initializeRecipeList() {
    recipeList.value = [
      SavedRecipeListModel(
        title: "Stir-fried Tomato and Eggs".obs,
        description: "This is a simple and classic dish ...".obs,
        imagePath: ImageConstant.imgMedia.obs,
      ),
      SavedRecipeListModel(
        title: "Stir-fried Tomato and Eggs".obs,
        description: "This is a simple and classic dish ...".obs,
        imagePath: ImageConstant.imgMedia.obs,
      ),
      SavedRecipeListModel(
        title: "Stir-fried Tomato and Eggs".obs,
        description: "This is a simple and classic dish ...".obs,
        imagePath: ImageConstant.imgMedia.obs,
      ),
      SavedRecipeListModel(
        title: "Stir-fried Tomato and Eggs".obs,
        description: "This is a simple and classic dish ...".obs,
        imagePath: ImageConstant.imgMedia.obs,
      ),
    ];
  }

  void onRecipeTap(int index) {
    // Navigate to recipe details or perform action
    Get.snackbar(
      "Recipe Selected",
      "You selected: ${recipeList[index].title?.value}",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void refreshRecipes() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 1));
    initializeRecipeList();
    isLoading.value = false;
  }
}
