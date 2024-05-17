import 'package:cloud_firestore/cloud_firestore.dart';

class Produit  {
  late String id;
  late String name;
  late String image;
  late String description;
  late String price;
  late String categoryId;
  late String quantity ;
  Produit(this.id, this.name, this.image , this.description, this.price , this.categoryId,this.quantity);

  static Produit fromSnapshot(DocumentSnapshot produitSnapshot) {
    var data = produitSnapshot.data() as Map<String, dynamic>;
    return Produit(
      produitSnapshot.id,
      data['name'],
      data['image'],
      data['description'],
      data['price'],
      data['categoryId'],
      data['quantity'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'image': image,
      'quantity' : quantity,
    };
  }
}