// lib/screens/search_screen.dart

import 'package:flutter/material.dart';
import '../models/food_model.dart';
import '../services/food_service.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav_bar.dart';
import 'detail_screen.dart';

class SearchScreen extends StatefulWidget {
  final List<FoodItem> foods;

  const SearchScreen({super.key, required this.foods});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  List<FoodItem> _results = [];
  String _query = '';

  final List<String> _recentKeywords = ['Pork', 'Fish', 'Rice', 'Noodle'];

  @override
  void initState() {
    super.initState();
    _results = widget.foods;
  }

  void _search(String q) {
    setState(() {
      _query = q;
      _results = FoodService.searchFoods(widget.foods, q);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.searchBg,
            borderRadius: BorderRadius.circular(50),
          ),
          child: TextField(
            controller: _controller,
            autofocus: true,
            onChanged: _search,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textDark),
            decoration: InputDecoration(
              hintText: 'Search dishes, meals, cuisines',
              hintStyle: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textHint,
              ),
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.textGrey,
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ),
      body: _query.isEmpty ? _buildEmptyState() : _buildResults(),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Keywords',
            style: TextStyle(
              fontFamily: 'Sen',
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: AppColors.textBody,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _recentKeywords.map((kw) {
              return GestureDetector(
                onTap: () {
                  _controller.text = kw;
                  _search(kw);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    kw,
                    style: const TextStyle(
                      fontFamily: 'Sen',
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 28),
          const Text(
            'Suggested Food',
            style: TextStyle(
              fontFamily: 'Sen',
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: AppColors.textBody,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              itemCount: widget.foods.take(5).length,
              separatorBuilder: (context, index) =>
                  const Divider(color: AppColors.divider),
              itemBuilder: (ctx, i) {
                final food = widget.foods[i];
                return _SuggestedRow(food: food);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    if (_results.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 60, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(
              'No dishes found for "$_query"',
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: _results.length,
      separatorBuilder: (context, index) =>
          const Divider(color: AppColors.divider),
      itemBuilder: (ctx, i) => _SuggestedRow(food: _results[i]),
    );
  }
}

class _SuggestedRow extends StatelessWidget {
  final FoodItem food;
  const _SuggestedRow({required this.food});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetailScreen(food: food, onToggleFavorite: (_) {}),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FoodCardPlaceholder(
                colorIndex: food.colorIndex,
                imageAssetPath: food.imageAssetPath,
                width: 56,
                height: 50,
                borderRadius: 10,
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
                      color: AppColors.textTitle,
                    ),
                  ),
                  const SizedBox(height: 4),
                  StarRatingRow(rating: food.rating, cookTime: food.cookTime),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textLight,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
