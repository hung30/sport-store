import 'dart:async';
import 'package:ck/pages/home_page.dart';
import 'package:ck/pages/login_page.dart';
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
                    builder: (context) => HomePage(username: username)),
              );
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
                          title: 'Fast, Fluid and Secure',
                          description:
                              'Enjoy the best of the world in the palm of your hands.',
                          image: 'assets/onboardingImages/image0.png',
                          bgColor: Colors.indigo,
                        ),
                        OnboardingPageModel(
                          title: 'Connect with your friends.',
                          description:
                              'Connect with your friends anytime anywhere.',
                          image: 'assets/onboardingImages/image1.png',
                          bgColor: const Color(0xff1eb090),
                        ),
                        OnboardingPageModel(
                          title: 'Bookmark your favourites',
                          description:
                              'Bookmark your favourite quotes to read at a leisure time.',
                          image: 'assets/onboardingImages/image2.png',
                          bgColor: const Color(0xfffeae4f),
                        ),
                        OnboardingPageModel(
                          title: 'Follow creators',
                          description:
                              'Follow your favourite creators to stay in the loop.',
                          image: 'assets/onboardingImages/image3.png',
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
      backgroundColor: Colors.blue,
      body: Center(
        child: Text(
          "Hello world",
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
      ),
    );
  }
}
