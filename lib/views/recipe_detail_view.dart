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
      /*appBar: AppBar(
        backgroundColor: kBackgroundColor,
        leading: BackButton(onPressed: ()=> Navigator.pop(context), color: kOrangeColor,),
        title: Text(recipe.recipeName, style: kPrimaryAppBarTextStyle,),
        centerTitle: true,
      ),*/
      body: SingleChildScrollView(
        child: SizedBox(
          height: 200.h,
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
              Expanded(
                child: DataTable(
                  horizontalMargin: 12.w,
                  dividerThickness: 0.2,
                  border: TableBorder.all(
                      color: Colors.white,
                      width: 0.2,
                      borderRadius: BorderRadius.circular(12)),
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
                ),
              ),
              /*ListView.builder(
                itemCount: recipe.instructions.length,
                itemBuilder: (BuildContext context, int index) {
                  var instructionLine = recipe.instructions[index];
                  return Text(instructionLine);
                },
              )*/
            ],
          ),
        ),
      ),
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
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(recipe.servingSize,
                  style: kRecipeDetailContainerTitleTextStyle),
              Text("Servis", style: kRecipeDetailContainerSubtitleTextStyle),
            ],
          ),
          kVerticalDivider,
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(recipe.prepTime,
                  style: kRecipeDetailContainerTitleTextStyle),
              Text("Hazırlama", style: kRecipeDetailContainerSubtitleTextStyle),
            ],
          ),
          kVerticalDivider,
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(recipe.cookTime,
                  style: kRecipeDetailContainerTitleTextStyle),
              Text("Pişirme", style: kRecipeDetailContainerSubtitleTextStyle),
            ],
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
