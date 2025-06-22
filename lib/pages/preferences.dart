import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:terrain_anime/main.dart';
import 'package:terrain_anime/pages/myhomepage.dart';
import 'package:terrain_anime/pages/Catologo.dart';
import 'package:terrain_anime/pages/perfil.dart';
import 'package:terrain_anime/pages/about.dart';

class PreferencesPage extends StatefulWidget {
  const PreferencesPage({super.key});

  @override
  State<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  bool _isDarkMode = false;
  String _fontSize = 'Normal';
  String _backgroundColor = 'Blanco';
  bool _compactGridView = false;
  bool _showFullNames = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('darkMode') ?? false;
      _fontSize = prefs.getString('fontSize') ?? 'Normal';
      _backgroundColor = prefs.getString('backgroundColor') ?? 'Blanco';
      _compactGridView = prefs.getBool('compactGridView') ?? false;
      _showFullNames = prefs.getBool('showFullNames') ?? true;
    });
  }

  Future<void> _savePreference(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }

  double _getFontSize(double baseSize) {
    switch (_fontSize) {
      case 'Pequeña':
        return baseSize * 0.8;
      case 'Grande':
        return baseSize * 1.2;
      default:
        return baseSize;
    }
  }

  Color _getBackgroundColor() {
    switch (_backgroundColor) {
      case 'Gris Claro':
        return Colors.grey[200]!;
      case 'Azul Claro':
        return Colors.blue[50]!;
      default:
        return Colors.white;
    }
  }

  void inicioPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MyHomePage(title: "Anime Terrain"),
      ),
    );
  }

  void catalogopage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const catalogoPage()),
    );
  }

  void perfilpage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PerfilPage()),
    );
  }

  void aboutPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AboutPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Preferencias",
          style: TextStyle(fontSize: _getFontSize(20)),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Text(
                "Navegación",
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontSize: _getFontSize(24),
                    ),
              ),
            ),
            ListTile(
              title: Text(
                "Inicio",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontSize: _getFontSize(16)),
              ),
              onTap: inicioPage,
            ),
            ListTile(
              title: Text(
                "Catálogo",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontSize: _getFontSize(16)),
              ),
              onTap: catalogopage,
            ),
            ListTile(
              title: Text(
                "Perfil",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontSize: _getFontSize(16)),
              ),
              onTap: perfilpage,
            ),
            ListTile(
              title: Text(
                "Acerca de",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontSize: _getFontSize(16)),
              ),
              onTap: aboutPage,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          color: _getBackgroundColor(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Preferencias",
                style: TextStyle(
                  fontSize: _getFontSize(24),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              SwitchListTile(
                title: Text(
                  "Modo Oscuro",
                  style: TextStyle(fontSize: _getFontSize(16)),
                ),
                subtitle: Text(
                  "Activar tema oscuro",
                  style: TextStyle(fontSize: _getFontSize(14)),
                ),
                value: _isDarkMode,
                onChanged: (value) {
                  setState(() {
                    _isDarkMode = value;
                  });
                  _savePreference('darkMode', value);
                  MyApp.updateTheme(value);
                },
              ),
              ListTile(
                title: Text(
                  "Tamaño de Fuente",
                  style: TextStyle(fontSize: _getFontSize(16)),
                ),
                subtitle: Text(
                  "Ajustar tamaño de texto",
                  style: TextStyle(fontSize: _getFontSize(14)),
                ),
                trailing: DropdownButton<String>(
                  value: _fontSize,
                  items: ['Pequeña', 'Normal', 'Grande'].map((String size) {
                    return DropdownMenuItem<String>(
                      value: size,
                      child: Text(
                        size,
                        style: TextStyle(fontSize: _getFontSize(16)),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _fontSize = value;
                      });
                      _savePreference('fontSize', value);
                    }
                  },
                ),
              ),
              ListTile(
                title: Text(
                  "Color de Fondo",
                  style: TextStyle(fontSize: _getFontSize(16)),
                ),
                subtitle: Text(
                  "Seleccionar color de fondo",
                  style: TextStyle(fontSize: _getFontSize(14)),
                ),
                trailing: DropdownButton<String>(
                  value: _backgroundColor,
                  items: ['Blanco', 'Gris Claro', 'Azul Claro'].map((String color) {
                    return DropdownMenuItem<String>(
                      value: color,
                      child: Text(
                        color,
                        style: TextStyle(fontSize: _getFontSize(16)),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _backgroundColor = value;
                      });
                      _savePreference('backgroundColor', value);
                    }
                  },
                ),
              ),
              SwitchListTile(
                title: Text(
                  "Vista de Cuadrícula Compacta",
                  style: TextStyle(fontSize: _getFontSize(16)),
                ),
                subtitle: Text(
                  "Mostrar cuadrícula de anime en modo compacto",
                  style: TextStyle(fontSize: _getFontSize(14)),
                ),
                value: _compactGridView,
                onChanged: (value) {
                  setState(() {
                    _compactGridView = value;
                  });
                  _savePreference('compactGridView', value);
                },
              ),
              SwitchListTile(
                title: Text(
                  "Mostrar Nombres Completos",
                  style: TextStyle(fontSize: _getFontSize(16)),
                ),
                subtitle: Text(
                  "Mostrar nombres completos de los animes",
                  style: TextStyle(fontSize: _getFontSize(14)),
                ),
                value: _showFullNames,
                onChanged: (value) {
                  setState(() {
                    _showFullNames = value;
                  });
                  _savePreference('showFullNames', value);
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Volver",
                  style: TextStyle(fontSize: _getFontSize(16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}