import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../explore_screen/explore_screen.dart';
import '../category_screen/category_screen.dart';
import '../saved_recipe_list_screen/saved_recipe_list_initial_page.dart';
import '../user_profile_screen/user_profile_screen.dart';
import '../login_screen/login_screen.dart';
import '../register_screen/register_screen.dart';
import './controller/main_container_controller.dart';

class MainContainerScreen extends StatelessWidget {
  final MainContainerController controller = Get.put(MainContainerController());

  Widget _buildMeTab() {
    return Obx(() {
      if (controller.isLoggedIn.value) {
        return UserProfileScreen();
      }
      
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: controller.showRegister.value
            ? RegisterScreen(
                key: const ValueKey('Register'),
                onLoginPressed: () => controller.toggleRegister(false),
                onRegisterSuccess: () {
                  controller.checkLoginStatus();
                },
              )
            : const LoginScreen(),
      );
    });
  }

  List<Widget> get _pages => [
        ExploreScreen(),
        CategoryScreen(),
        SavedRecipeListInitialPage(),
        _buildMeTab(),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
        index: controller.selectedIndex.value,
        children: _pages,
      )),
      bottomNavigationBar: Obx(() => CustomBottomBar(
        selectedIndex: controller.selectedIndex.value,
        onChanged: (index) {
          controller.selectedIndex.value = index;
        },
        bottomBarItemList: [
          CustomBottomBarItem(
            inactiveIconData: Icons.explore_outlined,
            activeIconData: Icons.explore,
            title: 'Explore',
          ),
          CustomBottomBarItem(
            inactiveIconData: Icons.grid_view_outlined,
            activeIconData: Icons.grid_view_rounded,
            title: 'Category',
          ),
          CustomBottomBarItem(
            icon: ImageConstant.imgNavSavedGray800,
            activeIcon: ImageConstant.imgNavSaved,
            title: 'Saved',
          ),
          CustomBottomBarItem(
            icon: ImageConstant.imgNavMe,
            activeIcon: ImageConstant.imgNavMeBlack900,
            title: 'Me',
          ),
        ],
      )),
    );
  }
}