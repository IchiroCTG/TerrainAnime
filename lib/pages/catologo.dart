import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:terrain_anime/entities/animes.dart';
import 'package:terrain_anime/pages/myhomepage.dart';
import 'package:terrain_anime/pages/perfil.dart';
import 'package:terrain_anime/pages/anime_page.dart';

class catalogoPage extends StatefulWidget {
  const catalogoPage({super.key});

  @override
  State<catalogoPage> createState() => _catalogoPageState();
}

class _catalogoPageState extends State<catalogoPage> {
  bool _compactGridView = false;

  @override
  void initState() {
    super.initState();
    _loadGridPreference();
  }

  Future<void> _loadGridPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _compactGridView = prefs.getBool('compactGridView') ?? false;
    });
  }

  void inicioPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const MyHomePage(title: "Anime Terrain")));
  }

  void perfilpage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const PerfilPage()));
  }

  void animepage(Anime anime) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AnimePage(anime: anime)));
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: Text(
                "Navegación",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            ListTile(
              title: Text(
                "Inicio",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              onTap: inicioPage,
            ),
            ListTile(
              title: Text(
                "Perfil",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              onTap: perfilpage,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: _compactGridView ? 0.9 : 0.7,
                ),
                itemCount: animes.length,
                itemBuilder: (context, index) {
                  final anime = animes[index];
                  return GestureDetector(
                    onTap: () => animepage(anime),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              flex: 7, // 70% de la altura para la imagen
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  anime.portada,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3, // 30% de la altura para el texto
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  anime.name,
                                  style: const TextStyle(fontSize: 16),
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
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
      persistentFooterButtons: const [],
    );
  }
}