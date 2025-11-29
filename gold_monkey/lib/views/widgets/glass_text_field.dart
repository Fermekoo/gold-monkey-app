import 'package:flutter/material.dart';
import 'package:gold_monkey/core/constants/app_colors.dart';
import 'package:gold_monkey/views/widgets/glass_container.dart';

class GlassTextField extends StatelessWidget {
  final TextEditingController controller;
    final IconData icon;
    final String hint;
    final bool isPassword;
    final TextInputType keyboardType;

    const GlassTextField({
      Key? key,
      required this.controller,
      required this.icon,
      required this.hint,
      this.isPassword = false,
      this.keyboardType = TextInputType.text, 
    }) : super(key: key);

    @override
  Widget build(BuildContext context) {
   return GlassContainer(
      borderRadius: 16,
      padding: EdgeInsets.zero,
      customFillColor: AppColors.inputFill,
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppColors.textSecondary),
          hintText: hint,
          hintStyle: TextStyle(color: AppColors.textSecondary),
          border: InputBorder.none,
          filled: false,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
        ),
      ),
    );
  }
}