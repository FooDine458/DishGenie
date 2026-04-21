// lib/widgets/bottom_nav_bar.dart

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DishGenieBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const DishGenieBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.home_outlined,
            label: 'Home',
            isActive: currentIndex == 0,
            onTap: () => onTap(0),
          ),
          _NavItem(
            icon: Icons.shopping_basket_outlined,
            label: 'Ingredients',
            isActive: currentIndex == 1,
            onTap: () => onTap(1),
          ),
          _CenterNavItem(onTap: () => onTap(2)),
          _NavItem(
            icon: Icons.bookmark_outline,
            label: 'Favorites',
            isActive: currentIndex == 3,
            onTap: () => onTap(3),
          ),
          _NavItem(
            icon: Icons.person_outline,
            label: 'Profile',
            isActive: currentIndex == 4,
            onTap: () => onTap(4),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 22,
              color: isActive ? AppColors.primary : AppColors.textHint,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyles.navLabel.copyWith(
                color: isActive ? AppColors.primary : AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CenterNavItem extends StatelessWidget {
  final VoidCallback onTap;

  const _CenterNavItem({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.auto_awesome, color: Colors.white, size: 22),
      ),
    );
  }
}

// Food card placeholder gradient
class FoodCardPlaceholder extends StatelessWidget {
  final int colorIndex;
  final double width;
  final double height;
  final double borderRadius;
  final String? imageAssetPath;

  const FoodCardPlaceholder({
    super.key,
    required this.colorIndex,
    required this.width,
    required this.height,
    this.borderRadius = 12,
    this.imageAssetPath,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        AppColors.cardGradients[colorIndex % AppColors.cardGradients.length];
    final minSide = (width < height) ? width : height;
    final iconSize = (minSide * 0.35).clamp(18.0, 72.0);
    final fallback = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.restaurant,
          color: Colors.white.withValues(alpha: 0.5),
          size: iconSize,
        ),
      ),
    );

    if (imageAssetPath == null || imageAssetPath!.isEmpty) {
      return fallback;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.asset(
        imageAssetPath!,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => fallback,
      ),
    );
  }
}

// Star rating row
class StarRatingRow extends StatelessWidget {
  final double rating;
  final String cookTime;
  final double fontSize;

  const StarRatingRow({
    super.key,
    required this.rating,
    required this.cookTime,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star, color: AppColors.star, size: 18),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            fontFamily: 'Sen',
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: AppColors.textTitle,
          ),
        ),
        const SizedBox(width: 12),
        const Icon(
          Icons.access_time_outlined,
          size: 18,
          color: AppColors.textGrey,
        ),
        const SizedBox(width: 4),
        Text(
          cookTime,
          style: TextStyle(
            fontFamily: 'Sen',
            fontSize: fontSize,
            color: AppColors.textTitle,
          ),
        ),
      ],
    );
  }
}
