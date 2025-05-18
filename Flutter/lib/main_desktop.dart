import 'package:flutter/material.dart';
import 'package:perspicacity/note_page.dart';
import 'package:perspicacity/text_page.dart';

class MainDesktop extends StatelessWidget {
  const MainDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff3d3d3a),
      body: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                right: 7.0,
                left: 14.0,
                top: 14.0,
                bottom: 14.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xff272725),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                      width: 0.5, color: Color.fromARGB(255, 116, 116, 110)),
                ),
                child: TextPage(),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                right: 14.0,
                left: 7.0,
                top: 14.0,
                bottom: 14.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xff272725),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                      width: 0.5, color: Color.fromARGB(255, 116, 116, 110)),
                ),
                child: ListWihParts(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
