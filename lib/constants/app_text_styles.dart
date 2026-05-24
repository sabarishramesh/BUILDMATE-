import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
    letterSpacing: -0.5,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
    letterSpacing: -0.3,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textMedium,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textDark,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textMedium,
  );

  static const TextStyle label = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.textMedium,
    letterSpacing: 0.8,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    letterSpacing: 0.3,
  );

  static const TextStyle bigNumber = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static const TextStyle cardValue = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );
}
