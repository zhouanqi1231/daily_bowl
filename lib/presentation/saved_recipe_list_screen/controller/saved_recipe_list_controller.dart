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
      SavedRecipeListModel(
        title: "Beef and Broccoli".obs,
        description: "A quick and healthy stir-fry ...".obs,
        imagePath: ImageConstant.imgMedia.obs,
      ),
      SavedRecipeListModel(
        title: "Kung Pao Chicken".obs,
        description: "Spicy and savory classic ...".obs,
        imagePath: ImageConstant.imgMedia.obs,
      ),
      SavedRecipeListModel(
        title: "Mapo Tofu".obs,
        description: "Soft tofu in a spicy sauce ...".obs,
        imagePath: ImageConstant.imgMedia.obs,
      ),
      SavedRecipeListModel(
        title: "Sweet and Sour Pork".obs,
        description: "Crispy pork with tangy sauce ...".obs,
        imagePath: ImageConstant.imgMedia.obs,
      ),
      SavedRecipeListModel(
        title: "Dumplings".obs,
        description: "Handmade pockets of joy ...".obs,
        imagePath: ImageConstant.imgMedia.obs,
      ),
      SavedRecipeListModel(
        title: "Fried Rice".obs,
        description: "Golden rice with veggies ...".obs,
        imagePath: ImageConstant.imgMedia.obs,
      ),
      SavedRecipeListModel(
        title: "Spring Rolls".obs,
        description: "Crispy and light appetizers ...".obs,
        imagePath: ImageConstant.imgMedia.obs,
      ),
      SavedRecipeListModel(
        title: "Hot and Sour Soup".obs,
        description: "Hearty soup with a kick ...".obs,
        imagePath: ImageConstant.imgMedia.obs,
      ),
      SavedRecipeListModel(
        title: "Wonton Soup".obs,
        description: "Clear broth with stuffed wontons ...".obs,
        imagePath: ImageConstant.imgMedia.obs,
      ),
      SavedRecipeListModel(
        title: "Chow Mein".obs,
        description: "Stir-fried noodles with protein ...".obs,
        imagePath: ImageConstant.imgMedia.obs,
      ),
    ];
  }

  void onRecipeTap(int index) {
    Get.toNamed(AppRoutes.recipeDetailScreen);
  }

  void refreshRecipes() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 1));
    initializeRecipeList();
    isLoading.value = false;
  }
}
