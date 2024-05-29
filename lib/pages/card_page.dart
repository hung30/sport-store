import 'dart:convert';
import 'package:ck/pages/menu_components_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late List<Map<String, dynamic>> _cart = [];

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final String cartJson = prefs.getString('cart') ?? '[]';
    setState(() {
      _cart = json.decode(cartJson).cast<Map<String, dynamic>>();
      _updateCartQuantity();
    });
  }

  Future<void> _removeItem(int index) async {
    setState(() {
      _cart[index]['quantity'] -= 1;
      if (_cart[index]['quantity'] == 0) {
        _cart.removeAt(index);
      }
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cart', json.encode(_cart));
    _updateCartQuantity();
  }

  Future<void> _addItem(int index) async {
    setState(() {
      _cart[index]['quantity'] += 1;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cart', json.encode(_cart));
    _updateCartQuantity();
  }

  void _updateCartQuantity() {
    int totalQuantity =
        _cart.fold(0, (int sum, item) => sum + (item['quantity'] as int));
    cartQuantityNotifier.value = totalQuantity;
  }

  int getTotalQuantity() {
    return _cart.fold(0, (sum, item) => sum + (item['quantity'] as int));
  }

  double getTotalPrice() {
    return _cart.fold(0, (sum, item) {
      // Remove non-numeric characters from the price string
      String priceString = item['price'].replaceAll(RegExp(r'[^\d.]'), '');
      double price = double.tryParse(priceString) ?? 0.0;
      return sum + (item['quantity'] as int) * price;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _cart.length,
              itemBuilder: (context, index) {
                final product = _cart[index];
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.orange),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: Image.network(product['image']!),
                    title: Text(product['name']!),
                    subtitle: Text('Price: ${product['price']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => _removeItem(index),
                          icon: const Icon(Icons.remove),
                        ),
                        Text('Qty: ${product['quantity']}'),
                        IconButton(
                          onPressed: () => _addItem(index),
                          icon: const Icon(Icons.add),
                        ),
                        IconButton(
                          onPressed: () => _removeItem(index),
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              color: Colors.black,
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Price: ${getTotalPrice().toStringAsFixed(3)} đ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Total Quantity: ${getTotalQuantity()}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Xử lý logic mua hàng tại đây
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue, // Màu chữ của nút
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: Text('Mua Hàng', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}
