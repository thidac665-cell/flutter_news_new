import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_news_new/common/colors.dart';

class CategoryItem extends StatefulWidget {
  final String categoryName;
  final int index;
  final int activeCategory;
  final Function onClick;

  const CategoryItem({
    super.key,
    required this.categoryName,
    required this.index,
    required this.activeCategory,
    required this.onClick,
  });

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  @override
  Widget build(BuildContext context) {
    final bool isActive = widget.activeCategory == widget.index;

    return GestureDetector(
      onTap: () => widget.onClick(),
      child: Container(
        width: 130,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withOpacity(0.1) // highlight active
              : Colors.transparent,
          border: Border.all(
            color: isActive ? AppColors.black : AppColors.lighterBlack,
            width: isActive ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.categoryName.isNotEmpty
                  ? '${widget.categoryName[0].toUpperCase()}${widget.categoryName.substring(1)}'
                  : '',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: isActive ? AppColors.black : AppColors.lighterBlack,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
            if (isActive) ...[
              const SizedBox(width: 4),
              const Icon(Icons.star, size: 14, color: Colors.orangeAccent), // Thida marker
            ]
          ],
        ),
      ),
    );
  }
}
