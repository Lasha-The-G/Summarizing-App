import 'package:flutter/material.dart';

class Completion extends StatelessWidget {
  final List<bool> truthTable;
  const Completion({super.key, required this.truthTable});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: truthTable[0]
                    ? Color.fromARGB(255, 82, 122, 112)
                    : Color(0xffa6a39a)),
          ),
          SizedBox(width: 3),
          Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: truthTable[1]
                    ? Color.fromARGB(255, 82, 122, 112)
                    : Color(0xffa6a39a)),
          ),
          SizedBox(width: 3),
          Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: truthTable[2]
                    ? Color.fromARGB(255, 82, 122, 112)
                    : Color(0xffa6a39a)),
          ),
        ],
      ),
    );
  }
}
