import 'package:get/get.dart';
import '../controller/allergy_setting_controller.dart';
import '../../../core/app_export.dart';

class AllergySettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AllergySettingController());
  }
}
