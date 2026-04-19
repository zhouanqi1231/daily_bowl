import '../../../core/app_export.dart';
import '../../recipe_search_results_screen/models/recipe_item_model.dart';
import '../models/explore_model.dart';

class ExploreController extends GetxController {
  Rx<ExploreModel> exploreModelObj = ExploreModel().obs;

  @override
  void onInit() {
    super.onInit();
    _initializeRecipeList();
  }

  void _initializeRecipeList() {
    List<RecipeItemModel> recipes = [
      RecipeItemModel(
        userInitial: "A".obs,
        userName: "Sarah Johnson".obs,
        userInfo: "Home Chef".obs,
        recipeImage: ImageConstant.imgMedia188x364.obs,
        recipeName: "Creamy Pasta Carbonara".obs,
        isBookmarked: false.obs,
      ),
      RecipeItemModel(
        userInitial: "B".obs,
        userName: "Mark Thompson".obs,
        userInfo: "Professional Chef".obs,
        recipeImage: ImageConstant.imgMedia188x364.obs,
        recipeName: "Grilled Salmon with Herbs".obs,
        isBookmarked: true.obs,
      ),
      RecipeItemModel(
        userInitial: "C".obs,
        userName: "Lisa Chen".obs,
        userInfo: "Food Blogger".obs,
        recipeImage: ImageConstant.imgMedia188x364.obs,
        recipeName: "Chocolate Lava Cake".obs,
        isBookmarked: false.obs,
      ),
    ];

    exploreModelObj.value.recipeList = recipes;
    exploreModelObj.refresh();
  }

  void toggleBookmark(int index) {
    if (exploreModelObj.value.recipeList != null &&
        index < exploreModelObj.value.recipeList!.length) {
      var recipe = exploreModelObj.value.recipeList![index];
      recipe.isBookmarked?.value = !(recipe.isBookmarked?.value ?? false);
      exploreModelObj.refresh();
    }
  }
}
