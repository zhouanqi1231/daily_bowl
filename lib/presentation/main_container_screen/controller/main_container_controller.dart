import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A controller class for the MainContainerScreen.
///
/// This class manages the state of the main container, including the currently selected
/// tab index, user login status, and visibility of the registration screen within the "Me" tab.
class MainContainerController extends GetxController {
  /// The index of the currently selected tab in the bottom navigation bar.
  RxInt selectedIndex = 3.obs;

  /// Observable boolean for the user's login status.
  RxBool isLoggedIn = false.obs;

  /// Observable boolean to track whether to show the registration screen instead of login.
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

  /// Checks the local storage for an API key to determine if the user is logged in.
  ///
  /// Updates [isLoggedIn] and redirects the user to the login screen if they try
  /// to access protected tabs (like "Saved") while logged out.
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

  /// Toggles the registration view visibility.
  ///
  /// [show] True to show the registration screen, false for the login screen.
  void toggleRegister(bool show) {
    showRegister.value = show;
  }
}
