import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ingredient_list_provider.dart';
import '../widgets/ingredient_list_item.dart';

class DetectedIngredientsView extends StatelessWidget {
  const DetectedIngredientsView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(canPop: false, child: Scaffold(
      appBar: AppBar(
        title: Text('Ingredients'),
      ),
      body: Consumer<IngredientListProvider>(
        builder: (context, ingredientListProvider, child) =>
            ingredientListProvider.ingredients.isNotEmpty ?
            ListView.builder(
              itemCount: ingredientListProvider.ingredients.length + 1,
              itemBuilder: (context, index) {
                if(index == ingredientListProvider.ingredients.length && ingredientListProvider.ingredients.isNotEmpty){
                  return TextButton(onPressed: (){}, child: Text("Add Ingredient"));
                }else{
                  return IngredientListItem(
                    ingredient: ingredientListProvider.ingredients[index],
                    index: index,
                  );
                }
              },
            ) : Center(child: Text("Bu silah boş", style: TextStyle(fontSize: 50),)),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward),
        onPressed: () {},
      ),
    ));
  }
}