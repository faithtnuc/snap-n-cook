class Recipe {
  final String recipeId;
  final String recipeName;
  final String recipeImage;
  final List<Map> ingredients;
  final List<String> instructions;
  final String servingSize;
  final String prepTime;
  final String cookTime;
  final double matchPercentage;

  const Recipe(this.recipeId, this.recipeName, this.recipeImage, this.ingredients, this.instructions, this.servingSize, this.prepTime, this.cookTime, this.matchPercentage);

    Recipe.fromMap(Map<String, dynamic> map)
      : recipeId = map['recipeId'],
        recipeName = map['recipeName'],
        recipeImage = map['recipeImage'],
        ingredients = map['ingredients'].cast<Map<String, dynamic>>(),
        instructions = map['instructions'].cast<String>(),
        servingSize = map['servingSize'],
        prepTime = map['prepTime'],
        cookTime = map['cookTime'],
        matchPercentage = double.parse("${map['matchPercentage']}");

  @override
  String toString() {
    return 'Recipe{recipeId: $recipeId, recipeName: $recipeName, recipeImage: $recipeImage, ingredients: $ingredients, instructions: $instructions, servingSize: $servingSize, prepTime: $prepTime, cookTime: $cookTime, matchPercentage: $matchPercentage}';
  }
}
