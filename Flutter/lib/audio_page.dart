import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:perspicacity/utils/audio_page_buttons.dart';

import 'package:http/http.dart' as http;
import 'package:perspicacity/utils/dialog_box.dart';
import 'package:perspicacity/utils/globals.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:perspicacity/utils/jump_ahead.dart';
import 'package:perspicacity/utils/just_white_text.dart';
import 'package:perspicacity/utils/progress.dart';

import 'package:provider/provider.dart';

class AudioPage extends StatefulWidget {
  const AudioPage({super.key});

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  List<bool> completionTable = [false, false, false];
  String currentFilePath = '';
  File? audioFile;

  void loadFile() async {
    FilePickerResult? loader = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );
    if (loader != null) {
      audioFile = File(loader.files.single.path!);
      setState(() {
        currentFilePath = path.basename(audioFile!.path);
      });
    }
  }

  Future<void> sendSummaryLen() async {
    var summaryLength =
        Provider.of<globals>(context, listen: false).summaryLength;
    var request = await http.post(Uri.parse('http://localhost:5000/slen'),
        body: json.encode({'sumLen': summaryLength}));

    var decoded = json.decode(request.body) as Map<String, String>;
    print(decoded['areWeGood']);
  }

  Future<void> transcribe() async {
    if (audioFile == null) return;

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
    completionTable[0] = true;
    setState(() {});
  }

  Future<void> summarize() async {
    final transcript =
        Provider.of<globals>(context, listen: false).computedText['transcript'];

    if (transcript == null || transcript.isEmpty) return;

    final response = await http.post(
      Uri.parse("http://localhost:5000/summ"),
      body: json.encode({"transcript": transcript}),
    );
    var decodedSummary = json.decode(response.body) as Map<String, dynamic>;
    Provider.of<globals>(context, listen: false).computedText["summary"] =
        decodedSummary['summary'];
    completionTable[1] = true;
    setState(() {});
  }

  Future<void> reformat() async {
    final summary =
        Provider.of<globals>(context, listen: false).computedText['summary'];
    if (summary == null || summary.isEmpty) return;

    var response = await http.post(
      Uri.parse("http://localhost:5000/refo"),
      body: json.encode({
        'summary': summary,
        'refLen': Provider.of<globals>(context, listen: false).summaryLength,
      }),
    );
    var decoded_normal =
        await json.decode(response.body) as Map<String, dynamic>;
    Provider.of<globals>(context, listen: false).computedText['formated'] =
        decoded_normal['reformated'];
    completionTable[2] = true;
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

  void processing() async {
    request_param();
    // await Future.delayed(
    //     Duration(milliseconds: 500)); // Give dialog time to close
    await transcribe();
    await summarize();
    await reformat();
    Navigator.pushNamed(context, '/mainPage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff272725),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AudioButton(
                function: loadFile, icon: Icons.audio_file, text: "Input"),
            AudioButton(
                function: processing, icon: Icons.play_arrow, text: "process"),
            Completion(truthTable: completionTable),
            Provider.of<globals>(context, listen: false).computedText.isEmpty
                ? Container()
                : JumpAhead(),
            WhiteText(text: currentFilePath),
          ],
        ),
      ),
    );
  }
}
