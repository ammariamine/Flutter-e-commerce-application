import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopv2/screens/categorie.screen.dart';

import '../models/cart.dart';
import '../models/produit.dart';

class PaymentScreen extends StatelessWidget {
  final double totalPrice;

  const PaymentScreen({required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delivery & Payment'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height, // Set height to the full screen height
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Total Amount',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '\$$totalPrice', // Total amount
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.green, // Green color for total amount
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'Delivery Details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                DeliveryForm(),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    registerPayment(totalPrice, context);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.money, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        'Pay Now',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

   registerPayment(double totalPrice, BuildContext context) {}
}void registerPayment(double totalAmount, BuildContext context) async {
  // Get products from the cart
  List<Produit> products = Cart.getCartItems();

  // Get user email (replace it with your authentication mechanism)
  String userEmail = FirebaseAuth.instance.currentUser!.email.toString(); // Replace with actual user email

  // Register cart contents and total amount to Firestore
  await FirebaseFirestore.instance.collection('records').add({
    'userEmail': userEmail,
    'products': products.map((product) => product?.toMap()).toList(),
    'totalAmount': totalAmount,
    'timestamp': Timestamp.now(), // Add timestamp for sorting or querying purposes
  });

  // Clear the cart after successful payment
  Cart.clearCart();

  // Navigate back to the cart screen
  Navigator.push(context, MaterialPageRoute(builder: (context) => CategoriesPage()));
}


class DeliveryForm extends StatefulWidget {
  @override
  _DeliveryFormState createState() => _DeliveryFormState();
}

class _DeliveryFormState extends State<DeliveryForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _zipCodeController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _fullNameController,
            decoration: InputDecoration(
              labelText: 'Full Name',
              prefixIcon: Icon(Icons.person),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your full name';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: _addressController,
            decoration: InputDecoration(
              labelText: 'Delivery Address',
              prefixIcon: Icon(Icons.location_on),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your delivery address';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _cityController,
                  decoration: InputDecoration(
                    labelText: 'City',
                    prefixIcon: Icon(Icons.location_city),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your city';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: TextFormField(
                  controller: _stateController,
                  decoration: InputDecoration(
                    labelText: 'State',
                    prefixIcon: Icon(Icons.map),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your state';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _zipCodeController,
                  decoration: InputDecoration(
                    labelText: 'Zip Code',
                    prefixIcon: Icon(Icons.location_searching),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your zip code';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: TextFormField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


