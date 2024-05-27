import 'package:ck/components/app_appbar.dart';
import 'package:ck/components/app_elevated_button.dart';
import 'package:ck/components/app_text_field.dart';
import 'package:ck/models/user_model.dart';
import 'package:ck/pages/forgot_password_page.dart';
import 'package:ck/pages/home_page.dart';
import 'package:ck/pages/register_page.dart';
import 'package:ck/services/local/shared_prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

int d = 0;
Color _suffixIconColor = Colors.grey;
bool _isPassword = true;

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  SharedPrefs prefs = SharedPrefs();
  List<UserModel> userLists = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserList();
  }

  void _getUserList() {
    prefs.getUserList().then((value) {
      userLists = value ?? [...userList];
      setState(() {});
    });
  }

  Future<void> _login() async {
    final username = usernameController.text;
    final password = passwordController.text;
    final user = userLists.firstWhere(
      (user) => user.username == username && user.password == password,
      orElse: () => UserModel(id: '', username: '', password: ''),
    );
    if ((user.username ?? "").isNotEmpty) {
      await prefs.setIsLogin(true);
      await prefs.setLoginUsername(username);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(username: user.username ?? ''),
        ),
      );
    } else {
      _showErrorMessage("Tài khoản hoặc mật khẩu không đúng");
    }
  }

  void _showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Thông báo',
            style: TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: MyAppBar(onPressed: () => Navigator.pop(context)),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 70.0),
                  child: Text(
                    "Welcome Back",
                    style: TextStyle(color: Colors.red, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Text("Login to your account",
                    style: TextStyle(color: Colors.grey, fontSize: 20.0),
                    textAlign: TextAlign.center),
                const SizedBox(
                  height: 40.0,
                ),
                AppTextField(
                  controller: usernameController,
                  hinText: "Username",
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                AppTextField(
                  controller: passwordController,
                  hinText: "Password",
                  isPassword: _isPassword,
                  suffixIcon: const Icon(Icons.remove_red_eye),
                  suffixIconColor: _suffixIconColor,
                  suffixIconPressed: () {
                    setState(() {
                      d++;
                      if (d % 2 != 0) {
                        _isPassword = !_isPassword;

                        _suffixIconColor = Colors.green;
                      } else {
                        _isPassword = !_isPassword;
                        _suffixIconColor = Colors.grey;
                      }
                    });
                  },
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgotPasswordPage())),
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(color: Colors.red, fontSize: 16.0),
                    textAlign: TextAlign.end,
                  ),
                ),
                const SizedBox(
                  height: 60.0,
                ),
                AppElevatedButton(
                  text: "Login",
                  onPressed: () => _login(),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                RichText(
                  text: TextSpan(
                      text: "Don't have an account?, ",
                      style:
                          const TextStyle(color: Colors.grey, fontSize: 16.0),
                      children: <TextSpan>[
                        TextSpan(
                            text: "Sign up",
                            style: const TextStyle(
                                color: Colors.red, fontSize: 16.0),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterPage()))),
                      ]),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
