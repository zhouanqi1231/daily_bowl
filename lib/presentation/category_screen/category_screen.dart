import 'package:flutter/material.dart';
import '../../core/app_export.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.white_A700,
      // Removed AppBar and body content as requested
      body: Container(),
    );
  }
}
