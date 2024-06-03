import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:snapncook/models/recipe.dart';
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
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          Stack(
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
                            backgroundColor: WidgetStateProperty.all(
                                Colors.black54)),
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
          ),
          SizedBox(
            height: 2.h,
          ),
          SizedBox(
            height: 2.h,
          ),
          SizedBox(
            height: 10.h,
            child: ListView.builder(
              itemCount: recipe.ingredients.length,
              itemBuilder: (BuildContext context, int index) {
                var ingredient = recipe.ingredients[index];
                return Text(
                    "${ingredient["amount"]} ${ingredient["unit"]} ${ingredient["ingredient"]} ${ingredient["properties"]}");
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: recipe.instructions.length,
              itemBuilder: (BuildContext context, int index) {
                var instructionLine = recipe.instructions[index];
                return Text(instructionLine);
              },
            ),
          )
        ],
      ),
    );
  }
}
