// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:perspicacity/audio_page(demonstrative).dart';
import 'package:perspicacity/audio_page.dart';
import 'package:provider/provider.dart';
import 'package:perspicacity/utils/globals.dart';
import 'package:perspicacity/main_desktop.dart';
import 'package:perspicacity/main_mobile.dart';
import 'package:perspicacity/responsive_layout.dart';

void main() async {
  // Initialize Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Open the box
  await Hive.openBox('storage');

  runApp(
    ChangeNotifierProvider(
      create: (context) => globals(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: '/audioPage',
      routes: {
        '/audioPage': (context) => const AudioPageDemo(),
        // '/audioPage': (context) => const AudioPage(),
        '/mainPage': (context) => const ResponsiveLayout(
              mobileBody: MainMobile(),
              desktopBody: MainDesktop(),
            ),
      },
      // home: ResponsiveLayout(
      //   mobileBody: MainMobile(),
      //   desktopBody: MainDesktop(),
      // ),

      // home: AudioPage(),
    );
  }
}
