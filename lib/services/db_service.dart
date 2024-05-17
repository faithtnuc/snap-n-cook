import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/ingredient.dart';

class DbService{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Ingredient>> getIngredientsFromFirestore() async {
    QuerySnapshot snapshot = await _firestore.collection('ingredients').get();
    return snapshot.docs.map((doc) => Ingredient.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

}