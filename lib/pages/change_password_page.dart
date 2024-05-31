import 'package:ck/components/app_appbar.dart';
import 'package:ck/components/app_elevated_button.dart';
import 'package:ck/components/app_text_field.dart';
import 'package:ck/models/user_model.dart';
import 'package:ck/pages/login_page.dart';
import 'package:ck/services/local/shared_prefs.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key, this.username});

  final String? username;
  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
  Color _suffixIconColor = Colors.grey;
  bool _isPassword = true;
  Icon _suffixIcon = const Icon(Icons.remove_red_eye);
  Color _borderColor = Colors.grey;
  var _borderWidth = 0.0;
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

  Future<void> _changePasswordHandle() async {
    _borderColor = Colors.grey;
    _borderWidth = 0.0;
    _errorMessage = "";
    setState(() {});
    final newPassword = passwordController.text;
    final newPasswordConfirm = passwordConfirmController.text;

    if (newPassword.isEmpty) {
      _borderColor = Colors.red;
      _borderWidth = 1.0;
      _errorMessage = "password is required";
      setState(() {});
      return;
    }

    if (newPassword.length < 6) {
      _borderColor = Colors.red;
      _borderWidth = 1.0;
      _errorMessage = "password length must be greater than 6";
      setState(() {});
      return;
    }

    if (newPassword != newPasswordConfirm) {
      _borderColor = Colors.red;
      _borderWidth = 1.0;
      _errorMessage = "password not match";
      setState(() {});
      return;
    }

    final checkUsername = userLists.firstWhere(
      (user) => user.username == widget.username,
      orElse: () => UserModel(id: '', username: '', password: ''),
    );
    bool updatedPassword =
        await prefs.updateUserPassword(checkUsername.id, newPassword);
    if (mounted) {
      if (updatedPassword) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LoginPage(
                      username: widget.username,
                    )));
      } else {
        const snackBar = SnackBar(content: Text("Failed to update password"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
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
                    "Change Password",
                    style: TextStyle(color: Colors.blue, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                ),
                Text("${widget.username} you can change your new password here",
                    style: const TextStyle(color: Colors.grey, fontSize: 20.0),
                    textAlign: TextAlign.center),
                const SizedBox(
                  height: 40.0,
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
                  text: "Change password",
                  onPressed: _changePasswordHandle,
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
                              ..onTap = () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage(
                                            username: widget.username,
                                          )))),
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
