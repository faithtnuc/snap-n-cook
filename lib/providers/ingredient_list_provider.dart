import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:snapncook/services/db_service.dart';

import '../models/ingredient.dart';

class IngredientListProvider extends ChangeNotifier {
  DbService dbService = DbService();

  final List<Ingredient> _myIngredients = [];
  List<Ingredient> _allIngredients = [];

  List<Ingredient> get myIngredients => _myIngredients;
  List<Ingredient> get allIngredients => _allIngredients;



  void addIngredient(String name, double confidence, Rect boundingBox) {
    _myIngredients.add(Ingredient(name, confidence, boundingBox));
    notifyListeners(); // Notify listeners about the change
  }

  void removeIngredient(Ingredient ingredient) {
    _myIngredients.remove(ingredient);
    _allIngredients.add(ingredient);
    _allIngredients.sort((a,b) => a.label.compareTo(b.label)); //Sort all ingredients list alphabetically by label.
    notifyListeners();
  }

  void clearIngredients() {
    _myIngredients.clear();
    notifyListeners();
  }

  Future<List<Ingredient>> getAllIngredientsFromFirestore() async {
    if(_allIngredients.isNotEmpty){
      return _allIngredients;
    }
    try{
      _allIngredients = await dbService.getIngredientsFromFirestore();
      _allIngredients.removeWhere((ingredient)=> _myIngredients.any((myIngredient) => myIngredient.label == ingredient.label)); //Removing my ingredients from all Ingredients list.
      return _allIngredients;
    }catch(e){
      throw Exception(e);
    }finally{
      notifyListeners();
    }
  }

  void addSelectedIngredientsToMyIngredients(){
    _myIngredients.addAll(_selectedIngredients);
    _myIngredients.sort((a,b) => a.label.compareTo(b.label)); //Sort my ingredients list alphabetically by label.
    _allIngredients.removeWhere((ingredient)=> _selectedIngredients.any((selectedIngredient) => selectedIngredient.label == ingredient.label)); //Remove selected ingredients from all Ingredients list.
    _selectedIngredients.clear(); //Clear selected Ingredients.
    notifyListeners();
  }

  //CHECKBOX
  final List<Ingredient> _selectedIngredients = [];

  bool isIngredientSelected(Ingredient ingredient) {
    return _selectedIngredients.any((element) => ingredient.label == element.label); // Default to false
  }

  void toggleIngredientSelection(Ingredient ingredient) {
    bool isContains = _selectedIngredients.any((element) => ingredient.label == element.label);
    if(isContains){
      _selectedIngredients.removeWhere((element)=> element.label == ingredient.label);
    }else{
      _selectedIngredients.add(ingredient);
    }
    notifyListeners();
  }

}
