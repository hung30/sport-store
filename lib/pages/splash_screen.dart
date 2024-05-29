import 'dart:async';
import 'package:ck/pages/login_page.dart';
import 'package:ck/pages/menu_components_page.dart';
import 'package:ck/pages/onboarding_screen.dart';
import 'package:ck/services/local/shared_prefs.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  SharedPrefs prefs = SharedPrefs();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(milliseconds: 2000), () {
      prefs.getIsLogin().then((isLoggedIn) {
        if (isLoggedIn) {
          prefs.getLoginUsername().then((username) {
            if (username != null) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MenuComponentsPage(),
                  ));
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            }
          });
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => OnboardingScreen(
                      pages: [
                        OnboardingPageModel(
                          title: 'PELE',
                          description: '“Mọi thứ đều là thực hành.”',
                          image: 'assets/onboardingImages/pele.png',
                          bgColor: Colors.indigo,
                        ),
                        OnboardingPageModel(
                          title: 'CRISTIANO RONALDO',
                          description: '“Có lẽ họ ghét tôi vì tôi quá giỏi.”',
                          image: 'assets/onboardingImages/ronaldo.png',
                          bgColor: const Color(0xff1eb090),
                        ),
                        OnboardingPageModel(
                          title: 'LIONEL MESSI',
                          description:
                              '“Có nhiều điều quan trọng trong cuộc sống hơn việc thắng hay thua trong một trò chơi.”',
                          image: 'assets/onboardingImages/messi.png',
                          bgColor: const Color(0xfffeae4f),
                        ),
                        OnboardingPageModel(
                          title: 'RONALDINHO',
                          description:
                              '“Nó không chỉ là về tiền bạc, nó là về những gì bạn đạt được trên sân cỏ.”',
                          image: 'assets/onboardingImages/ronaldinho.png',
                          bgColor: Colors.purple,
                        ),
                      ],
                    )),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF38B6FF),
      body: Center(
        child: Image(
          image: AssetImage('assets/splash/logo.png'),
          width: 400,
          height: 400,
        ),
      ),
    );
  }
}
