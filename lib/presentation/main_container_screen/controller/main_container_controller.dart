import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainContainerController extends GetxController {
  RxInt selectedIndex = 3.obs;
  RxBool isLoggedIn = false.obs;
  RxBool showRegister = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    isLoggedIn.value = prefs.getString('api_key') != null;
  }

  void toggleRegister(bool show) {
    showRegister.value = show;
  }
}