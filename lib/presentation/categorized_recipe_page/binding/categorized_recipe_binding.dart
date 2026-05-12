import 'package:get/get.dart';
import '../controller/categorized_recipe_controller.dart';
import '../../../core/app_export.dart';

/// A binding class for the CategorizedRecipePage.
///
/// This class ensures that the CategorizedRecipeController is created when the
/// CategorizedRecipePage is first loaded.
class CategorizedRecipeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CategorizedRecipeController());
  }
}
