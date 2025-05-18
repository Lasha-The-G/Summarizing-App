import 'package:flutter/material.dart';
import 'package:perspicacity/utils/globals.dart';
import 'package:provider/provider.dart';

class DialogBox extends StatefulWidget {
  final VoidCallback sendLen;
  const DialogBox({super.key, required this.sendLen});

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  late double _summaryLength;

  @override
  void initState() {
    super.initState();
    // Initialize with global value
    _summaryLength = Provider.of<globals>(context, listen: false).summaryLength;
  }

  void submitLength() {
    widget.sendLen();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xff272725),
      title: Text(
        "Choose summarization length",
        style: TextStyle(color: Color(0xffe5e5e2)),
      ),
      actions: [
        Slider(
          activeColor: Color.fromARGB(255, 82, 122, 112),
          inactiveColor: Color.fromARGB(255, 27, 27, 26),
          value: _summaryLength,
          min: 0.0,
          max: 100.0,
          divisions: 10,
          onChanged: (value) {
            setState(() {
              _summaryLength = value;
              // Update global state immediately
              Provider.of<globals>(context, listen: false)
                  .updateSummaryLength(value);
            });
          },
        ),
        GestureDetector(
          onTap: submitLength,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromARGB(255, 27, 27, 26),
            ),
            height: 30,
            width: 100,
            child: Center(
              child: Text("Submit", style: TextStyle(color: Colors.white)),
            ),
          ),
        )
      ],
    );
  }
}
