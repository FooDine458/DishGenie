import 'package:flutter_test/flutter_test.dart';
import 'package:moblie_app/models/food_model.dart';

void main() {
  group('FoodItem ingredient matching', () {
    final baiSachChrouk = FoodItem(
      no: 7,
      dishName: 'Bai Sach Chrouk (Pork and Rice)',
      description: 'Breakfast pork and rice.',
      ingredients:
          '500g pork shoulder, thinly sliced; 1 cup coconut milk; 3 cloves garlic, minced; 2 tbsp soy sauce; 1 tbsp sugar; Cooked rice; Pickled vegetables',
      instructions: '1. Marinate. | 2. Grill. | 3. Serve.',
    );

    test('matches when all four selected ingredients exist', () {
      expect(
        baiSachChrouk.matchesAllIngredients([
          'Pork',
          'Rice',
          'Garlic',
          'Coconut Milk',
        ]),
        isTrue,
      );
    });

    test(
      'does not match when only three of four selected ingredients exist',
      () {
        expect(
          baiSachChrouk.matchesAllIngredients([
            'Pork',
            'Rice',
            'Garlic',
            'Egg',
          ]),
          isFalse,
        );
      },
    );

    test('matches regardless of casing', () {
      expect(baiSachChrouk.matchesIngredientQuery('pOrK'), isTrue);
      expect(baiSachChrouk.matchesIngredientQuery('COCONUT milk'), isTrue);
    });

    test('matches normalized ingredient phrases with quantities removed', () {
      expect(
        FoodItem.normalizeIngredientText('500g pork shoulder, thinly sliced'),
        'pork shoulder',
      );
      expect(baiSachChrouk.matchesIngredientQuery('Pork'), isTrue);
    });
  });
}
