// lib/models/food_model.dart

class FoodItem {
  final int no;
  final String dishName;
  final String description;
  final String ingredients;
  final String instructions;
  bool isFavorite;

  FoodItem({
    required this.no,
    required this.dishName,
    required this.description,
    required this.ingredients,
    required this.instructions,
    this.isFavorite = false,
  });

  factory FoodItem.fromCsvRow(List<dynamic> row) {
    return FoodItem(
      no: int.tryParse(row[0].toString().trim()) ?? 0,
      dishName: row[1].toString().trim(),
      description: row[2].toString().trim(),
      ingredients: row[3].toString().trim(),
      instructions: row[4].toString().trim(),
    );
  }

  static final RegExp _numberPattern = RegExp(r'\b\d+(?:[./]\d+)?\b');
  static final RegExp _separatorPattern = RegExp(r'[^a-z]+');
  static const Set<String> _ignoredIngredientWords = {
    'g',
    'kg',
    'ml',
    'l',
    'tbsp',
    'tsp',
    'cup',
    'cups',
    'packet',
    'packets',
    'liter',
    'liters',
    'clove',
    'cloves',
    'tablespoon',
    'tablespoons',
    'teaspoon',
    'teaspoons',
    'small',
    'medium',
    'large',
    'minced',
    'diced',
    'sliced',
    'slice',
    'thinly',
    'finely',
    'cut',
    'cooked',
    'cooking',
    'peeled',
    'deveined',
    'shredded',
    'cubed',
    'quartered',
    'optional',
    'fresh',
    'for',
    'and',
    'or',
    'to',
    'taste',
    'serving',
    'drizzling',
    'into',
    'with',
    'the',
    'a',
    'an',
    'of',
  };

  static String normalizeIngredientText(String input) {
    final lowered = input.toLowerCase().replaceAll(_numberPattern, ' ');
    final pieces = lowered
        .split(_separatorPattern)
        .map((token) => token.trim())
        .where((token) => token.isNotEmpty)
        .where((token) => !_ignoredIngredientWords.contains(token))
        .toList(growable: false);

    return pieces.join(' ');
  }

  List<String> get normalizedIngredientEntries {
    return ingredients
        .split(';')
        .map(normalizeIngredientText)
        .where((entry) => entry.isNotEmpty)
        .toList(growable: false);
  }

  bool matchesIngredientQuery(String query) {
    final normalizedQuery = normalizeIngredientText(query);
    if (normalizedQuery.isEmpty) return false;

    final queryTokens = normalizedQuery.split(' ').toSet();
    return normalizedIngredientEntries.any((entry) {
      final entryTokens = entry.split(' ').toSet();
      return queryTokens.every(entryTokens.contains);
    });
  }

  bool matchesAllIngredients(Iterable<String> queries) {
    final normalizedQueries = queries
        .map(normalizeIngredientText)
        .where((query) => query.isNotEmpty)
        .toList(growable: false);

    if (normalizedQueries.isEmpty) return false;
    return normalizedQueries.every(matchesIngredientQuery);
  }

  List<IngredientItem> get ingredientList {
    return ingredients
        .split(';')
        .map((s) {
          final trimmed = s.trim();
          // Try to split into name and amount
          final parts = trimmed.split(',');
          if (parts.length >= 2) {
            // Check if first part has a quantity at start
            final match = RegExp(
              r'^(\d+[\w\s\.]*)\s+(.+)$',
            ).firstMatch(trimmed);
            if (match != null) {
              return IngredientItem(
                name: match.group(2)!.trim(),
                amount: match.group(1)!.trim(),
              );
            }
          }
          return IngredientItem(name: trimmed, amount: '');
        })
        .where((i) => i.name.isNotEmpty)
        .toList();
  }

  List<String> get instructionSteps {
    return instructions
        .split('|')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  // Derive cook time from instructions (simplified)
  String get cookTime {
    final match = RegExp(r'(\d+)\s*min').firstMatch(instructions);
    if (match != null) return '${match.group(1)} min';
    return '30 min';
  }

  double get rating => 4.0 + (no % 10) * 0.1;

  // Category based on dish name/description
  String get category {
    final lower = dishName.toLowerCase() + description.toLowerCase();
    if (lower.contains('soup') ||
        lower.contains('noodle') ||
        lower.contains('kuy')) {
      return 'Soup';
    }
    if (lower.contains('salad') || lower.contains('lahong')) {
      return 'Salad';
    }
    if (lower.contains('rice') || lower.contains('bai')) {
      return 'Rice';
    }
    if (lower.contains('dessert') ||
        lower.contains('jelly') ||
        lower.contains('sweet') ||
        lower.contains('cake')) {
      return 'Dessert';
    }
    if (lower.contains('curry')) {
      return 'Curry';
    }
    return 'Main';
  }

  // Color index for gradient placeholder
  int get colorIndex => no % 6;

  static const Map<int, String> _imageAssetByDishNo = {
    1: 'assets/images/fish-amok.png',
    2: 'assets/images/lok-lak.png',
    3: 'assets/images/curry.png',
    4: 'assets/images/banh-chok.png',
    5: 'assets/images/bok-lahong.png',
    6: 'assets/images/samlor-machu.png',
    7: 'assets/images/bay-sach-jruk.png',
    8: 'assets/images/kuy-teav.png',
    9: 'assets/images/jelly-dessert.png',
    10: 'assets/images/banh-chok.png',
  };

  String? get imageAssetPath => _imageAssetByDishNo[no];
}

class IngredientItem {
  final String name;
  final String amount;

  IngredientItem({required this.name, required this.amount});
}
