import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
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
              '\$200.00', // Total amount
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.green, // Green color for total amount
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Select Payment Method',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            PaymentMethodTile(
              icon: Icons.credit_card, // Payment method icon
              title: 'Credit Card',
              onPressed: () {
                // Handle credit card payment
              },
            ),
            PaymentMethodTile(
              icon: Icons.payment, // Payment method icon
              title: 'PayPal',
              onPressed: () {
                // Handle PayPal payment
              },
            ),
            PaymentMethodTile(
              icon: Icons.account_balance_wallet, // Payment method icon
              title: 'Wallet',
              onPressed: () {
                // Handle wallet payment
              },
            ),
            Spacer(), // Spacer to push buttons to the bottom
            ElevatedButton(
              onPressed: () {
                // Process payment
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
    );
  }
}

class PaymentMethodTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onPressed;

  const PaymentMethodTile({
    required this.icon,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(icon),
            SizedBox(width: 20),
            Text(
              title,
              style: TextStyle(fontSize: 18),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios), // Arrow icon for navigation
          ],
        ),
      ),
    );
  }
}
