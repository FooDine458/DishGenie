// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import '../models/food_model.dart';
import '../services/food_service.dart';
import '../theme/app_theme.dart';
import '../widgets/brand_widgets.dart';
import '../widgets/bottom_nav_bar.dart';
import 'detail_screen.dart';
import 'search_screen.dart';
import 'ingredients_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';

// ─────────────────────────────────────────
// Main shell with bottom navigation
// ─────────────────────────────────────────
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  List<FoodItem> _foods = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadFoods();
  }

  Future<void> _loadFoods() async {
    final foods = await FoodService.loadFoods();
    setState(() {
      _foods = foods;
      _loading = false;
    });
  }

  void _toggleFavorite(FoodItem item) {
    setState(() {
      item.isFavorite = !item.isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(child: DishGenieLoadingView()),
      );
    }

    final favorites = _foods.where((f) => f.isFavorite).toList();

    final screens = [
      HomeScreen(
        foods: _foods,
        onToggleFavorite: _toggleFavorite,
        onNavigateTo: (i) => setState(() => _currentIndex = i),
      ),
      IngredientsScreen(foods: _foods, onToggleFavorite: _toggleFavorite),
      IngredientsScreen(
        foods: _foods,
        onToggleFavorite: _toggleFavorite,
      ), // AI generate tab
      FavoritesScreen(favorites: favorites),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: DishGenieBottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

// ─────────────────────────────────────────
// Home Screen
// ─────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  final List<FoodItem> foods;
  final Function(FoodItem) onToggleFavorite;
  final Function(int) onNavigateTo;

  const HomeScreen({
    super.key,
    required this.foods,
    required this.onToggleFavorite,
    required this.onNavigateTo,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'All';
  final _searchController = TextEditingController();

  final List<String> _categories = [
    'All',
    'Rice',
    'Soup',
    'Curry',
    'Salad',
    'Dessert',
    'Main',
  ];

  List<FoodItem> get _filteredFoods {
    if (_selectedCategory == 'All') return widget.foods;
    return widget.foods.where((f) => f.category == _selectedCategory).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildSearchBar()),
            SliverToBoxAdapter(child: _buildCategoryRow()),
            SliverToBoxAdapter(
              child: _buildSectionHeader('Most Popular', 'See All', () {}),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => _buildFoodCard(_filteredFoods[i]),
                childCount: _filteredFoods.length,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const DishGenieWordmark(fontSize: 22),
          Container(
            width: 45,
            height: 45,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: Colors.white,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontFamily: 'Sen',
                fontSize: 16,
                color: AppColors.textDark,
              ),
              children: [
                TextSpan(text: 'Hey Pheaktra, '),
                TextSpan(
                  text: 'What Should We Cook Today?',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SearchScreen(foods: widget.foods),
              ),
            ),
            child: Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.searchBg,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: AppColors.textGrey, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    'Search dishes, meals, cuisines',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textHint,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('All Categories', style: AppTextStyles.sectionTitle),
              Row(
                children: [
                  const Text(
                    'See All',
                    style: TextStyle(
                      fontFamily: 'Sen',
                      fontSize: 14,
                      color: AppColors.textBody,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: AppColors.textBody,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 60,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _categories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (ctx, i) {
              final cat = _categories[i];
              final isSelected = cat == _selectedCategory;
              return GestureDetector(
                onTap: () => setState(() => _selectedCategory = cat),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryLight : Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 12,
                        offset: const Offset(4, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.grey.shade400,
                          shape: BoxShape.circle,
                        ),
                        child: const SizedBox(),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        cat,
                        style: TextStyle(
                          fontFamily: 'Sen',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textBody,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, String action, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.sectionTitle),
          GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                Text(
                  action,
                  style: const TextStyle(
                    fontFamily: 'Sen',
                    fontSize: 14,
                    color: AppColors.textBody,
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: AppColors.textBody,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodCard(FoodItem food) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetailScreen(
            food: food,
            onToggleFavorite: widget.onToggleFavorite,
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image / hero area
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: FoodCardPlaceholder(
                    colorIndex: food.colorIndex,
                    imageAssetPath: food.imageAssetPath,
                    width: double.infinity,
                    height: 200,
                    borderRadius: 12,
                  ),
                ),
                // Favorite button
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () => widget.onToggleFavorite(food),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        food.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: food.isFavorite
                            ? Colors.red
                            : AppColors.textGrey,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              food.dishName,
              style: const TextStyle(
                fontFamily: 'Sen',
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: AppColors.textTitle,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${food.ingredients.split(';').take(4).join(', ')}...',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textLight,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            StarRatingRow(rating: food.rating, cookTime: food.cookTime),
          ],
        ),
      ),
    );
  }
}
