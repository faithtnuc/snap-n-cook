import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:snapncook/models/ingredient.dart';
import '../models/recipe.dart';
import '../services/db_service.dart';
import 'package:cloud_functions/cloud_functions.dart';

class RecommendedRecipesProvider extends ChangeNotifier {
  DbService dbService = DbService();

  List<Recipe> recommendedRecipes = [];

  Future<List<Recipe>> fetchRecommendedRecipes(List<Ingredient> ingredients) async {

    final List<String> ingredientLabels = ingredients.map((ingredient) => ingredient.label.toLowerCase()).toList(); //Get user ingredients to send cloud function

    HttpsCallableResult<dynamic> results = await dbService.fetchRecommendedRecipes(ingredientLabels); //Fetch data from cloud functions using user ingredients

    String resultString = jsonEncode(results.data); //Convert functions data to string
    Map<String,dynamic> resultMap = jsonDecode(resultString); //Convert string to dart map
    List<Map<String, dynamic>> recipesData = resultMap["recommendedRecipes"].cast<Map<String, dynamic>>(); //Get recipes from result map


    recommendedRecipes = (recipesData)
        .map((Map<String, dynamic> data) =>
            Recipe.fromMap(data)) // Convert fetched data to Recipe objects
        .toList();

    return recommendedRecipes;
  }
}