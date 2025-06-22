import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:terrain_anime/entities/animes.dart';
import 'package:terrain_anime/entities/perfil_person.dart';
import 'package:terrain_anime/pages/Catologo.dart';
import 'package:terrain_anime/pages/anime_page.dart';
import 'package:terrain_anime/pages/myhomepage.dart';
import 'package:terrain_anime/pages/about.dart';
import 'package:terrain_anime/pages/preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

PerfilPerson perfil = PerfilPerson(
  "Lautaro",
  [animes[0]],
  'lib/assets/images/perfil.png',
  200,
  200,
);

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  String _fontSize = 'Normal';
  String _backgroundColor = 'Blanco';
  bool _showFullNames = true;
  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fontSize = prefs.getString('fontSize') ?? 'Normal';
      _backgroundColor = prefs.getString('backgroundColor') ?? 'Blanco';
      _showFullNames = prefs.getBool('showFullNames') ?? true;
      _profileImagePath = prefs.getString('profileImagePath');
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _profileImagePath = pickedFile.path;
        prefs.setString('profileImagePath', pickedFile.path);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto de perfil actualizada')),
      );
    }
  }

  Future<void> _resetImage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _profileImagePath = null;
      prefs.remove('profileImagePath');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Foto de perfil restablecida')),
    );
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
        return Theme.of(context).colorScheme.surfaceContainerLow;
      case 'Azul Claro':
        return Theme.of(context).colorScheme.primaryContainer;
      default:
        return Theme.of(context).scaffoldBackgroundColor;
    }
  }

  void animepage(Anime anime) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AnimePage(anime: anime)),
    );
  }

  void catalogopage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const catalogoPage()),
    );
  }

  void inicioPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MyHomePage(title: "Anime Terrain"),
      ),
    );
  }

  void aboutpage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AboutPage()),
    );
  }

  void preferencespage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PreferencesPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          perfil.nombre,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: _getFontSize(20),
              ),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: Drawer(
        backgroundColor: Theme.of(context).drawerTheme.backgroundColor,
        shadowColor: Theme.of(context).drawerTheme.shadowColor,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: Text(
                      "Navegación",
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontSize: _getFontSize(24),
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Inicio",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: _getFontSize(16),
                          ),
                    ),
                    onTap: inicioPage,
                  ),
                  ListTile(
                    title: Text(
                      "Catálogo",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: _getFontSize(16),
                          ),
                    ),
                    onTap: catalogopage,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.info),
                    onPressed: aboutpage,
                    tooltip: "Acerca de",
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: preferencespage,
                    tooltip: "Preferencias",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          color: _getBackgroundColor(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Sección de Perfil
              const SizedBox(height: 16),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: perfil.width / 2,
                      backgroundImage: _profileImagePath != null
                          ? FileImage(File(_profileImagePath!))
                          : AssetImage(perfil.iconPath) as ImageProvider,
                    ),
                  ),
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Icon(
                      Icons.camera_alt,
                      size: 16,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                perfil.nombre,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: _getFontSize(20),
                      fontWeight: FontWeight.bold,
                    ),
                softWrap: true,
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _resetImage,
                child: Text(
                  'Restablecer Imagen',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: _getFontSize(14),
                      ),
                ),
              ),
              const Divider(height: 32),
              // Sección de Animes Favoritos
              Text(
                "Animes Favoritos",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: _getFontSize(18),
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              perfil.animesFavoritos.isEmpty
                  ? Text(
                      "No hay animes favoritos",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: _getFontSize(16),
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    )
                  : SizedBox(
                      height: 240,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: perfil.animesFavoritos.length,
                        itemBuilder: (context, index) {
                          final anime = perfil.animesFavoritos[index];
                          return GestureDetector(
                            onTap: () => animepage(anime),
                            child: Container(
                              width: 160,
                              margin: const EdgeInsets.only(right: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      anime.portada,
                                      width: 160,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  if (_showFullNames)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        anime.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              fontSize: _getFontSize(14),
                                            ),
                                        softWrap: true,
                                        overflow: TextOverflow.visible,
                                        maxLines: 2,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              const Divider(height: 32),
              // Botón de Volver
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Volver',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: _getFontSize(16),
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}