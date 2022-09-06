import 'package:flutter/material.dart';
import 'package:git_touch/utils/utils.dart';

class MyLabel extends StatelessWidget {
  final String? name;
  final Color? color;
  final String? cssColor;
  final Color? textColor;

  const MyLabel({
    required this.name,
    this.color,
    this.cssColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final finalColor = color ?? convertColor(cssColor);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
      decoration: BoxDecoration(
        color: finalColor,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: Text(
        name!,
        style: TextStyle(
          fontSize: 13,
          color: textColor ?? getFontColorByBrightness(finalColor),
          // fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
