import 'package:flutter/material.dart';
import 'pages/myhomepage.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Terrain Anime Schema',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 255, 60, 0)),
      ),
      home: const MyHomePage(title: 'Terrain Anime'),
    );
  }
}


