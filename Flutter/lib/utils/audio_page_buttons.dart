import 'package:flutter/material.dart';

class AudioButton extends StatelessWidget {
  final VoidCallback function;
  final IconData icon;
  final String text;

  const AudioButton({
    super.key,
    required this.function,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          color: Color(0xff201f1d),
          borderRadius: BorderRadius.circular(500),
          border: Border.all(width: .5, color: Color(0xff3b3b38)),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Color(0xffe5e5e2),
                size: 40,
              ),
              SizedBox(height: 8),
              Text(
                text,
                style: TextStyle(color: Color(0xffa6a39a), fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
