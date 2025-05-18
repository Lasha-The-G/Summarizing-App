import 'package:flutter/material.dart';
import 'package:perspicacity/utils/globals.dart';
import 'package:provider/provider.dart';

class JumpAhead extends StatelessWidget {
  const JumpAhead({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, '/mainPage'),
        onLongPress: Provider.of<globals>(context, listen: false).clearStorage,
        child: Container(
          height: 50,
          width: 120,
          decoration: BoxDecoration(
            color: Color(0xff201f1d),
            borderRadius: BorderRadius.circular(500),
            border: Border.all(width: .5, color: Color(0xff3b3b38)),
          ),
          child: Center(
            child: Text(
              "Jump Ahead",
              style: TextStyle(color: Color.fromARGB(255, 197, 194, 183)),
            ),
          ),
        ),
      ),
    );
  }
}
