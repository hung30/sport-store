import 'dart:ui';

import 'package:ck/components/app_elevated_button.dart';
import 'package:ck/pages/login_page.dart';
import 'package:ck/pages/menu_components_page.dart';
import 'package:ck/services/local/shared_prefs.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SharedPrefs prefs = SharedPrefs();
  String? _username;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    _username = await prefs.getLoginUsername();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${_username ?? ""}!'),
        titleTextStyle: const TextStyle(color: Colors.yellow, fontSize: 30),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
              prefs.setIsLogin(false);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                  Colors.red,
                  Colors.pink,
                  Colors.blue,
                  Colors.black
                ])),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16.0,
                ),
                width: MediaQuery.of(context).size.width * 0.8,
                // height: MediaQuery.of(context).size.height * 0.85,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white12,
                      Colors.white,
                      Colors.white,
                      Colors.white
                    ],
                  ),
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 2),
                      blurRadius: 5,
                      spreadRadius: 5,
                      color: Colors.grey.withOpacity(0.2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 32,
                    ),
                    const Row(
                      children: [
                        SizedBox(
                          width: 32,
                        )
                      ],
                    ),
                    const Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "CỬA HÀNG QUẦN ÁO BÓNG ĐÁ",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: 14,
                              ),
                              Text(
                                "TRENDY FOOTBALL \nCLOTHES OVERTAKE",
                                style: TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 14),
                              Text(
                                "Chào mừng bạn đến với cửa hàng trực tuyến chuyên cung cấp quần áo đá bóng chất lượng cao!\nChúng tôi tự hào mang đến cho bạn những sản phẩm thời trang thể thao đẳng cấp, từ áo đấu của các câu lạc bộ \nnổi tiếng trên thế giới đến các mẫu quần áo tập luyện thiết kế tinh tế. Mỗi sản phẩm đều được chọn lọc kỹ lưỡng với chất liệu bền đẹp, thoáng khí và thoải mái, giúp bạn tự tin trên sân cỏ.",
                                style: TextStyle(
                                  fontSize: 12.0,
                                ),
                              ),
                              SizedBox(height: 14),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Align(
                      alignment: Alignment
                          .centerRight, // Đặt vị trí của Row là bên phải
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .end, // Căn chỉnh hình ảnh trong Row về phía bên phải
                        children: [
                          Flexible(
                              child: Image.asset(
                            "assets/homepage/goat.jpg",
                            height: 200,
                            width: 200,
                          )),
                          Flexible(
                            child: Image.asset(
                              "assets/homepage/mancity.jpg",
                              height: 200,
                              width: 200,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    FractionallySizedBox(
                      widthFactor: 0.8,
                      child: AppElevatedButton(
                        text: "Shopping now?",
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const MenuComponentsPage(
                                        initialPageIndex: 1,
                                      )));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(),
        ],
      ),
    );
  }
}
