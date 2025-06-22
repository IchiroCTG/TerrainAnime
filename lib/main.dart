import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:terrain_anime/pages/myhomepage.dart';
import 'package:terrain_anime/pages/about.dart';
import 'package:terrain_anime/pages/perfil.dart';
import 'package:terrain_anime/pages/Catologo.dart';
import 'package:terrain_anime/pages/preferences.dart';
import 'package:terrain_anime/themes/theme.dart';
import 'package:terrain_anime/themes/util.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static _MyAppState? _state;

  static void updateTheme(bool isDarkMode) {
    _state?.updateTheme(isDarkMode);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;
  String _fontSize = 'Normal';

  @override
  void initState() {
    super.initState();
    MyApp._state = this;
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('darkMode') ?? false;
      _fontSize = prefs.getString('fontSize') ?? 'Normal';
    });
  }

  void updateTheme(bool isDarkMode) {
    setState(() {
      _isDarkMode = isDarkMode;
    });
  }

  TextTheme _buildTextTheme(BuildContext context) {
    TextTheme baseTextTheme = createTextTheme(context, "Roboto", "Titillium Web");
    double scaleFactor;
    switch (_fontSize) {
      case 'Pequeña':
        scaleFactor = 0.8;
        break;
      case 'Grande':
        scaleFactor = 1.2;
        break;
      default:
        scaleFactor = 1.0;
    }
    return baseTextTheme.apply(
      fontSizeFactor: scaleFactor,
    );
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = _buildTextTheme(context);
    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp(
      title: 'Anime Terrain',
      theme: _isDarkMode ? theme.dark() : theme.light(),
      home: const MyHomePage(title: 'Anime Terrain'),
      routes: {
        '/about': (context) => const AboutPage(),
        '/catalogo': (context) => const catalogoPage(),
        '/perfil': (context) => const PerfilPage(),
        '/preferences': (context) => const PreferencesPage(),
      },
    );
  }

  @override
  void dispose() {
    MyApp._state = null;
    super.dispose();
  }
}