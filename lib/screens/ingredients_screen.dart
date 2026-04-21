// lib/screens/ingredients_screen.dart

import 'package:flutter/material.dart';

import '../models/food_model.dart';
import '../theme/app_theme.dart';
import '../widgets/brand_widgets.dart';
import '../widgets/bottom_nav_bar.dart';
import 'detail_screen.dart';

class IngredientsScreen extends StatefulWidget {
  final List<FoodItem> foods;
  final Function(FoodItem) onToggleFavorite;

  const IngredientsScreen({
    super.key,
    required this.foods,
    required this.onToggleFavorite,
  });

  @override
  State<IngredientsScreen> createState() => _IngredientsScreenState();
}

class _IngredientsScreenState extends State<IngredientsScreen> {
  final List<String> _basket = [];
  bool _generating = false;
  bool _hasGenerated = false;
  List<FoodItem> _suggestions = [];

  final List<String> _quickAdd = [
    'Pork',
    'Beef',
    'Fish',
    'Chicken',
    'Rice',
    'Egg',
    'Garlic',
    'Coconut Milk',
    'Lemongrass',
    'Chili',
  ];

  void _addToBasket(String ingredient) {
    final candidate = ingredient.trim();
    if (candidate.isEmpty) return;

    final normalized = FoodItem.normalizeIngredientText(candidate);
    if (normalized.isEmpty) return;
    final exists = _basket.any(
      (item) => FoodItem.normalizeIngredientText(item) == normalized,
    );
    if (exists) return;

    setState(() {
      _basket.add(candidate);
      _suggestions = [];
      _hasGenerated = false;
    });
  }

  void _removeFromBasket(String ingredient) {
    setState(() {
      _basket.remove(ingredient);
      _suggestions = [];
      _hasGenerated = false;
    });
  }

  Future<void> _generateRecipes() async {
    if (_basket.isEmpty) return;
    setState(() {
      _generating = true;
      _suggestions = [];
      _hasGenerated = false;
    });

    await Future.delayed(const Duration(milliseconds: 800));

    final matched = widget.foods
        .where((food) => food.matchesAllIngredients(_basket))
        .toList(growable: false);

    setState(() {
      _suggestions = matched;
      _generating = false;
      _hasGenerated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const DishGenieWordmark(fontSize: 22),
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Hey Pheaktra, what should we cook today?',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontSize: 16,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Add ingredients to your basket. Recipes only appear when every ingredient matches.',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textGrey,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 18),
              _IngredientInput(onAdd: _addToBasket),
              const SizedBox(height: 24),
              if (_basket.isNotEmpty) ...[
                Text(
                  'Your Basket',
                  style: AppTextStyles.heading3.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _basket
                      .map(
                        (ing) => _BasketChip(
                          label: ing,
                          onRemove: () => _removeFromBasket(ing),
                        ),
                      )
                      .toList(growable: false),
                ),
                const SizedBox(height: 24),
              ],
              Text(
                'Quick Add',
                style: AppTextStyles.heading3.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _quickAdd
                    .where(
                      (item) => !_basket.any(
                        (selected) =>
                            FoodItem.normalizeIngredientText(selected) ==
                            FoodItem.normalizeIngredientText(item),
                      ),
                    )
                    .map(
                      (ing) => _QuickAddChip(
                        label: ing,
                        onAdd: () => _addToBasket(ing),
                      ),
                    )
                    .toList(growable: false),
              ),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: _generateRecipes,
                child: Container(
                  width: double.infinity,
                  height: 62,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primaryDark, AppColors.primary],
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.28),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: _generating
                      ? const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                        )
                      : Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.auto_awesome,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Generate Recipe',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
              if (_suggestions.isNotEmpty) ...[
                const SizedBox(height: 28),
                Text(
                  'Exact matches (${_suggestions.length})',
                  style: AppTextStyles.heading3.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 14),
                ..._suggestions.map(
                  (food) => _RecipeResultCard(
                    food: food,
                    basket: _basket,
                    onToggleFavorite: widget.onToggleFavorite,
                  ),
                ),
              ] else if (_hasGenerated) ...[
                const SizedBox(height: 28),
                const _NoExactMatchCard(),
              ],
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _IngredientInput extends StatefulWidget {
  final Function(String) onAdd;

  const _IngredientInput({required this.onAdd});

  @override
  State<_IngredientInput> createState() => _IngredientInputState();
}

class _IngredientInputState extends State<_IngredientInput> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _submit() {
    final value = _ctrl.text.trim();
    if (value.isEmpty) return;
    widget.onAdd(value);
    _ctrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.searchBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          const SizedBox(width: 20),
          const Icon(Icons.search, color: AppColors.textGrey, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _ctrl,
              decoration: InputDecoration(
                hintText: 'Type an ingredient and press +',
                hintStyle: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textHint,
                ),
                filled: false,
                border: InputBorder.none,
              ),
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textDark,
                fontWeight: FontWeight.w700,
              ),
              onSubmitted: (_) => _submit(),
            ),
          ),
          GestureDetector(
            onTap: _submit,
            child: Container(
              margin: const EdgeInsets.all(6),
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.add, color: AppColors.primary, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}

class _BasketChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _BasketChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: AppColors.primaryLight),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close, size: 14, color: AppColors.primary),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textDark,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAddChip extends StatelessWidget {
  final String label;
  final VoidCallback onAdd;

  const _QuickAddChip({required this.label, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onAdd,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.tagBg,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add, size: 14, color: AppColors.primary),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textDark,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecipeResultCard extends StatelessWidget {
  final FoodItem food;
  final List<String> basket;
  final Function(FoodItem) onToggleFavorite;

  const _RecipeResultCard({
    required this.food,
    required this.basket,
    required this.onToggleFavorite,
  });

  int get _matchCount => basket.where(food.matchesIngredientQuery).length;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              DetailScreen(food: food, onToggleFavorite: onToggleFavorite),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 12,
              offset: const Offset(0, 4),
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
                width: 80,
                height: 80,
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
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 15,
                      color: AppColors.textTitle,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  StarRatingRow(rating: food.rating, cookTime: food.cookTime),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Exact match • $_matchCount/${basket.length} ingredients',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textLight),
          ],
        ),
      ),
    );
  }
}

class _NoExactMatchCard extends StatelessWidget {
  const _NoExactMatchCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.search_off_rounded,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'No exact recipe match yet',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textTitle,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Try removing one ingredient or adding a more common combination. DishGenie now only shows recipes when every basket ingredient is present.',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textGrey,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
