import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown_selectionarea/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:perspicacity/utils/globals.dart';

class TextPage extends StatefulWidget {
  @override
  _TextPageState createState() => _TextPageState();
}

class _TextPageState extends State<TextPage> {
  bool isEdited = true;

  // ScrollController _controller = ScrollController();
  final _controller = ScrollController();

  void appendSelectedText() async {
    final clipboardData = await Clipboard.getData('text/plain');
    if (clipboardData != null && clipboardData.text != null) {
      Provider.of<globals>(context, listen: false).addItem(clipboardData.text!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceAround, // Changed from center
              children: [
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/audioPage'),
                  child: Row(
                    children: [
                      Icon(
                        Icons.restart_alt_rounded,
                        size: 30,
                        color: Color(0xffd0cfcb),
                      ),
                      Text(
                        'Return',
                        style:
                            TextStyle(color: Color(0xffa19f96), fontSize: 14),
                      )
                    ],
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "Raw",
                      style: TextStyle(color: Color(0xffa19f96), fontSize: 14),
                    ),
                    Switch(
                      activeColor: Color.fromARGB(255, 137, 204, 188),
                      value: isEdited,
                      onChanged: (value) {
                        setState(() {
                          isEdited = value;
                        });
                      },
                    ),
                    Text(
                      "Edited",
                      style: TextStyle(color: Color(0xffa19f96), fontSize: 14),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.add_circle, color: Colors.white),
                      onPressed: appendSelectedText,
                    ),
                    Text(
                      "Add Note",
                      style: TextStyle(color: Color(0xffa19f96), fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: Container(
                child: SelectionArea(
                  child: RawScrollbar(
                    controller: _controller,
                    child: Markdown(
                      controller: _controller,
                      styleSheet: MarkdownStyleSheet(
                        h1: TextStyle(color: Colors.white),
                        h2: TextStyle(color: Colors.white),
                        h3: TextStyle(color: Colors.white),
                        h4: TextStyle(color: Colors.white),
                        h5: TextStyle(color: Colors.white),
                        h6: TextStyle(color: Colors.white),
                        p: TextStyle(color: Colors.white),
                        blockquote: TextStyle(color: Colors.white),
                        listBullet: TextStyle(color: Colors.white),
                        code: TextStyle(color: Colors.black),
                      ),
                      data: isEdited
                          ? Provider.of<globals>(context, listen: false)
                              .computedText['formated']
                              .toString()
                          : Provider.of<globals>(context, listen: false)
                              .computedText['transcript']
                              .toString(),
                    ),
                  ),
                ),
              ),
            )
            // Expanded(
            //   child: RawScrollbar(
            //     controller: _controller,
            //     fadeDuration: Duration(milliseconds: 500),
            //     child: SingleChildScrollView(
            //       controller: _controller,
            //       child: Padding(
            //         padding:
            //             const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
            //         child: Theme(
            //           data: Theme.of(context).copyWith(
            //             textSelectionTheme: TextSelectionThemeData(
            //                 selectionColor: Color.fromARGB(255, 137, 204, 188)
            //                     .withOpacity(0.5) // Background highlight color
            //                 ),
            //           ),
            //           child: SelectableText(
            //             raw_sum[isEdited ? 1 : 0],
            //             style: TextStyle(
            //               color: Color(0xffd0cfcb),
            //               fontSize: 15,
            //             ),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ],
    );
  }
}
