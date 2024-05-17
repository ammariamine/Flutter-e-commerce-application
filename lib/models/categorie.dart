import 'package:cloud_firestore/cloud_firestore.dart';

class Categorie {
  late String id;
  late String name;
  late String image;

  Categorie(this.id,this.name,this.image);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<List<Object?>> getProductsByCategory(String category) async {
    try {
      // Query the categories collection to get document ID(s) of the category/categories
      QuerySnapshot categorySnapshot = await _firestore.collection('catagories').where('name', isEqualTo: category).get();

      // Extract document IDs from the categorySnapshot
      List<String> categoryIds = categorySnapshot.docs.map((doc) => doc.id).toList();

      // Query the shoes collection to get products with matching category IDs
      QuerySnapshot productSnapshot = await _firestore.collection('shoes').where('categoryId', whereIn: categoryIds).get();

      // Extract product data from productSnapshot
      List<Object?> products = productSnapshot.docs.map((doc) => doc.data()).toList();

      return products;
    } catch (e) {
      // Handle errors
      print('Error fetching products: $e');
      return [];
    }
  }
}