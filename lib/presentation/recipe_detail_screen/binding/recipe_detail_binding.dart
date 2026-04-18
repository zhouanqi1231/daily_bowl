import 'package:get/get.dart';
import '../controller/recipe_detail_controller.dart';
import '../../../core/app_export.dart';

class RecipeDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RecipeDetailController());
  }
}
