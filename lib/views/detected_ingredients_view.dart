import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:snapncook/providers/recommended_recipes_provider.dart';
import 'package:snapncook/views/recommended_recipes_view.dart';
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
            title: const Text('Ingredients'),
          ),
          body: Consumer<IngredientListProvider>(
            builder: (context, ingredientListProvider, child) =>
            ingredientListProvider.myIngredients.isNotEmpty
                ? ListView.builder(
              itemCount:
              ingredientListProvider.myIngredients.length + 1,
              itemBuilder: (context, index) {
                if (index ==
                    ingredientListProvider.myIngredients.length &&
                    ingredientListProvider.myIngredients.isNotEmpty) {
                  return TextButton(
                      onPressed: () =>
                          showIngredientSelectionDialog(context),
                      child: const Text("Add Ingredient"));
                } else {
                  return IngredientListItem(
                    ingredient:
                    ingredientListProvider.myIngredients[index],
                    index: index,
                  );
                }
              },
            )
                :
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    textAlign: TextAlign.center,
                    "Liste boş",
                    style: TextStyle(fontSize: 50),
                  ),
                  TextButton(onPressed: () => showIngredientSelectionDialog(context), child: const Text("Malzeme Ekle"),)
                ],
              ),
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.arrow_forward),
            onPressed: ()=> goToRecommendedRecipesView(context),
          ),
        ));
  }

  void showIngredientSelectionDialog(BuildContext context) async {
    showCupertinoModalBottomSheet(
        expand: false,
        context: context, builder: (context)=> Consumer<IngredientListProvider>(
      builder:
          (BuildContext context, ingredientListProvider, Widget? child) {
        return FutureBuilder(future: ingredientListProvider.getAllIngredientsFromFirestore(), builder: (context, snapshot){

          if (snapshot.connectionState == ConnectionState.waiting && ingredientListProvider.allIngredients.isEmpty) {
            return SizedBox(height: 10.h,child: Center(child: SizedBox(height: 2.6.h, width: 2.6.h,child: const CircularProgressIndicator())));
          }

          if (snapshot.hasError) {
            //print(snapshot.error);
            return const Center(child: Text('Error getting ingredient list'));
          }

          List<Ingredient> availableIngredients = [];
          if(snapshot.hasData && snapshot.data != null) {
            availableIngredients = snapshot.data!;
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true, // Prevent dialog from expanding excessively
                  itemCount: availableIngredients.length,
                  itemBuilder: (context, index) {
                    final ingredient = availableIngredients[index];
                    return Material(
                      child: CheckboxListTile(
                        title: Text(availableIngredients[index].label),
                        value: ingredientListProvider.isIngredientSelected(ingredient),
                        onChanged: (val) {
                          context.read<IngredientListProvider>().toggleIngredientSelection(ingredient);
                        },
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.sp),
                child: ElevatedButton(onPressed: (){
                  ingredientListProvider.addSelectedIngredientsToMyIngredients();
                  Navigator.pop(context);
                  }, child: const Text("DONE")),
              )
            ],
          );
        });
      },
    )
    );
  }

  goToRecommendedRecipesView(context) {
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
              create: (context) => RecommendedRecipesProvider(),
              child: RecommendedRecipesView(context.read<IngredientListProvider>().myIngredients),
            )),
            );
  }
}