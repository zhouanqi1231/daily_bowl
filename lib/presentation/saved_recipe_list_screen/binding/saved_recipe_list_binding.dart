import 'package:get/get.dart';
import '../controller/saved_recipe_list_controller.dart';
import '../../../core/app_export.dart';

class SavedRecipeListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SavedRecipeListController>(() => SavedRecipeListController());
  }
}
