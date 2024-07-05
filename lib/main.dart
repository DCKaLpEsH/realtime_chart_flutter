import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:realtime_line_chart/screens/chart/chart_screen.dart';

import 'firebase_options.dart';

void main() async {

// await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
// );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Opinion Price Chart',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.assistantTextTheme(
          Theme.of(context).textTheme.apply(
                bodyColor: Colors.white38,
              ),
        ),
      ),
      home: ChartScreen(),
    );
  }
}
