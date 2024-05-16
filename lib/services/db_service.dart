import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/ingredient.dart';

class DbService{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<List<Ingredient>> getIngredientsFromFirestore() async {
    print("db ilk");
    QuerySnapshot snapshot = await _firestore.collection('ingredients').get();
    print("snapshot: $snapshot");
    return snapshot.docs.map((doc) => Ingredient.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

}