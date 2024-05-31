import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../models/ingredient.dart';

class DbService{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Ingredient>> getIngredientsFromFirestore() async {
    QuerySnapshot snapshot = await _firestore.collection('ingredients').orderBy('label').get();
    return snapshot.docs.map((doc) => Ingredient.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<HttpsCallableResult<dynamic>> fetchRecommendedRecipes(List<String> ingredientLabels) async {
    final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
      'findMatchingRecipes', // Function name deployed to Cloud Functions
    );
    final results = await callable.call(<String, dynamic>{
      'ingredients': ingredientLabels,
    });

    return results;
  }

}