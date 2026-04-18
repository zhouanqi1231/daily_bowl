import 'package:flutter/material.dart';

import '../core/app_export.dart';

/** CustomIngredientList - A reusable component for displaying ingredient names and quantities in a structured list format with consistent styling and spacing */
class CustomIngredientList extends StatelessWidget {
  CustomIngredientList({
    Key? key,
    required this.ingredientList,
    this.textStyle,
    this.spacing,
    this.margin,
  }) : super(key: key);

  /// List of ingredients with names and quantities
  final List<IngredientItem> ingredientList;

  /// Optional custom text style for ingredient text
  final TextStyle? textStyle;

  /// Spacing between ingredient rows
  final double? spacing;

  /// Top margin for the entire component
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.only(top: 12.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _buildIngredientRows(),
      ),
    );
  }

  List<Widget> _buildIngredientRows() {
    List<Widget> widgets = [];

    for (int i = 0; i < ingredientList.length; i++) {
      widgets.add(_buildIngredientRow(ingredientList[i]));

      // Add spacing between rows except for the last item
      if (i < ingredientList.length - 1) {
        widgets.add(SizedBox(height: spacing ?? 12.h));
      }
    }

    return widgets;
  }

  Widget _buildIngredientRow(IngredientItem ingredient) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            ingredient.name,
            style:
                textStyle ??
                TextStyleHelper.instance.body12RegularRoboto.copyWith(
                  height: 1.25,
                ),
          ),
        ),
        Text(
          ingredient.quantity,
          style:
              textStyle ??
              TextStyleHelper.instance.body12RegularRoboto.copyWith(
                height: 1.25,
              ),
        ),
      ],
    );
  }
}

/// Data model for ingredient items
class IngredientItem {
  IngredientItem({required this.name, required this.quantity});

  /// Name of the ingredient
  final String name;

  /// Quantity with unit (e.g., "200 g", "1 cup")
  final String quantity;
}
