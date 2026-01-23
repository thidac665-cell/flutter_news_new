// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_news_new/common/colors.dart';

class CategoryItem extends StatelessWidget {
  final String categoryName;
  final int index;
  final int activeCategory;
  final VoidCallback onClick;

  const CategoryItem({
    super.key,
    required this.categoryName,
    required this.index,
    required this.activeCategory,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = activeCategory == index;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: onClick,
        child: Container(
          width: 130,
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primary.withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: isActive ? AppColors.primary : AppColors.lighterBlack,
              width: isActive ? 1.5 : 1,
            ),
          ),
          child: Text(
            categoryName.isNotEmpty
                ? '${categoryName[0].toUpperCase()}${categoryName.substring(1)}'
                : '',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              color: isActive ? AppColors.primary : AppColors.lighterBlack,
            ),
          ),
        ),
      ),
    );
  }
}
