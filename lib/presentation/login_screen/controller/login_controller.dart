import 'package:daily_bowl/presentation/main_container_screen/controller/main_container_controller.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/app_export.dart';
import '../../../core/network/api_client.dart';
import '../../explore_screen/controller/explore_controller.dart';
import '../../user_profile_screen/controller/user_profile_controller.dart';
import '../../../core/global_save_manager.dart';

/// A controller class for the LoginScreen.
///
/// This class manages the state of the login process, including text controllers
/// for email and password, handling the login API call, and updating other
/// controllers upon successful authentication.
class LoginController extends GetxController {
  /// Controller for the email input field.
  TextEditingController emailController = TextEditingController();

  /// Controller for the password input field.
  TextEditingController passwordController = TextEditingController();

  /// Observable boolean to track password visibility.
  RxBool obscurePassword = true.obs;

  @override
  void onInit() {
    super.onInit();
    emailController.clear();
    passwordController.clear();
    obscurePassword.value = true;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  /// Attempts to authenticate the user with the provided email and password.
  ///
  /// On success, it persists the API token, fetches user details, refreshes
  /// relevant controllers (Explore, UserProfile, MainContainer), and navigates back.
  Future<void> login() async {
    FocusManager.instance.primaryFocus?.unfocus();
    
    // Use a small delay to ensure keyboard is hiding
    await Future.delayed(const Duration(milliseconds: 100));

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter both email and password');
      return;
    }

    // Store email to avoid accessing emailController.text after potential disposal
    final email = emailController.text;
    final password = passwordController.text;

    try {
      // get a token from the server, logging in with email and pwd
      final response = await ApiClient.post('/tokens/', {
        'email': email,
        'pwd': password,
      });

      // Check if controller is still active/not disposed
      if (isClosed) return;

      if (response != null && response['token'] != null) {
        // Persist session token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('api_key', response['token']);
        await prefs.setString('user_email', email);

        // Fetch user profile to get the username and ID
        try {
          final usersResponse = await ApiClient.get('/users/');
          if (usersResponse is List) {
            final currentUser = usersResponse.firstWhere(
              (u) => u['email'] == email,
              orElse: () => null,
            );
            if (currentUser != null) {
              if (currentUser['username'] != null) {
                await prefs.setString('user_name', currentUser['username']);
              }
              if (currentUser['id'] != null) {
                await prefs.setInt('user_id', currentUser['id']);
              }
            }
          }
        } catch (e) {
          print("Error fetching user profile after login: $e");
        }
        
        // Safety check before clearing
        if (!isClosed) {
          emailController.clear();
          passwordController.clear();
        }

        await Get.find<GlobalSaveManager>().fetchInitialSaves();

        // trigger ExploreController status check
        if (Get.isRegistered<ExploreController>()) {
          Get.find<ExploreController>().checkLoginStatus();
        }

        if (Get.isRegistered<UserProfileController>()) {
          Get.find<UserProfileController>().refreshUserProfile();
        }

        if (Get.isRegistered<MainContainerController>()) {
          Get.find<MainContainerController>().checkLoginStatus();
          Get.find<MainContainerController>().selectedIndex.value = 3;
        }

        Get.snackbar('Success', 'Login successful!');
        
        // Only go back if we are on the login route specifically 
        // (not when it's embedded in a tab)
        if (Get.currentRoute == AppRoutes.loginScreen) {
          Get.back();
        }
      }
    } catch (e) {
      if (isClosed) return;
      Get.snackbar('Login Failed', 'Invalid email or password.');
    }
  }

  /// Handles the action when the register button is pressed.
  ///
  /// Typically toggles the registration view in the main container.
  void onRegisterPressed() {
    if (Get.isRegistered<MainContainerController>()) {
      Get.find<MainContainerController>().toggleRegister(true);
    } else {
      Get.snackbar(
        'Notice', 
        'Registration is under development',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black87,
        colorText: Colors.white,
      );
    }
  }
}
