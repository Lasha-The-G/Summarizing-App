// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class SlidableContainer extends StatelessWidget {
  final String child;

  SlidableContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0.5, top: 0.5),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            color: Color(0xff201f1d),
            border: Border.all(width: 0.5, color: Color(0xff3b3b38))),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              child,
              style: TextStyle(
                fontSize: 20,
                color: Color(0xffe5e5e2),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
