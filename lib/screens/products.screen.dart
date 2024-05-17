import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopv2/models/produit.dart';
import 'package:shopv2/screens/product_details.dart';

import '../cards/transparent_image_card.dart';

class Productscreen extends StatefulWidget {
  final String title;

  const Productscreen({super.key, required this.title});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<Productscreen> {
  late String _currentTitle;

  @override
  void initState() {
    super.initState();
    _currentTitle = widget.title;
  }

  @override
  void didUpdateWidget(covariant Productscreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.title != widget.title) {
      setState(() {
        _currentTitle = widget.title;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double price  ;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(_currentTitle,style:TextStyle(
          color: Colors.black
        ) ,),

      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _currentTitle,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('shoes').where('categoryId',isEqualTo: _currentTitle ).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final shoes = snapshot.data?.docs;
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 10 ,mainAxisSpacing: 60),
                    itemCount: shoes!.length,
                    itemBuilder: (context, index) {
                      var shoe = shoes[index];
                      price = double.parse(shoe['price']);
                      return GestureDetector(
                        onTap: () {
                          // Navigate to product details page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>  DetailPage(produit: Produit(Produit.fromSnapshot(shoe).id, Produit.fromSnapshot(shoe).name, Produit.fromSnapshot(shoe).image, Produit.fromSnapshot(shoe).description, Produit.fromSnapshot(shoe).price, Produit.fromSnapshot(shoe).categoryId,Produit.fromSnapshot(shoe).quantity)),
                            ),
                          );
                        },
                        child: TransparentImageCard(
                          borderRadius: 20,
                          width: 200,
                          imageProvider: NetworkImage(shoe['image']),
                          title: Text(
                            shoe['name'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Set text color to white
                            ),
                          ),
                          price: Text(
                            shoe['price'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Set text color to white
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
