import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ck/pages/product_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Page',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Product Page'),
        ),
        body: ProductList(),
      ),
    );
  }
}

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  late SharedPreferences _prefs;
  List<Map<String, dynamic>> _products = [];
  bool _userCanEdit = false;
  late List<Map<String, dynamic>> _displayedProducts = [];

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _loadProducts();
    _checkUserPermission();
  }

  Future<void> _loadProducts() async {
    final String productsJson = _prefs.getString('products') ?? '[]';
    setState(() {
      _products = json.decode(productsJson).cast<Map<String, dynamic>>();
    });
  }

  Future<void> _checkUserPermission() async {
    final String? username = _prefs.getString('username');
    if (username != null && username == 'hung30') {
      setState(() {
        _userCanEdit = true;
      });
    }
  }

  Future<void> _addProduct() async {
    if (_userCanEdit) {
      final String imageUrl = _imageController.text;
      if (_isValidImageUrl(imageUrl)) {
        final Map<String, dynamic> newProduct = {
          'name': _nameController.text,
          'image': imageUrl,
          'price': _priceController.text,
        };
        final List<Map<String, dynamic>> updatedProducts = List.from(_products)
          ..add(newProduct);
        await _prefs.setString('products', json.encode(updatedProducts));
        _loadProducts();
        _clearForm();
      } else {
        // Hiển thị thông báo lỗi URL ảnh không hợp lệ
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Invalid image URL. Please enter a valid image URL ending with .jpg, .png, etc.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      // Show a message or prevent adding the product
      print('You do not have permission to add products.');
    }
  }

  bool _isValidImageUrl(String url) {
    final Uri uri = Uri.tryParse(url) ?? Uri();
    final RegExp imageRegex = RegExp(
        r'(\.jpg|\.jpeg|\.png|\.gif|\.bmp|\.webp)$',
        caseSensitive: false);
    return uri.isAbsolute && imageRegex.hasMatch(uri.path);
  }

  Future<void> _deleteProduct(int index) async {
    if (_userCanEdit) {
      setState(() {
        _products.removeAt(index);
      });
      await _prefs.setString('products', json.encode(_products));
    } else {
      // Show a message or prevent deleting the product
      print('You do not have permission to delete products.');
    }
  }

  Future<void> _updateProduct(
      int index, Map<String, dynamic> updatedProduct) async {
    if (_userCanEdit) {
      setState(() {
        _products[index] = updatedProduct;
      });
      await _prefs.setString('products', json.encode(_products));
    } else {
      // Show a message or prevent updating the product
      print('You do not have permission to update products.');
    }
  }

  void _searchProduct(String keyword) {
    setState(() {
      if (keyword.isNotEmpty) {
        _displayedProducts = _products.where((product) {
          return product['name'].toLowerCase().contains(keyword.toLowerCase());
        }).toList();
      } else {
        _displayedProducts = List.from(_products);
      }
    });
  }

  void _clearForm() {
    _nameController.clear();
    _imageController.clear();
    _priceController.clear();
  }

  Future<void> _addToCart(Map<String, dynamic> product) async {
    final String cartJson = _prefs.getString('cart') ?? '[]';
    List<Map<String, dynamic>> cart =
        json.decode(cartJson).cast<Map<String, dynamic>>();

    // Kiểm tra xem sản phẩm đã tồn tại trong giỏ hàng chưa
    int existingIndex =
        cart.indexWhere((item) => item['name'] == product['name']);
    if (existingIndex != -1) {
      // Nếu đã tồn tại, tăng số lượng lên 1
      cart[existingIndex]['quantity'] += 1;
    } else {
      // Nếu chưa tồn tại, thêm sản phẩm vào giỏ hàng với số lượng là 1
      cart.add({...product, 'quantity': 1});
    }

    await _prefs.setString('cart', json.encode(cart));
    // Hiển thị thông báo
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Product added to cart'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    List<Widget> rows = [];
    for (int i = 0; i < _products.length; i += 2) {
      Widget row;
      if (i + 1 < _products.length) {
        row = Row(
          children: [
            Expanded(
              child: ProductCard(
                product: _products[i],
                onDelete: () => _deleteProduct(i),
                onUpdate: (updatedProduct) => _updateProduct(i, updatedProduct),
                userCanEdit: _userCanEdit,
              ),
            ),
            SizedBox(width: 8), // Add spacing between products
            Expanded(
              child: ProductCard(
                product: _products[i + 1],
                onDelete: () => _deleteProduct(i + 1),
                onUpdate: (updatedProduct) =>
                    _updateProduct(i + 1, updatedProduct),
                userCanEdit: _userCanEdit,
              ),
            ),
          ],
        );
      } else {
        row = Row(
          children: [
            Expanded(
              child: ProductCard(
                product: _products[i],
                onDelete: () => _deleteProduct(i),
                onUpdate: (updatedProduct) => _updateProduct(i, updatedProduct),
                userCanEdit: _userCanEdit,
              ),
            ),
            SizedBox(width: screenWidth / 2), // Add empty space for alignment
          ],
        );
      }
      rows.add(row);
    }

    return Column(
      children: [
        if (_userCanEdit) ...[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(labelText: 'Name'),
                      ),
                      TextFormField(
                        controller: _imageController,
                        decoration: InputDecoration(labelText: 'Image'),
                      ),
                      TextFormField(
                        controller: _priceController,
                        decoration: InputDecoration(labelText: 'Price'),
                      ),
                      ElevatedButton(
                        onPressed: _addProduct,
                        style: ElevatedButton.styleFrom(
                          elevation: 0, // Remove shadow
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(0), // No border radius
                          ),
                        ),
                        child: Text('Add Product'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
        Expanded(
          child: ListView(
            children: rows,
          ),
        ),
      ],
    );
  }
}

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onDelete;
  final Function(Map<String, dynamic>) onUpdate;
  final bool userCanEdit;

  const ProductCard({
    Key? key,
    required this.product,
    required this.onDelete,
    required this.onUpdate,
    required this.userCanEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0, // Remove default elevation
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Add border radius
        side: BorderSide(color: Colors.black), // Add black border
      ),
      margin: EdgeInsets.all(10), // Add padding around the card
      child: Padding(
        padding: const EdgeInsets.all(10), // Add padding inside the card
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: product['image']!,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) {
                print('Failed to load image: $error');
                return Icon(Icons.error);
              },
            ),
            Text(
              product['name']!,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              product['price']!,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (userCanEdit)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: onDelete,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: const Text('Delete'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _showUpdateDialog(context),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: const Text('Update'),
                  ),
                ],
              ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailPage(product: product),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
              child: const Text('DETAIL'),
            ),
          ],
        ),
      ),
    );
  }

  void _showUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController nameController =
            TextEditingController(text: product['name']);
        final TextEditingController imageController =
            TextEditingController(text: product['image']);
        final TextEditingController priceController =
            TextEditingController(text: product['price']);

        return AlertDialog(
          title: Text('Update Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: imageController,
                decoration: InputDecoration(labelText: 'Image'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                onUpdate({
                  'name': nameController.text,
                  'image': imageController.text,
                  'price': priceController.text,
                });
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
