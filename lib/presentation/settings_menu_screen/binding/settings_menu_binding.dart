import 'package:get/get.dart';
import '../controller/settings_menu_controller.dart';
import '../../../core/app_export.dart';

class SettingsMenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingsMenuController());
  }
}
