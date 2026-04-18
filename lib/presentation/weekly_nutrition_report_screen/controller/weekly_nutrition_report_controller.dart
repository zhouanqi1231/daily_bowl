import '../../../core/app_export.dart';
import '../models/ingredient_item_model.dart';
import '../models/recipe_item_model.dart';
import '../models/weekly_nutrition_report_model.dart';

class WeeklyNutritionReportController extends GetxController {
  final weeklyNutritionReportModel = Rx<WeeklyNutritionReportModel?>(null);
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  void _initializeData() {
    weeklyNutritionReportModel.value = WeeklyNutritionReportModel(
      weekNumber: 'W16'.obs,
      totalCalories: 3564.obs,
      recipesList: [
        RecipeItemModel(
          title: 'Stir-fried Tomato and Eggs'.obs,
          description: 'This is a simple and classic dish ...'.obs,
          imagePath: ImageConstant.imgMedia.obs,
        ),
        RecipeItemModel(
          title: 'Stir-fried Tomato and Eggs'.obs,
          description: 'This is a simple and classic dish ...'.obs,
          imagePath: ImageConstant.imgMedia.obs,
        ),
        RecipeItemModel(
          title: 'Stir-fried Tomato and Eggs'.obs,
          description: 'This is a simple and classic dish ...'.obs,
          imagePath: ImageConstant.imgMedia.obs,
        ),
        RecipeItemModel(
          title: 'Stir-fried Tomato and Eggs'.obs,
          description: 'This is a simple and classic dish ...'.obs,
          imagePath: ImageConstant.imgMedia.obs,
        ),
      ],
      ingredientsList: [
        IngredientItemModel(name: 'Tomato'.obs, quantity: '200 g'.obs),
        IngredientItemModel(name: 'Cucumber'.obs, quantity: '150 g'.obs),
        IngredientItemModel(name: 'Bell Pepper'.obs, quantity: '120 g'.obs),
        IngredientItemModel(name: 'Carrot'.obs, quantity: '100 g'.obs),
      ],
      proteinPercentage: 32.0.obs,
      carbsPercentage: 35.0.obs,
      fatPercentage: 33.0.obs,
    );
  }

  void onRecipeCardTapped(RecipeItemModel recipe) {
    // Navigate to recipe details or perform action
    Get.snackbar(
      'Recipe Selected',
      'Tapped on ${recipe.title?.value ?? "recipe"}',
      backgroundColor: appTheme.deep_purple_50,
      colorText: appTheme.blue_gray_800,
      duration: Duration(seconds: 2),
    );
  }

  void onBackPressed() {
    Get.back();
  }
}
