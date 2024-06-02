import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:snapncook/providers/recommended_recipes_provider.dart';
import 'package:snapncook/utils/constants.dart';
import 'package:snapncook/views/recommended_recipes_view.dart';
import 'package:snapncook/widgets/ingredient_list_item.dart';
import '../models/ingredient.dart';
import '../providers/ingredient_list_provider.dart';

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
                      ? buildIngredientsListView(ingredientListProvider, context)
                      : buildEmptyListView(context)),
          floatingActionButton:
              context.watch<IngredientListProvider>().myIngredients.isNotEmpty
                  ? FloatingActionButton(
                      child: const Icon(Icons.arrow_forward),
                      onPressed: () => goToRecommendedRecipesView(context),
                    )
                  : const SizedBox.shrink(),
        ));
  }

  buildIngredientsListView(IngredientListProvider ingredientListProvider, context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.2.h, horizontal: 4.w),
      child: SingleChildScrollView(
        child: Wrap(spacing: 0.8.w, runSpacing: 0.6.h, children: [
          ...ingredientListProvider.myIngredients.map((ingredient) {
            return IngredientListItem(ingredient: ingredient, ingredientListProvider: ingredientListProvider);
          }),
          InkWell(
            customBorder: const CircleBorder(),
            onTap: () => showIngredientSelectionDialog(context),
            child: Container(
              margin: EdgeInsets.only(top: 0.2.h),
              padding: EdgeInsets.symmetric(vertical: 4.sp, horizontal: 10.sp),
              decoration: kMyIngredientsDecoration,
              child: Text(
                " + ",
                style: kMyIngredientsListTextStyle,
              ),
            ),
          )
        ]),
      ),
    );
  }

  Column buildEmptyListView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
            width: 20.w,
            height: 24.h,
            assetName,
            semanticsLabel: 'Empty Fridge'),
        Padding(
          padding:
              EdgeInsets.only(top: 2.h, left: 12.w, right: 12.w, bottom: 0.8.h),
          child: Text(
            textAlign: TextAlign.center,
            "Malzeme listeniz boş. Eklemek için aşağıdaki butona tıklayınız",
            style: kPrimaryTextStyle,
          ),
        ),
        InkWell(
          customBorder: const CircleBorder(),
            onTap: () => showIngredientSelectionDialog(context),
            child: Container(
              padding: EdgeInsets.all(8.sp),
              decoration: kEmptyListBoxDecoration,
              child: Text("Malzeme Ekle", style: kPrimaryButtonTextStyle,
            ),),)
      ],
    );
  }

  void showIngredientSelectionDialog(BuildContext context) async {
    showCupertinoModalBottomSheet(
        enableDrag: false,
        backgroundColor: kSecondaryBackgroundColor,
        context: context,
        builder: (context) => Consumer<IngredientListProvider>(
              builder: (BuildContext context, ingredientListProvider,
                  Widget? child) {
                return FutureBuilder(
                    future:
                        ingredientListProvider.getAllIngredientsFromFirestore(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting &&
                          ingredientListProvider.allIngredients.isEmpty) {
                        return SizedBox(
                            height: 10.h,
                            child: Center(
                                child: kProgressIcon));
                      }

                      if (snapshot.hasError) {
                        //print(snapshot.error);
                        return const Center(
                            child: Text('Malzeme listesi getirilirken hata oluştu.'));
                      }

                      List<Ingredient> availableIngredients = [];
                      if (snapshot.hasData && snapshot.data != null) {
                        availableIngredients = snapshot.data!;
                      }

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: availableIngredients.length,
                              itemBuilder: (context, index) {
                                final ingredient = availableIngredients[index];
                                return Material(
                                  child: CheckboxListTile(
                                    activeColor: kOrangeColor,
                                    checkColor: Colors.black,
                                    tileColor: Colors.grey.shade900,
                                    contentPadding: EdgeInsets.only(left: 6.w),
                                    overlayColor: WidgetStateProperty.all(Colors.red),
                                    checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                    title:
                                        Text(availableIngredients[index].label, style: TextStyle(color: Colors.white, fontSize: 16.sp),),
                                    value: ingredientListProvider
                                        .isIngredientSelected(ingredient),
                                    onChanged: (val) {
                                      context
                                          .read<IngredientListProvider>()
                                          .toggleIngredientSelection(
                                              ingredient);
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.sp),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(kOrangeColor),
                                foregroundColor: WidgetStateProperty.all(kSecondaryTextColor),
                              ),
                                onPressed: () {
                                  ingredientListProvider
                                      .addSelectedIngredientsToMyIngredients();
                                  Navigator.pop(context);
                                },
                                child: Text("Tamam", style: kPrimaryButtonTextStyle,)),
                          )
                        ],
                      );
                    });
              },
            ));
  }

  void goToRecommendedRecipesView(context) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
                create: (context) => RecommendedRecipesProvider(),
                child: RecommendedRecipesView(
                    context.read<IngredientListProvider>().myIngredients),
              )),
    );
  }
}
