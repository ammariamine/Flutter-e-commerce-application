import 'models/produit.dart';

class Cart {
  static List<Produit> _cartItems = [];

  static void addItem(Produit produit) {
    _cartItems.add(produit);
  }

  static void removeCartItem(Produit produit) {
    _cartItems.remove(produit);
  }

  static List<Produit> getCartItems() {
    return _cartItems;
  }

  static void clearCart() {
    _cartItems.clear();
  }
}
