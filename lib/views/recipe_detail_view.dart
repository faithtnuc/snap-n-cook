import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:snapncook/models/recipe.dart';

class RecipeDetailView extends StatelessWidget {
  const RecipeDetailView(this.recipe, {super.key});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: ()=> Navigator.pop(context)),
        title: const Text("Tarif Detay"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Image.network(recipe.recipeImage),
          SizedBox(height: 2.h,),
          Text(recipe.recipeName),
          SizedBox(height: 2.h,),
          SizedBox(
            height: 10.h,
            child: ListView.builder(itemCount: recipe.ingredients.length, itemBuilder: (BuildContext context, int index) {
              var ingredient = recipe.ingredients[index];
              return Text("${ingredient["amount"]} ${ingredient["unit"]} ${ingredient["ingredient"]} ${ingredient["properties"]}");
            },),
          ),
          Expanded(
            child: ListView.builder(itemCount: recipe.instructions.length, itemBuilder: (BuildContext context, int index) {
              var instructionLine = recipe.instructions[index];
              return Text(instructionLine);
            },),
          )
        ],
      ),
    );
  }
}
