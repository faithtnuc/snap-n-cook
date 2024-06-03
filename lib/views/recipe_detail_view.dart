import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:snapncook/models/recipe.dart';
import 'package:snapncook/providers/ingredient_list_provider.dart';
import 'package:snapncook/utils/constants.dart';

class RecipeDetailView extends StatelessWidget {
  const RecipeDetailView(this.recipe, {super.key});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            buildRecipeImageStack(context),
            buildRecipeInfoContainer(),
            SizedBox(
              height: 0.8.h,
            ),
            buildIngredientsTable(context),
            SizedBox(
              height: 0.8.h,
            ),
            buildInstructionsContainer()
          ],
        ),
      ),
    );
  }

  Stack buildInstructionsContainer() {
    return Stack(
            children: [
              Container(
                margin: EdgeInsets.all(16.sp),
                decoration: BoxDecoration(
                  color: kSecondaryBackgroundColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 4.4.h,),
                    ...recipe.instructions.map((instruction){
                      int index = recipe.instructions.indexOf(instruction) + 1;
                      return ListTile(leading: Text("$index.", style: kInstructionsLeadingTextStyle), subtitle: Text(instruction, style: kInstructionsTextStyle),);
                    })
                  ],
                ),
              ),
              Positioned(
                top: 1.8.h,
                left: 3.2.w,
                child: Container(
                    padding: EdgeInsets.only(bottom: 0.4.h, top: 0.4.h, left: 4.w,),
                    width: 100.w,
                    color: Colors.black54,
                    child: Text(
                      "Nasıl Yapılır?",
                      style: kInstructionsTitleTextStyle,
                    )),
              )

            ],
          );
  }

  DataTable buildIngredientsTable(BuildContext context) {
    return DataTable(
      horizontalMargin: 12.w,
      dividerThickness: 0.2,
      columns: [
        DataColumn(
            label: Text(
          "Malzemeler",
          style: TextStyle(
              fontSize: 16.sp,
              color: kPrimaryTextColor,
              fontWeight: FontWeight.bold),
        )),
        DataColumn(
            label: Text(
          "Ölçüler",
          style: TextStyle(
              fontSize: 16.sp,
              color: kPrimaryTextColor,
              fontWeight: FontWeight.bold),
        ))
      ],
      rows: recipe.ingredients
          .map(
            (ingredientMap) => DataRow(
              cells: [
                DataCell(
                  Text(
                    ingredientMap['ingredient'],
                    style: TextStyle(
                        fontSize: 15.2.sp,
                        color: !context
                                .read<IngredientListProvider>()
                                .myIngredients
                                .any((myIngredient) =>
                                    myIngredient.label.toLowerCase() ==
                                    ingredientMap['ingredient']
                                        .toLowerCase())
                            ? Colors.red
                            : Colors.grey.shade400),
                  ),
                ),
                DataCell(Text(
                    '${ingredientMap['amount']} ${ingredientMap['unit']}',
                    style: TextStyle(
                        fontSize: 15.2.sp,
                        color: !context
                                .read<IngredientListProvider>()
                                .myIngredients
                                .any((myIngredient) =>
                                    myIngredient.label.toLowerCase() ==
                                    ingredientMap['ingredient']
                                        .toLowerCase())
                            ? Colors.red
                            : Colors.grey.shade400))),
              ],
            ),
          )
          .toList(),
    );
  }

  Container buildRecipeInfoContainer() {
    return Container(
      decoration: BoxDecoration(
          color: kSecondaryBackgroundColor,
          borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.symmetric(vertical: 0.8.h, horizontal: 8.w),
      height: 10.h,
      width: 100.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            flex: 1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(overflow: TextOverflow.ellipsis,recipe.servingSize,
                style: kRecipeDetailContainerTitleTextStyle),
                Text("Servis", style: kRecipeDetailContainerSubtitleTextStyle),
              ],
            ),
          ),
          kVerticalDivider,
          Flexible(
            flex: 1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(recipe.prepTime,
                    style: kRecipeDetailContainerTitleTextStyle),
                Text("Hazırlama", style: kRecipeDetailContainerSubtitleTextStyle),
              ],
            ),
          ),
          kVerticalDivider,
          Flexible(
            flex: 1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(recipe.cookTime,
                    style: kRecipeDetailContainerTitleTextStyle),
                Text("Pişirme", style: kRecipeDetailContainerSubtitleTextStyle),
              ],
            ),
          )
        ],
      ),
    );
  }

  Stack buildRecipeImageStack(BuildContext context) {
    return Stack(
      children: [
        Card(
          margin: EdgeInsets.all(10.sp),
          color: kOrangeColor,
          shadowColor: kOrangeColor,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              recipe.recipeImage,
              fit: BoxFit.cover,
              height: 30.h,
              width: 100.w,
            ),
          ),
        ),
        Positioned(
            top: 2.h,
            left: 4.w,
            child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: IconButton(
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.black54)),
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  color: kOrangeColor,
                ))),
        Positioned(
          bottom: 0.h,
          left: 0.w,
          child: Container(
              padding: EdgeInsets.only(bottom: 0.4.h, top: 0.4.h, left: 4.w),
              width: 100.w,
              color: Colors.black54,
              child: Wrap(
                children: [
                  Text(
                    recipe.recipeName,
                    style: kRecipeDetailTitleTextStyle.copyWith(
                        fontSize: 22.sp, fontWeight: FontWeight.bold),
                  ),
                ],
              )),
        )
      ],
    );
  }
}
