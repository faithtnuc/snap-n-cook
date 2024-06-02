import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../models/ingredient.dart';
import '../providers/ingredient_list_provider.dart';
import '../utils/constants.dart';

class IngredientListItem extends StatelessWidget {
  final Ingredient ingredient;
  final IngredientListProvider ingredientListProvider;

  const IngredientListItem({super.key, required this.ingredient, required this.ingredientListProvider});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 0.2.h),
      padding: EdgeInsets.symmetric(vertical: 4.sp, horizontal: 10.sp),
      decoration: kMyIngredientsDecoration,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            ingredient.label,
            style: kMyIngredientsListTextStyle,
          ),
          SizedBox(width: 1.6.w,),
          InkWell(onTap: ()=> ingredientListProvider.removeIngredient(ingredient),child: Icon(Icons.remove_circle_outline, color: Colors.red.shade900, size: 18.sp,))
        ],
      ),
    );
  }
}