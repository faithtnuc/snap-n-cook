import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:snapncook/services/db_service.dart';

import '../models/ingredient.dart';

class IngredientListProvider extends ChangeNotifier {
  DbService dbService = DbService();
  final List<Ingredient> _ingredients = [Ingredient("Biber", 100, Rect.zero)];

  List<Ingredient> get ingredients => _ingredients;

  void addIngredient(String name, double confidence, Rect boundingBox) {
    _ingredients.add(Ingredient(name, confidence, boundingBox));
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

  Future<List<Ingredient>> getIngredientsFromFirestore() async {
    return await dbService.getIngredientsFromFirestore();
  }

}
