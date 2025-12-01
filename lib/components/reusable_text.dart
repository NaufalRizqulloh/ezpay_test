import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';

class ReusableText extends StatelessWidget {
  final String text;
  final FontWeight fontWeight;
  final int fontSize;
  final bool italic;
  final TextAlign textAlign;
  final Color textColor;
  final List<Shadow>? textShadow;
  final TextOverflow overflow;
  final bool isDarkMode;
  const ReusableText({
    super.key,
    required this.text,
    this.fontWeight = FontWeight.normal,
    this.fontSize = 14,
    this.italic = false,
    this.textAlign = TextAlign.left,
    this.textColor = AppColors.textBlack,
    this.textShadow,
    this.overflow = TextOverflow.visible,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Inter',
        fontWeight: fontWeight,
        fontSize: fontSize.sp,
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
        color: textColor,
        shadows: textShadow,
        overflow: overflow,
        decoration: TextDecoration.none,
      ),
      textAlign: textAlign,
    );
  }
}
