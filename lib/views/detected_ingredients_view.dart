import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snapncook/providers/detector_provider.dart';
import 'package:snapncook/views/detector_view.dart';

import '../models/ingredient.dart';
import '../providers/ingredient_list_provider.dart';
import '../widgets/ingredient_list_item.dart';

class DetectedIngredientsView extends StatelessWidget {
  const DetectedIngredientsView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Ingredients'),
          ),
          body: Consumer<IngredientListProvider>(
            builder: (context, ingredientListProvider, child) =>
                ingredientListProvider.ingredients.isNotEmpty
                    ? ListView.builder(
                        itemCount:
                            ingredientListProvider.ingredients.length + 1,
                        itemBuilder: (context, index) {
                          if (index ==
                                  ingredientListProvider.ingredients.length &&
                              ingredientListProvider.ingredients.isNotEmpty) {
                            return TextButton(
                                onPressed: () =>
                                    showIngredientSelectionDialog(context),
                                child: Text("Add Ingredient"));
                          } else {
                            return IngredientListItem(
                              ingredient:
                                  ingredientListProvider.ingredients[index],
                              index: index,
                            );
                          }
                        },
                      )
                    : Center(
                        child: Text(
                        "Bu silah boş",
                        style: TextStyle(fontSize: 50),
                      )),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.arrow_forward),
            onPressed: () {},
          ),
        ));
  }

  void showIngredientSelectionDialog(BuildContext context) async {
    showDialog(
      context: context,
      //barrierDismissible: false, // Prevent closing dialog while loading
      builder: (BuildContext context) {
        return Consumer<IngredientListProvider>(
          builder:
              (BuildContext context, ingredientListProvider, Widget? child) {
            return AlertDialog(
              title: Text("Select Ingredient"),
              content: FutureBuilder(
                future: ingredientListProvider.getIngredientsFromFirestore(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Ingredient>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return const Center(child: Text('Error getting ingredients'));
                  }

                  List<Ingredient> availableIngredients = [];
                  if(snapshot.hasData){
                   availableIngredients = snapshot.data!;
                  }


                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: availableIngredients.length,
                    itemBuilder: (context, index){
                      return ListTile(title: Text(availableIngredients[index].label));
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
