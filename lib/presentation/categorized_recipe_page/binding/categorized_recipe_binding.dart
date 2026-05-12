import 'package:get/get.dart';
import '../controller/categorized_recipe_controller.dart';
import '../../../core/app_export.dart';

class CategorizedRecipeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CategorizedRecipeController());
  }
}
