import 'package:ck/pages/contact_page.dart';
import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key, this.onPressed});

  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: GestureDetector(
          onTap: onPressed,
          child: const Icon(
            Icons.input,
          ),
        ),
        title: const Text(
          "Shop quần áo",
        ),
        actions: [
          GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ContactPage())),
            child: const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Text("Liên hệ"),
            ),
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
