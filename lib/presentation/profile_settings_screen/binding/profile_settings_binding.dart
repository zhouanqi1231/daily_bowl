import 'package:get/get.dart';
import '../controller/profile_settings_controller.dart';

class ProfileSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileSettingsController());
  }
}
