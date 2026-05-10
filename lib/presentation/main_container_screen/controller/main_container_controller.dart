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
    
    // Check login status every time the index changes
    ever(selectedIndex, (_) {
      checkLoginStatus();
    });
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('api_key');
    
    // Update state
    bool currentlyLoggedIn = token != null && token.isNotEmpty;
    
    if (isLoggedIn.value != currentlyLoggedIn) {
      isLoggedIn.value = currentlyLoggedIn;
    }

    // If we are on a tab that requires login but we aren't, 
    // we can redirect or show login. 
    // The "Me" tab (index 3) already handles this via Obx in the screen.
    // The "Saved" tab (index 2) should also likely check this.
    if (selectedIndex.value == 2 && !currentlyLoggedIn) {
      // If user tries to access Saved while logged out, redirect to Me (Login)
      selectedIndex.value = 3;
    }
  }

  void toggleRegister(bool show) {
    showRegister.value = show;
  }
}
