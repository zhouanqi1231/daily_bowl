import 'package:flutter/material.dart';

import '../core/app_export.dart';

/** 
 * CustomInstructionList - A reusable component for displaying a vertical list of text instructions.
 * 
 * This component renders a series of instructions in a column layout with consistent spacing
 * and typography. Perfect for recipe steps, tutorial instructions, or any sequential text content.
 * 
 * @param instructions List of instruction text strings to display
 * @param textStyle Optional custom text style for the instructions
 * @param spacing Vertical spacing between instruction items
 * @param alignment Cross axis alignment for the column
 * @param padding Optional padding around the entire instruction list
 */
class CustomInstructionList extends StatelessWidget {
  CustomInstructionList({
    Key? key,
    required this.instructions,
    this.textStyle,
    this.spacing,
    this.alignment,
    this.padding,
  }) : super(key: key);

  /// List of instruction text strings to display
  final List<String> instructions;

  /// Custom text style for the instructions
  final TextStyle? textStyle;

  /// Vertical spacing between instruction items
  final double? spacing;

  /// Cross axis alignment for the column
  final CrossAxisAlignment? alignment;

  /// Optional padding around the entire instruction list
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: alignment ?? CrossAxisAlignment.start,
        children: _buildInstructionItems(),
      ),
    );
  }

  List<Widget> _buildInstructionItems() {
    List<Widget> items = [];

    for (int i = 0; i < instructions.length; i++) {
      items.add(
        Text(
          instructions[i],
          style:
              textStyle ??
              TextStyleHelper.instance.body12RegularRoboto.copyWith(
                color: appTheme.black_900,
                height: 1.33,
              ),
        ),
      );

      // Add spacing between items, but not after the last item
      if (i < instructions.length - 1) {
        items.add(SizedBox(height: spacing ?? 14.h));
      }
    }

    return items;
  }
}
