import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:snapncook/models/ingredient.dart';
import 'package:snapncook/providers/recommended_recipes_provider.dart';
import 'package:snapncook/utils/constants.dart';
import 'package:snapncook/views/recipe_detail_view.dart';
import 'package:snapncook/widgets/recommended_recipes_view/error_view.dart';

import '../models/recipe.dart';

class RecommendedRecipesView extends StatelessWidget {
  const RecommendedRecipesView(this.myIngredients, {super.key});

  final List<Ingredient> myIngredients;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        leading: BackButton(onPressed: ()=> Navigator.pop(context), color: kOrangeColor,),
        title: Text("Size Özel Tarifler", style: kPrimaryAppBarTextStyle),
        centerTitle: true,
      ),
      body: Consumer<RecommendedRecipesProvider>(builder: (BuildContext context, RecommendedRecipesProvider recommendedRecipesProvider, Widget? child) {
      return FutureBuilder(future: recommendedRecipesProvider.fetchRecommendedRecipes(myIngredients), builder: (context, snapshot){

        if (snapshot.connectionState == ConnectionState.waiting){
        return Center(child: kProgressIcon);
        }

        if (snapshot.hasError) {
        //print(snapshot.error);
        return const ErrorView("Tarifler getirilirken hata oluştu");
        }

        List<Recipe> recommendedRecipes = [];
        if(snapshot.hasData && snapshot.data != null) {
        recommendedRecipes = snapshot.data!;
        }

        if(recommendedRecipes.isEmpty){
          return const ErrorView("Elinizdeki malzemelere uygun bir yemek tarifi bulunamadı");
        }
        return ListView.builder(
          itemCount: recommendedRecipes.length, itemBuilder: (BuildContext context, int index) {
            Recipe recipe = recommendedRecipes[index];
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.2.h),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange.shade200, width: 0.8),
                borderRadius: BorderRadius.circular(12)
              ),
              child: ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                tileColor: Colors.grey.shade900,
                onTap: ()=> goToRecipeDetailPage(context, recipe),
                leading: Card(clipBehavior: Clip.antiAlias,child: Image.network(recipe.recipeImage)),
                title: Text(recipe.recipeName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.6.sp, color: Colors.white),),
                subtitle: Padding(
                  padding: EdgeInsets.only(top: 0.4.h),
                  child: Text("Hazırlama süresi: ${recipe.prepTime}\nPişirme süresi: ${recipe.cookTime}", style: TextStyle(color: Colors.grey.shade400, fontSize: 13.4.sp),),
                ),
                trailing: Column(
                  children: [
                    Text(recipe.servingSize, style: TextStyle(color: Colors.white, fontSize: 14.sp),),
                    Text("%${recipe.matchPercentage.round()} Eşleşme", style: TextStyle(color: kOrangeColor, fontSize: 14.sp),)
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
