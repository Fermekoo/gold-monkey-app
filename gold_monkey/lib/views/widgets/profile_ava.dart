import 'package:flutter/material.dart';
import 'package:gold_monkey/core/constants/app_colors.dart';

class ProfileVatar extends StatelessWidget {
  final String url;

  const ProfileVatar({
    Key? key,
    required this.url
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4), // Jarak border
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // Efek gradient border
        gradient: LinearGradient(
          colors: [AppColors.primary, Colors.purpleAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.5),
            blurRadius: 20,
            spreadRadius: 2,
          )
        ],
      ),
      child: CircleAvatar(
        radius: 60,
        backgroundColor: AppColors.background,
        backgroundImage: (NetworkImage(url)),
      ),
    );
  }
}