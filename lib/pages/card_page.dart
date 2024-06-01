import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
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

  Future<void> _buyHandle() async {
    final prefs = await SharedPreferences.getInstance();
    // Xóa dữ liệu giỏ hàng
    await prefs.remove('cart');
    setState(() {
      _cart = [];
      _updateCartQuantity();
    });
    if (mounted) {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text(
                'Cảm ơn',
                textAlign: TextAlign.center,
              ),
              content: Text(
                'Bạn đã mua hàng thành công!!',
                textAlign: TextAlign.center,
              ),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Cart',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
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
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: CachedNetworkImage(
                          imageUrl: product['image']!,
                          height: 110.0,
                          width: 110.0,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) {
                            print('Failed to load image: $error');
                            return const Icon(Icons.error);
                          },
                        ),
                      ),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.only(left: 3.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 18.0),
                              child: Text(
                                product['name']!,
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            const SizedBox(height: 15.0),
                            Padding(
                                padding: const EdgeInsets.only(left: 18.0),
                                child: Text('Giá: ${product['price']}',
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 14.0,
                                    ))),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () => _addItem(index),
                                  icon: const Icon(Icons.add),
                                  color: Colors.orange,
                                ),
                                Text(
                                  product['quantity'].toString(),
                                  style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w500),
                                ),
                                IconButton(
                                  onPressed: () => _removeItem(index),
                                  icon: const Icon(Icons.remove),
                                  color: Colors.orange,
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: () => _removeItem(index),
                                  icon: const Icon(Icons.delete),
                                  color: Colors.pink,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ))
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Price: ${getTotalPrice().toStringAsFixed(3)} đ',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Total Quantity: ${getTotalQuantity()}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          FractionallySizedBox(
            widthFactor: 0.4,
            child: ElevatedButton(
              onPressed: _buyHandle,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue, // Màu chữ của nút
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: const Text('Mua Hàng', style: TextStyle(fontSize: 16.0)),
            ),
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}
