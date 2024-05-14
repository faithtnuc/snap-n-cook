import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/ingredient.dart';
import '../providers/ingredient_list_provider.dart';

class IngredientListItem extends StatelessWidget {
  final Ingredient ingredient;
  final int index;

  const IngredientListItem({super.key, required this.ingredient, required this.index});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(ingredient.label),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.remove_circle),
          onPressed: () => context.read<IngredientListProvider>().removeIngredient(ingredient),
        ),
      ],
    );
  }
}