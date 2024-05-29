import 'package:ck/components/app_appbar.dart';
import 'package:ck/components/app_elevated_button.dart';
import 'package:ck/components/app_text_field.dart';
import 'package:ck/models/user_model.dart';
import 'package:ck/pages/login_page.dart';
import 'package:ck/services/local/shared_prefs.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  Color _suffixIconColor = Colors.grey;
  bool _isPassword = true;
  Icon _suffixIcon = const Icon(Icons.remove_red_eye);
  Color _borderColor = Colors.grey;
  Color _usernameBorderColor = Colors.grey;
  var _borderWidth = 0.0;
  var _usernameBorderWidth = 0.0;
  var _errorMessage = "";
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

  void suffixIconPressed() {
    _isPassword = !_isPassword;
    _suffixIconColor = _isPassword ? Colors.grey : Colors.blue;
    _suffixIcon = _isPassword
        ? const Icon(Icons.remove_red_eye)
        : const Icon(Icons.visibility_off);
    setState(() {});
  }

  Future<void> _registerHandle() async {
    _usernameBorderColor = Colors.grey;
    _usernameBorderWidth = 0.0;
    _borderColor = Colors.grey;
    _borderWidth = 0.0;
    _errorMessage = "";
    final username = usernameController.text;
    final password = passwordController.text;
    final passwordConfirm = passwordConfirmController.text;
    if (username.isEmpty || password.isEmpty || passwordConfirm.isEmpty) {
      final snackBar = SnackBar(content: Text("All fields are required"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    final checkUsername = userLists.firstWhere(
      (user) => user.username == username,
      orElse: () => UserModel(id: '', username: '', password: ''),
    );

    if ((checkUsername.username ?? "").isNotEmpty) {
      _usernameBorderColor = Colors.red;
      _usernameBorderWidth = 1.0;
      _errorMessage = "Username already exists";
      setState(() {});
      return;
    }

    if (password == passwordConfirm) {
      final user = UserModel(
          id: '${DateTime.now().microsecondsSinceEpoch}',
          username: username,
          password: password);
      userLists.add(user);
      prefs.saveUserList(userLists);
      setState(() {});

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(
            username: username,
          ),
        ),
      );
    } else {
      _borderColor = Colors.red;
      _borderWidth = 1.0;
      _errorMessage = "Password does not match";
      setState(() {});
    }
  }

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
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
                    "Register",
                    style: TextStyle(color: Colors.blue, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Text("Create your new account",
                    style: TextStyle(color: Colors.grey, fontSize: 20.0),
                    textAlign: TextAlign.center),
                const SizedBox(
                  height: 40.0,
                ),
                AppTextField(
                  controller: usernameController,
                  hinText: "Username",
                  borderWidth: _usernameBorderWidth,
                  borderColor: _usernameBorderColor,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                AppTextField(
                  controller: passwordController,
                  hinText: "Password",
                  isPassword: _isPassword,
                  suffixIcon: _suffixIcon,
                  borderWidth: _borderWidth,
                  borderColor: _borderColor,
                  suffixIconColor: _suffixIconColor,
                  suffixIconPressed: suffixIconPressed,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                AppTextField(
                  controller: passwordConfirmController,
                  hinText: "Confirm Password",
                  isPassword: _isPassword,
                  suffixIcon: _suffixIcon,
                  borderWidth: _borderWidth,
                  borderColor: _borderColor,
                  suffixIconColor: _suffixIconColor,
                  suffixIconPressed: suffixIconPressed,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                _errorMessage.isEmpty
                    ? const SizedBox()
                    : Text(
                        _errorMessage,
                        style:
                            const TextStyle(color: Colors.red, fontSize: 16.0),
                        textAlign: TextAlign.center,
                      ),
                const SizedBox(
                  height: 50.0,
                ),
                AppElevatedButton(
                  text: "Sign up",
                  onPressed: () => _registerHandle(),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                RichText(
                  text: TextSpan(
                      text: "Already an account?, ",
                      style:
                          const TextStyle(color: Colors.grey, fontSize: 16.0),
                      children: <TextSpan>[
                        TextSpan(
                            text: "Login",
                            style: const TextStyle(
                                color: Colors.blue, fontSize: 16.0),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginPage()))),
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
