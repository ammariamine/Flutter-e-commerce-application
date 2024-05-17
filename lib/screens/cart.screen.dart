import 'package:flutter/material.dart';
import 'package:shopv2/screens/payment.screen.dart';
import 'package:shopv2/screens/profile.dart';
import 'package:shopv2/screens/categorie.screen.dart';
import '../../models/produit.dart';
import '../models/cart.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Produit> products = Cart.getCartItems();

    double totalPrice = 0;
    for (var product in products) {
      totalPrice += double.parse(product.price)*int.parse(product.quantity);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                Produit product = products[index];
                double productTotalPrice =
                double.parse(product.price)*int.parse(product.quantity);
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    leading: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(product.image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(product.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Price: \$${product.price}'),
                        Text('Quantity: ${product.quantity}'),
                        Text('Total: \$${productTotalPrice.toStringAsFixed(2)}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _showDeleteConfirmationDialog(context, product);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Total Price: \$${totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>PaymentScreen(totalPrice: totalPrice,)),);
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
                      Icon(Icons.payment_outlined, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        'Proceed To Payment',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    _showEmptyCartConfirmationDialog(context);
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
                      Icon(Icons.remove_shopping_cart_rounded, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        'Empty Cart',
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
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Profile screen index
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 8.0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
            // Navigate to Categories screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CategoriesPage()),
              );
              break;
            case 1:
            // Navigate to Cart screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
              break;
            case 2:
            // Navigate to Profile screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
              break;
          }
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Produit product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to remove ${product.name} from your cart?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>CartScreen()),);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Cart.removeCartItem(product);
                Navigator.of(context).pop();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>CartScreen()),);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showEmptyCartConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Empty Cart'),
          content: Text('Are you sure you want to empty your cart?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },

              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Cart.clearCart();
                Navigator.of(context).pop();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>CartScreen()),);
              },
              child: Text('Empty Cart'),
            ),
          ],
        );
      },
    );
  }
}
