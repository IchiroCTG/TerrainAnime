import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:terrain_anime/entities/animes.dart';
import 'package:terrain_anime/entities/generos.dart';
import 'package:terrain_anime/entities/plataformas.dart';
import 'package:terrain_anime/pages/anime_page.dart';
import 'package:terrain_anime/pages/Catologo.dart';
import 'package:terrain_anime/pages/perfil.dart';
import 'package:terrain_anime/pages/about.dart';
import 'package:terrain_anime/pages/preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

List<Plataformas> plataformas = [
  Plataformas("Crunchyroll", "lib/assets/images/crunchyroll.png", 50, 50),
  Plataformas("Netflix", "lib/assets/images/netflix.png", 50, 50),
];

List<Anime> animes = [
  Anime(
    "Ao No Exorcist",
    4,
    12,
    "Rin Okumura es el hijo de satan y se vuelve un exorcista.",
    'lib/assets/images/AoNoExorcist.jpg',
    [plataformas[0], plataformas[1]],
    [Generos.aventura, Generos.fantasia, Generos.accion],
  ),
  Anime(
    "A Rank Party wo Ridatsu Shita Ore wa Shinbu wo Mezasu",
    4.5,
    24,
    "Yuke es expulsado y decide formar su propio equipo para demostrar su valía.",
    'lib/assets/images/ARank.jpg',
    [plataformas[0]],
    [
      Generos.aventura,
      Generos.fantasia,
      Generos.accion,
      Generos.comedia,
      Generos.romance
    ],
  ),
  Anime("Kimetsu no Yaiba",4.2,12,"Tanjiro buscara vengar a su familia","lib/assets/images/KNY.jpg",[plataformas[0],plataformas[1]],[Generos.accion, Generos.fantasia, Generos.shounen]),
  Anime("My Hero Academia",4,12, "Héroes en formación.","lib/assets/images/MHA.jpg",[plataformas[0],plataformas[1]] ,[Generos.comedia, Generos.accion, Generos.shounen]),
  Anime("Shingeki no Kyojin", 4.3,24,"Batalla por la supervivencia.", "lib/assets/images/SNK.jpg",[plataformas[0],plataformas[1]], [Generos.accion, Generos.fantasia, Generos.shounen]),
];

class _MyHomePageState extends State<MyHomePage> {
  bool _compactGridView = false;
  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _compactGridView = prefs.getBool('compactGridView') ?? false;
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

  void _navigateToAnimePage(Anime anime) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AnimePage(anime: anime)));
  }

  void _navigateToPerfilPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const PerfilPage()));
  }

  void _navigateToCatalogoPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const catalogoPage()));
  }

  void _navigateToAboutPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const AboutPage()));
  }

  void _navigateToPreferencesPage() {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PreferencesPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                backgroundImage: _profileImagePath != null
                    ? FileImage(File(_profileImagePath!))
                    : const AssetImage('lib/assets/images/placeholder.png')
                        as ImageProvider,
                radius: 20,
              ),
            ),
          ),
        ],
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
                      "Anime Terrain",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Perfil",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    onTap: _navigateToPerfilPage,
                  ),
                  ListTile(
                    title: Text(
                      "Catálogo",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    onTap: _navigateToCatalogoPage,
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
                    onPressed: _navigateToAboutPage,
                    tooltip: "Acerca de",
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: _navigateToPreferencesPage,
                    tooltip: "Preferencias",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                "Bienvenido a Anime Terrain",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              // Sección Contenido de Valor
              Text(
                "Animes Recomendados",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 10),
              ...animes.where((anime) => [
                    "valía",
                    "vengar",
                    "supervivencia",
                    "héroes",
                    "formación"
                  ].any((keyword) => anime.descripcion.toLowerCase().contains(keyword.toLowerCase()))).map((anime) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Card(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(
                          anime.portada,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        anime.name,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      subtitle: Text(
                        anime.descripcion,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () => _navigateToAnimePage(anime),
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(height: 20),
              // GridView existente
              const Text(
                "Catálogo de Animes",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: _compactGridView ? 0.85 : 0.65,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: animes.length,
                itemBuilder: (context, index) {
                  final anime = animes[index];
                  return GestureDetector(
                    onTap: () => _navigateToAnimePage(anime),
                    child: Card(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                anime.portada,
                                width: 130,
                                height: 130,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text(
                                  anime.name,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        fontSize: _compactGridView ? 12 : 14,
                                      ),
                                  softWrap: true,
                                  overflow: TextOverflow.clip,
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}