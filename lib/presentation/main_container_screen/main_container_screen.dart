import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../explore_screen/explore_screen.dart';
import '../category_screen/category_screen.dart';
import '../saved_recipe_list_screen/saved_recipe_list_initial_page.dart';
import '../user_profile_screen/user_profile_screen.dart';
import '../login_screen/login_screen.dart';
import '../register_screen/register_screen.dart';

class MainContainerScreen extends StatefulWidget {
  @override
  _MainContainerScreenState createState() => _MainContainerScreenState();
}

class _MainContainerScreenState extends State<MainContainerScreen> {
  int _selectedIndex = 3; 
  bool _isLoggedIn = false;
  bool _showRegister = false;

  Widget _buildMeTab() {
    if (_isLoggedIn) {
      return UserProfileScreen();
    }
    
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: _showRegister
          ? RegisterScreen(
              key: const ValueKey('Register'),
              onLoginPressed: () {
                setState(() {
                  _showRegister = false;
                });
              },
              onRegisterSuccess: () {
                setState(() {
                  _isLoggedIn = true;
                });
              },
            )
          : LoginScreen(
              key: const ValueKey('Login'),
              onLoginSuccess: () {
                setState(() {
                  _isLoggedIn = true;
                });
              },
              onRegisterPressed: () {
                setState(() {
                  _showRegister = true;
                });
              },
            ),
    );
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
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomBar(
        selectedIndex: _selectedIndex,
        onChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
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
      ),
    );
  }
}
