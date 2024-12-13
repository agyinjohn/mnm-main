import 'package:flutter/material.dart';

import '../../constants/global_variables.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final String title;

  const CustomButton({
    super.key,
    required this.onTap,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 65,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: AppColors.primaryColor,
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
                fontSize: 18,
                color: AppColors.onPrimaryColor,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
