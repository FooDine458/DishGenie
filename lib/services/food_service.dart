// lib/services/food_service.dart

import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import '../models/food_model.dart';

class FoodService {
  static List<FoodItem>? _cachedItems;

  static Future<List<FoodItem>> loadFoods() async {
    if (_cachedItems != null) return _cachedItems!;

    final rawData = await rootBundle.loadString('assets/data/khmer_food.csv');
    // Normalize Windows line endings to avoid parsing issues across platforms.
    final normalized = rawData.replaceAll('\r\n', '\n').replaceAll('\r', '\n');

    final List<List<dynamic>> rows = const CsvToListConverter(
      eol: '\n',
      shouldParseNumbers: false,
    ).convert(normalized);

    // Skip header row
    _cachedItems = rows
        .skip(1)
        .where((row) => row.isNotEmpty)
        .where((row) => row.any((cell) => cell.toString().trim().isNotEmpty))
        .where((row) => row.length >= 5)
        .map((row) {
          try {
            return FoodItem.fromCsvRow(row);
          } catch (_) {
            // Skip malformed rows instead of crashing.
            return null;
          }
        })
        .whereType<FoodItem>()
        .toList(growable: false);

    return _cachedItems!;
  }

  static List<FoodItem> searchFoods(List<FoodItem> foods, String query) {
    if (query.isEmpty) return foods;
    final lower = query.toLowerCase();
    return foods.where((f) =>
      f.dishName.toLowerCase().contains(lower) ||
      f.description.toLowerCase().contains(lower) ||
      f.ingredients.toLowerCase().contains(lower)
    ).toList();
  }
}
