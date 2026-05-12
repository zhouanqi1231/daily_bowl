import '../../../core/app_export.dart';
import '../../../core/network/api_client.dart';
import '../models/category_model.dart';

class CategoryController extends GetxController {
  RxList<CategoryModel> categoryList = <CategoryModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

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
      print("Error fetching categories: $e");
      Get.snackbar("Error", "Failed to load categories");
    } finally {
      isLoading.value = false;
    }
  }

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
        print("Error fetching image for ${category.cuisineType.value}: $e");
      }
    }
  }

  void onCategoryTap(CategoryModel category) {
    Get.toNamed(AppRoutes.categorizedRecipePage, arguments: {
      'cuisine_type': category.cuisineType.value,
    });
  }
}
