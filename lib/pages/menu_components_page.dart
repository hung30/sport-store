import 'package:ck/pages/card_page.dart';
import 'package:ck/pages/home_page.dart';
import 'package:ck/pages/login_page.dart';
import 'package:ck/pages/product_page.dart';
import 'package:ck/pages/user_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MenuComponentsPage());

class MenuComponentsPage extends StatelessWidget {
  const MenuComponentsPage({super.key, this.initialPageIndex = 0});

  final int initialPageIndex;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: NavigationExample(
        initialPageIndex: initialPageIndex,
      ),
    );
  }
}

Future<void> _logout(BuildContext context) async {
  try {
    // Xử lý logout ở đây, ví dụ chuyển hướng về trang login
    final prefs = await SharedPreferences.getInstance();
    // Xóa dữ liệu giỏ hàng
    await prefs.remove('cart');
    await prefs.setBool('isLogin', false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
    // Navigator.pushReplacementNamed(context, '/onboarding');
  } catch (e) {
    // Xử lý lỗi ở đây
    print('Error logging out: $e');
  }
}

ValueNotifier<int> cartQuantityNotifier = ValueNotifier<int>(0);

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key, this.initialPageIndex = 0});
  final int initialPageIndex;

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  late int currentPageIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentPageIndex = widget.initialPageIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          if (index == 4) {
            _logout(context);
          } else {
            setState(() {
              currentPageIndex = index;
            });
          }
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          const NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.category_outlined),
            label: 'Product',
          ),
          ValueListenableBuilder<int>(
            valueListenable: cartQuantityNotifier,
            builder: (context, value, child) {
              return NavigationDestination(
                selectedIcon: Stack(
                  children: [
                    const Icon(Icons.add_shopping_cart),
                    if (value > 0)
                      Positioned(
                        right: 0,
                        child: CircleAvatar(
                          radius: 8,
                          backgroundColor: Colors.red,
                          child: Text(
                            '$value',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                icon: Stack(
                  children: [
                    const Icon(Icons.add_shopping_cart_outlined),
                    if (value > 0)
                      Positioned(
                        right: 0,
                        child: CircleAvatar(
                          radius: 8,
                          backgroundColor: Colors.red,
                          child: Text(
                            '$value',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                label: 'Cart',
              );
            },
          ),
          const NavigationDestination(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Profile',
          ),
          const NavigationDestination(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
      ),
      body: <Widget>[
        const HomePage(),
        const ProductPage(),
        const CartPage(),
        const UserPage()
      ][currentPageIndex],
    );
  }
}
