import 'package:get/get.dart';
import '../controller/weekly_nutrition_report_controller.dart';
import '../../../core/app_export.dart';

class WeeklyNutritionReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WeeklyNutritionReportController());
  }
}
