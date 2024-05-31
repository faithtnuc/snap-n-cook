import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:snapncook/providers/recommended_recipes_provider.dart';
import 'package:snapncook/utils/constants.dart';
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
          backgroundColor: kBackgroundColor,
          appBar: AppBar(
            backgroundColor: kBackgroundColor,
            title: const Text('Malzemelerim', style: kAppBarTitleStyle),
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
                children: [
                  SvgPicture.asset(
                      width: 20.w,
                      height: 24.h,
                      assetName,
                      semanticsLabel: 'Empty Fridge'
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 2.h, left: 12.w, right: 12.w, bottom: 0.8.h),
                    child: Text(
                      textAlign: TextAlign.center,
                      "Malzeme listeniz boş. Eklemek için aşağıdaki butona tıklayınız",
                      style: kPrimaryTextStyle,
                    ),
                  ),
                  GestureDetector(onTap: () => showIngredientSelectionDialog(context),child: Container(padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),decoration: kEmptyListBoxDecoration, child: const Text("Malzeme Ekle"),))
                ],
              ),
          ),
          floatingActionButton: context.watch<IngredientListProvider>().myIngredients.isNotEmpty ? FloatingActionButton(
            child: const Icon(Icons.arrow_forward),
            onPressed: ()=> goToRecommendedRecipesView(context),
          ) : const SizedBox.shrink(),
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