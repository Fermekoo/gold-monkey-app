import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gold_monkey/core/constants/app_colors.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final Color? customFillColor;

  const GlassContainer({
    Key? key,
    required this.child,
    this.borderRadius = 24.0,
    this.padding,
    this.customFillColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return ClipRRect(
    borderRadius: BorderRadius.circular(borderRadius),
    child: Stack(
      children: [
        Positioned.fill(
          child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 10.0,
            sigmaY: 10.0,
          ),
          child: Container(color: Colors.transparent,),
          ),
        ),

        Container(
          padding: padding ?? const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: customFillColor ?? AppColors.glassFill,
            border: Border.all(
              color: AppColors.glassBorder,
              width: 1.0
            ),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                spreadRadius: 1,
              )
            ],
          ),
          child: child,
        ),
      ],
    ),
   );
  }
}