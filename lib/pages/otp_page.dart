import 'dart:async';

import 'package:ck/components/app_appbar.dart';
import 'package:ck/components/app_elevated_button.dart';
import 'package:ck/pages/change_password_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key, this.username});

  final String? username;

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String otpCode = '';
  late String verifyCode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    verifyCode = DateTime.now()
        .microsecondsSinceEpoch
        .toString()
        .substring(DateTime.now().microsecondsSinceEpoch.toString().length - 5);
    Timer(const Duration(milliseconds: 2000), () {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Verification Code",
              textAlign: TextAlign.center,
            ),
            content: Text(
              'Your code is: $verifyCode',
              textAlign: TextAlign.center,
            ),
          );
        },
      );
    });
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
                Padding(
                  padding: EdgeInsets.only(top: 70.0),
                  child: Text(
                    "Verification Code for ${widget.username}",
                    style: const TextStyle(color: Colors.blue, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Text("We texted you a code. Please enter it below",
                    style: TextStyle(color: Colors.grey, fontSize: 20.0),
                    textAlign: TextAlign.center),
                const SizedBox(
                  height: 40.0,
                ),
                OtpTextField(
                  numberOfFields: 5,
                  borderColor: const Color(0xFF512DA8),
                  //set to true to show as box or false to show as dash
                  showFieldAsBox: true,
                  //runs when every textfield is filled
                  onSubmit: (String verificationCode) {
                    setState(() {
                      otpCode = verificationCode;
                    });
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                RichText(
                  text: TextSpan(
                      text: "Didn't receive the code?, ",
                      style:
                          const TextStyle(color: Colors.grey, fontSize: 16.0),
                      children: <TextSpan>[
                        TextSpan(
                            text: "Show again?",
                            style: const TextStyle(
                                color: Colors.blue, fontSize: 16.0),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text(
                                        "Verification Code",
                                        textAlign: TextAlign.center,
                                      ),
                                      content: Text(
                                        'Your code is: $verifyCode',
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                  },
                                );
                              }),
                      ]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 50.0,
                ),
                AppElevatedButton(
                  onPressed: () {
                    if (otpCode == verifyCode) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangePasswordPage(
                                    username: widget.username,
                                    isForgotPassword: true,
                                  )));
                    } else {
                      const snackBar = SnackBar(
                        content: Text("Wrong code. Please try again"),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      return;
                    }
                  },
                  text: "Verify",
                ),
              ],
            )),
      ),
    );
  }
}
