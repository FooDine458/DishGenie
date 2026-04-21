// lib/screens/detail_screen.dart

import 'package:flutter/material.dart';
import '../models/food_model.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav_bar.dart';

class DetailScreen extends StatefulWidget {
  final FoodItem food;
  final Function(FoodItem) onToggleFavorite;

  const DetailScreen({
    super.key,
    required this.food,
    required this.onToggleFavorite,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    final food = widget.food;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Hero image area
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(0),
              ),
              child: FoodCardPlaceholder(
                colorIndex: food.colorIndex,
                imageAssetPath: food.imageAssetPath,
                width: double.infinity,
                height: 240,
                borderRadius: 0,
              ),
            ),
          ),

          // Top bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _CircleButton(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.chevron_left,
                        color: AppColors.textDark,
                        size: 24,
                      ),
                    ),
                    _CircleButton(
                      onTap: () {
                        widget.onToggleFavorite(food);
                        setState(() {});
                      },
                      child: Icon(
                        food.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: food.isFavorite
                            ? Colors.red
                            : AppColors.textGrey,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content
          Positioned.fill(
            top: 220,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Rating row
                    StarRatingRow(rating: food.rating, cookTime: food.cookTime),
                    const SizedBox(height: 12),

                    // Title
                    Text(
                      food.dishName,
                      style: const TextStyle(
                        fontFamily: 'Sen',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Description
                    Text(
                      food.description,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textGrey,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Ingredients
                    _SectionTitle(title: 'Ingredients'),
                    const SizedBox(height: 12),
                    ...food.ingredientList.map(
                      (ing) => _IngredientRow(item: ing),
                    ),
                    const SizedBox(height: 20),

                    // Instructions
                    _SectionTitle(title: 'Instructions'),
                    const SizedBox(height: 12),
                    ...food.instructionSteps.asMap().entries.map(
                      (entry) => _InstructionStep(
                        index: entry.key + 1,
                        text: entry.value,
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;

  const _CircleButton({required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Sen',
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }
}

class _IngredientRow extends StatelessWidget {
  final IngredientItem item;
  const _IngredientRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(right: 12),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              item.name,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textGrey,
              ),
            ),
          ),
          if (item.amount.isNotEmpty)
            Text(
              item.amount,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textGrey,
              ),
            ),
        ],
      ),
    );
  }
}

class _InstructionStep extends StatelessWidget {
  final int index;
  final String text;
  const _InstructionStep({required this.index, required this.text});

  @override
  Widget build(BuildContext context) {
    // Clean up step numbering if already in text
    String displayText = text.replaceFirst(RegExp(r'^\d+\.\s*'), '');

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            margin: const EdgeInsets.only(right: 12, top: 2),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$index',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              displayText,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textGrey,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
