// lib/screens/favorites_screen.dart

import 'package:flutter/material.dart';
import '../models/food_model.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav_bar.dart';
import 'detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  final List<FoodItem> favorites;

  const FavoritesScreen({super.key, required this.favorites});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Saved Recipe',
                      style: TextStyle(
                        fontFamily: 'Sen',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (favorites.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Text(
                  'Total ${favorites.length.toString().padLeft(2, '0')} items',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textGrey,
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Expanded(
              child: favorites.isEmpty
                  ? _buildEmpty()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: favorites.length,
                      itemBuilder: (ctx, i) =>
                          _FavoriteListItem(food: favorites[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.bookmark_border_rounded,
            size: 72,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          const Text(
            'No saved recipes yet',
            style: TextStyle(
              fontFamily: 'Sen',
              fontSize: 18,
              color: AppColors.textGrey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap ♥ on any dish to save it here',
            style: TextStyle(
              fontFamily: 'Sen',
              fontSize: 13,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoriteListItem extends StatelessWidget {
  final FoodItem food;

  const _FavoriteListItem({required this.food});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetailScreen(food: food, onToggleFavorite: (_) {}),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: FoodCardPlaceholder(
                colorIndex: food.colorIndex,
                imageAssetPath: food.imageAssetPath,
                width: 100,
                height: 100,
                borderRadius: 12,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.dishName,
                    style: const TextStyle(
                      fontFamily: 'Sen',
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: AppColors.textTitle,
                    ),
                  ),
                  const SizedBox(height: 6),
                  StarRatingRow(rating: food.rating, cookTime: food.cookTime),
                ],
              ),
            ),
            const Icon(
              Icons.delete_outline,
              color: AppColors.textLight,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
