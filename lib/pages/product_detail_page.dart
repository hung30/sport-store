import 'dart:convert';

import 'package:ck/pages/menu_components_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                product['image'],
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),
            Text(
              product['name'],
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 8),
            Text(
              'Price: ${product['price']}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Add to cart functionality
                _addToCart(product, context);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Color.fromARGB(255, 6, 0, 0),
                backgroundColor:
                    Color.fromARGB(255, 54, 124, 244), // Text color
                elevation: 0, // Remove shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0), // No border radius
                ),
              ),
              child: Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addToCart(
      Map<String, dynamic> product, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final String cartJson = prefs.getString('cart') ?? '[]';
    List<Map<String, dynamic>> cart =
        json.decode(cartJson).cast<Map<String, dynamic>>();

    // Check if product is already in cart
    int index = cart.indexWhere((item) => item['name'] == product['name']);
    if (index != -1) {
      // Update quantity if product is already in cart
      cart[index]['quantity'] += 1;
    } else {
      // Add new product to cart
      cart.add({...product, 'quantity': 1});
    }

    await prefs.setString('cart', json.encode(cart));

    // Update cart quantity notifier
    _updateCartQuantity(cart);

    // Show a snackbar for successful addition
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Added to cart!'),
      duration: Duration(seconds: 2),
    ));
  }

  void _updateCartQuantity(List<Map<String, dynamic>> cart) {
    int totalQuantity =
        cart.fold(0, (int sum, item) => sum + (item['quantity'] as int));
    cartQuantityNotifier.value = totalQuantity;
  }
}
