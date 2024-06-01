import 'package:ck/components/app_appbar.dart';
import 'package:ck/components/app_elevated_button.dart';
import 'package:ck/components/app_text_field.dart';
import 'package:ck/models/user_model.dart';
import 'package:ck/pages/otp_page.dart';
import 'package:ck/services/local/shared_prefs.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController usernameController = TextEditingController();
  Color _usernameBorderColor = Colors.grey;
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

  Future<void> _forgotPasswordHandle() async {
    _usernameBorderColor = Colors.grey;
    _usernameBorderWidth = 0.0;
    _errorMessage = "";
    setState(() {});
    final username = usernameController.text.trim();
    if (username.isEmpty) {
      _usernameBorderWidth = 1.0;
      _usernameBorderColor = Colors.red;
      _errorMessage = "username is required";
      setState(() {});
      return;
    }

    final checkUsername = userLists.firstWhere(
      (user) => user.username == username,
      orElse: () => UserModel(id: '', username: '', password: ''),
    );
    if ((checkUsername.username ?? "").isNotEmpty) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OtpPage(
                    username: checkUsername.username,
                  )));
    } else {
      _usernameBorderWidth = 1.0;
      _usernameBorderColor = Colors.red;
      _errorMessage = "Username not found";
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        onPressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 70.0),
                  child: Text(
                    "Forgot Your Password",
                    style: TextStyle(color: Colors.blue, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Text("Change your password here",
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
                  height: 40.0,
                ),
                AppElevatedButton(
                  text: "Send OTP",
                  onPressed: () => _forgotPasswordHandle(),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                RichText(
                  text: TextSpan(
                      text: "Remember your password account?, ",
                      style:
                          const TextStyle(color: Colors.grey, fontSize: 16.0),
                      children: <TextSpan>[
                        TextSpan(
                          text: "Login",
                          style: const TextStyle(
                              color: Colors.blue, fontSize: 16.0),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.pop(context),
                        )
                      ]),
                  textAlign: TextAlign.center,
                )
              ],
            )),
      ),
    );
  }
}
