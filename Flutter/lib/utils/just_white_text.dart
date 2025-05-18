import 'package:flutter/material.dart';

class WhiteText extends StatelessWidget {
  final String text;
  const WhiteText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: Color(0xffa6a39a)),
    );
  }
}
