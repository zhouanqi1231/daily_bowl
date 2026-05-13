import '../../../core/app_export.dart';
import '../../../core/network/api_client.dart';
import '../models/category_model.dart';

/// A controller class for the CategoryScreen.
///
/// This class manages the state of the category list, including fetching categories
/// and their representative images from the backend.
class CategoryController extends GetxController {
  /// Observable list of category models.
  RxList<CategoryModel> categoryList = <CategoryModel>[].obs;

  /// Observable boolean to track loading state.
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  /// Fetches the list of recipe categories and their counts from the API.
  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      final response = await ApiClient.get('/recipes/?aggregate=categories');
      
      if (response != null && response['categories'] != null) {
        List<dynamic> categoriesData = response['categories'];
        
        // Map initial categories with empty image path
        List<CategoryModel> initialList = categoriesData.map((cat) {
          String cuisineType = cat['cuisine_type'] ?? 'Unknown';
          return CategoryModel(
            cuisineType: cuisineType,
            recipeCount: cat['recipe_count'] ?? 0,
            imagePath: "",
          );
        }).toList();

        categoryList.value = initialList;

        // Fetch first recipe image for each category asynchronously
        _fetchCategoryImages();
      }
    } catch (e) {
      // print("Error fetching categories: $e");
      Get.snackbar("Error", "Failed to load categories");
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetches a representative image for each category in [categoryList].
  ///
  /// For each category, it requests the first recipe of that cuisine type
  /// and updates the category's [imagePath].
  Future<void> _fetchCategoryImages() async {
    for (var category in categoryList) {
      try {
        final recipes = await ApiClient.get('/recipes/?cuisine_type=${category.cuisineType.value}&limit=1');
        if (recipes is List && recipes.isNotEmpty) {
          String? imgUrl = recipes[0]['img_url'];
          if (imgUrl != null && imgUrl.isNotEmpty) {
            category.imagePath.value = imgUrl;
          }
        }
      } catch (e) {
        // print("Error fetching image for ${category.cuisineType.value}: $e");
      }
    }
  }

  /// Handles navigation to the [CategorizedRecipePage] when a category is tapped.
  ///
  /// [category] The category model that was tapped.
  void onCategoryTap(CategoryModel category) {
    Get.toNamed(AppRoutes.categorizedRecipePage, arguments: {
      'cuisine_type': category.cuisineType.value,
    });
  }
}
