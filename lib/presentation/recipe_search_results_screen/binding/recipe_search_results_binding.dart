import 'package:get/get.dart';
import '../controller/recipe_search_results_controller.dart';
import '../../../core/app_export.dart';

class RecipeSearchResultsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RecipeSearchResultsController());
  }
}
