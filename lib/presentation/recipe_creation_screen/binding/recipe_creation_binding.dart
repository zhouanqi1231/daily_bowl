import 'package:get/get.dart';
import '../controller/recipe_creation_controller.dart';
import '../../../core/app_export.dart';

class RecipeCreationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecipeCreationController>(() => RecipeCreationController());
  }
}
