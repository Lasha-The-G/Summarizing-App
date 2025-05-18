import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_selectionarea/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:perspicacity/utils/dialog_box.dart';
import 'package:perspicacity/utils/globals.dart';
import 'package:provider/provider.dart';

class AudioPageDemo extends StatefulWidget {
  const AudioPageDemo({super.key});

  @override
  State<AudioPageDemo> createState() => _AudioPageDemoState();
}

class _AudioPageDemoState extends State<AudioPageDemo> {
  String posturl = 'http://localhost:5000/tran';
  String currentFilePath = '';
  File? audioFile;

  void loadFile() async {
    FilePickerResult? loader = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );
    if (loader != null) {
      audioFile = File(loader.files.single.path!);
      setState(() {
        currentFilePath = audioFile!.path;
      });
    }
  }

  void sendSummaryLen() async {
    var summaryLength =
        Provider.of<globals>(context, listen: false).summaryLength;
    print(summaryLength);
    var request = await http.post(Uri.parse('http://localhost:5000/slen'),
        body: json.encode({'sumLen': summaryLength}));

    var decoded = json.decode(request.body) as Map<String, dynamic>;
    print(decoded['weGood']);
  }

  void transcribe() async {
    var request =
        http.MultipartRequest("POST", Uri.parse("http://localhost:5000/tran"));
    request.files.add(
      await http.MultipartFile.fromPath("audioFile", audioFile!.path),
    );

    var streamedResponse = await request.send();

    var response = await http.Response.fromStream(streamedResponse);
    var decoded = json.decode(response.body) as Map<String, dynamic>;
    Provider.of<globals>(context, listen: false).computedText['transcript'] =
        decoded['transcript'];
    setState(() {});
  }

  void summarize() async {
    final transcript =
        Provider.of<globals>(context, listen: false).computedText['transcript'];

    final response = await http.post(
      Uri.parse("http://localhost:5000/summ"),
      body: json.encode({"transcript": transcript}),
    );
    var decodedSummary = json.decode(response.body) as Map<String, dynamic>;
    Provider.of<globals>(context, listen: false).computedText["summary"] =
        decodedSummary['summary'];
    setState(() {});
  }

  void reformat() async {
    var response = await http.post(
      Uri.parse("http://localhost:5000/refo"),
      body: json.encode({
        'summary': Provider.of<globals>(context, listen: false)
            .computedText['summary'],
      }),
    );
    var decoded_normal =
        await json.decode(response.body) as Map<String, dynamic>;
    Provider.of<globals>(context, listen: false).computedText['formated'] =
        decoded_normal['reformated'];
    setState(() {});
  }

  void request_param() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          sendLen: sendSummaryLen,
        );
      },
    );
  }

  List<bool> isSelected = [true, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(currentFilePath),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: loadFile, child: Text("input File")),
                ElevatedButton(
                    onPressed: request_param, child: Text("length setting")),
                ElevatedButton(
                    onPressed: transcribe, child: Text("transcribe")),
                ElevatedButton(onPressed: summarize, child: Text("summarize")),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: reformat, child: Text("reformat")),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/mainPage'),
                  child: Text("goto Main pages"),
                ),
                ElevatedButton(
                    onPressed: Provider.of<globals>(context, listen: false)
                        .clearStorage,
                    child: Text("clear storage"))
              ],
            ),
            ToggleButtons(
              children: [
                Text("transcript"),
                Text("summary"),
                Text("formated"),
              ],
              isSelected: isSelected,
              onPressed: (index) {
                setState(() {
                  for (int i = 0; i < isSelected.length; i++) {
                    isSelected[i] = i == index;
                  }
                });
              },
            ),
            Expanded(
              child: Container(
                child: SelectionArea(
                  child: Markdown(
                      data: isSelected[0]
                          ? Provider.of<globals>(context, listen: false)
                              .computedText["transcript"]!
                          : isSelected[1]
                              ? Provider.of<globals>(context, listen: false)
                                  .computedText["summary"]!
                              : Provider.of<globals>(context, listen: false)
                                  .computedText["formated"]!),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
