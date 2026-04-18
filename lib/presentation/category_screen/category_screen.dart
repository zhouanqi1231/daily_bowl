import 'package:flutter/material.dart';
import '../../core/app_export.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.white_A700,
      appBar: AppBar(
        title: Text("Categories", style: TextStyleHelper.instance.title22RegularRoboto),
        backgroundColor: appTheme.white_A700,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          "Category Page Coming Soon",
          style: TextStyleHelper.instance.body14MediumRoboto,
        ),
      ),
    );
  }
}
