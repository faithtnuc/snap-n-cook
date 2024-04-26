import 'package:flutter/foundation.dart';

import '../models/ingredient.dart';

class IngredientListProvider extends ChangeNotifier {
  final List<Ingredient> _ingredients = [];

  List<Ingredient> get ingredients => _ingredients;

  void addIngredient(String name, double confidence) {
    _ingredients.add(Ingredient(name, confidence));
    notifyListeners(); // Notify listeners about the change
  }

  void removeIngredient(Ingredient ingredient) {
    _ingredients.remove(ingredient);
    notifyListeners();
  }

  void clearIngredients() {
    _ingredients.clear();
    notifyListeners();
  }
}
