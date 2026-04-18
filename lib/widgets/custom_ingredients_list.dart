import 'package:flutter/material.dart';

import '../core/app_export.dart';

/** 
 * CustomIngredientsList - A flexible ingredients list component that displays ingredient names with their quantities.
 * 
 * This component creates a vertical list of ingredients where each row contains an ingredient name 
 * on the left and its quantity on the right. The layout uses space-between justification for 
 * proper alignment and consistent spacing between items.
 * 
 * @param ingredientsList List of CustomIngredientsItem containing ingredient data
 * @param itemSpacing Vertical spacing between ingredient rows
 * @param textColor Color for the ingredient text
 * @param fontSize Font size for the ingredient text
 * @param fontWeight Font weight for the ingredient text
 */
class CustomIngredientsList extends StatelessWidget {
  const CustomIngredientsList({
    Key? key,
    required this.ingredientsList,
    this.itemSpacing,
    this.textColor,
    this.fontSize,
    this.fontWeight,
  }) : super(key: key);

  /// List of ingredients with their names and quantities
  final List<CustomIngredientsItem> ingredientsList;

  /// Spacing between ingredient rows
  final double? itemSpacing;

  /// Text color for ingredient names and quantities
  final Color? textColor;

  /// Font size for ingredient text
  final double? fontSize;

  /// Font weight for ingredient text
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(ingredientsList.length, (index) {
        final ingredient = ingredientsList[index];

        return Padding(
          padding: EdgeInsets.only(
            bottom: index < ingredientsList.length - 1
                ? (itemSpacing ?? 12.h)
                : 0,
          ),
          child: _buildIngredientRow(ingredient),
        );
      }),
    );
  }

  /// Builds individual ingredient row with name and quantity
  Widget _buildIngredientRow(CustomIngredientsItem ingredient) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            ingredient.name ?? '',
            style: TextStyleHelper.instance.bodyTextRoboto.copyWith(
              color: textColor ?? Color(0xFF000000),
              height: 1.25,
            ),
          ),
        ),
        Text(
          ingredient.quantity ?? '',
          style: TextStyleHelper.instance.bodyTextRoboto.copyWith(
            color: textColor ?? Color(0xFF000000),
            height: 1.25,
          ),
        ),
      ],
    );
  }
}

/// Data model for individual ingredient item
class CustomIngredientsItem {
  const CustomIngredientsItem({this.name, this.quantity});

  /// Name of the ingredient
  final String? name;

  /// Quantity or amount of the ingredient
  final String? quantity;
}
