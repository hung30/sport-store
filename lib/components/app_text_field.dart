import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.isPassword = false,
    this.prefixIcon,
    this.hinText,
    this.textInputAction,
    this.suffixIcon,
    this.suffixIconColor = Colors.grey,
    this.suffixIconPressed,
  });

  final TextEditingController? controller;
  final bool isPassword;
  final Icon? prefixIcon;
  final String? hinText;
  final TextInputAction? textInputAction;
  final Widget? suffixIcon;
  final Color? suffixIconColor;
  final Function()? suffixIconPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.0,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(7.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 10.0),
              child: TextField(
                controller: controller,
                obscureText: isPassword,
                decoration: InputDecoration(
                  hintText: hinText,
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  prefixIcon: prefixIcon,
                ),
                textInputAction: textInputAction,
              ),
            ),
          ),
          if (suffixIcon != null)
            IconButton(
              onPressed: suffixIconPressed,
              color: suffixIconColor,
              icon: suffixIcon!,
              padding: EdgeInsets.zero,
            ),
        ],
      ),
    );
  }
}
