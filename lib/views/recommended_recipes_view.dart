import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:snapncook/models/ingredient.dart';
import 'package:snapncook/providers/recommended_recipes_provider.dart';
import 'package:snapncook/views/recipe_detail_view.dart';

import '../models/recipe.dart';

class RecommendedRecipesView extends StatelessWidget {
  const RecommendedRecipesView(this.myIngredients, {super.key});

  final List<Ingredient> myIngredients;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: ()=> Navigator.pop(context)),
        title: const Text("Size Özel Tarifler"),
        centerTitle: true,
      ),
      body: Consumer<RecommendedRecipesProvider>(builder: (BuildContext context, RecommendedRecipesProvider recommendedRecipesProvider, Widget? child) {
      return FutureBuilder(future: recommendedRecipesProvider.fetchRecommendedRecipes(myIngredients), builder: (context, snapshot){

        if (snapshot.connectionState == ConnectionState.waiting){
        return Center(child: SizedBox(height: 2.6.h, width: 2.6.h,child: const CircularProgressIndicator()));
        }

        if (snapshot.hasError) {
        //print(snapshot.error);
        return const Center(child: Text('Error getting ingredient list'));
        }

        List<Recipe> recommendedRecipes = [];
        if(snapshot.hasData && snapshot.data != null) {
        recommendedRecipes = snapshot.data!;
        }

        if(recommendedRecipes.isEmpty){
          return const Center(child: Text("Elinizdeki malzemelerle bir halt yapılmaz"),);
        }
        return ListView.builder(
          itemCount: recommendedRecipes.length, itemBuilder: (BuildContext context, int index) {
            Recipe recipe = recommendedRecipes[index];
            return Card(
              child: ListTile(
                onTap: ()=> goToRecipeDetailPage(context, recipe),
                leading: Image.network(recipe.recipeImage),
                title: Text(recipe.recipeName),
                subtitle: Text("Hazırlama süresi: ${recipe.prepTime}\nPişirme süresi: ${recipe.cookTime}"),
                trailing: Column(
                  children: [
                    Text(recipe.servingSize),
                    Text("%${recipe.matchPercentage.round()} Eşleşme")
                  ],
                ),
              ),
            );
        },
        );
      });
      }
    ));
  }

  goToRecipeDetailPage(context, Recipe recipe) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => RecipeDetailView(recipe),
    ));
  }
}
