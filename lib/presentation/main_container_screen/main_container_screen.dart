import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../explore_screen/explore_screen.dart';
import '../category_screen/category_screen.dart';
import '../saved_recipe_list_screen/saved_recipe_list_initial_page.dart';
import '../user_profile_screen/user_profile_screen.dart';

class MainContainerScreen extends StatefulWidget {
  @override
  _MainContainerScreenState createState() => _MainContainerScreenState();
}

class _MainContainerScreenState extends State<MainContainerScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    ExploreScreen(),
    CategoryScreen(),
    SavedRecipeListInitialPage(),
    UserProfileScreen(),
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
            icon: ImageConstant.imgNavExplore,
            title: 'Explore',
          ),
          CustomBottomBarItem(
            icon: ImageConstant.imgNavCatagory,
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
