import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:terrain_anime/entities/animes.dart';
import 'package:terrain_anime/pages/Catologo.dart';
import 'package:terrain_anime/pages/myhomepage.dart';
import 'package:terrain_anime/pages/perfil.dart';
import 'package:terrain_anime/pages/comments_page.dart';
class AnimePage extends StatefulWidget {
  final Anime anime;
  const AnimePage({super.key, required this.anime});

  @override
  State<AnimePage> createState() => _AnimePageState();
}

class _AnimePageState extends State<AnimePage> {
  String _fontSize = 'Normal';
  String _backgroundColor = 'Blanco';
  bool _showFullNames = true;

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
    });
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
        return Theme.of(context).scaffoldBackgroundColor; // Use theme background
    }
  }

  void perfilpage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PerfilPage()),
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

  void commentPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CommentsPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.anime.name,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: _getFontSize(20),
              ),
          overflow: TextOverflow.ellipsis, // Truncate in AppBar
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: Drawer(
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
            ListTile(
              title: Text(
                "Perfil",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: _getFontSize(16),
                    ),
              ),
              onTap: perfilpage,
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
              // Portada
              Center(
                child: Image.asset(
                  widget.anime.portada,
                  width: 200,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              // Nombre del anime
              if (_showFullNames)
                Text(
                  widget.anime.name,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: _getFontSize(20),
                        fontWeight: FontWeight.bold,
                        color: Colors.black87
                      ),
                  softWrap: true, // Allow wrapping to next line
                  overflow: TextOverflow.visible, // Ensure text wraps
                ),
              const SizedBox(height: 8),
              // Episodios
              Text(
                'Numero de Episodios: ${widget.anime.episodios}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: _getFontSize(16),color: Colors.black87
                      
                    ),
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
              const SizedBox(height: 8),
              // Descripción
              Text(
                'Descripcion: ${widget.anime.descripcion}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: _getFontSize(16),color: Colors.black87
                    ),
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
              // Plataformas
              Container(
                padding: const EdgeInsets.all(8.0),
                color: Theme.of(context).colorScheme.secondaryContainer,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Plataformas: ',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontSize: _getFontSize(14),
                          ),
                    ),
                    Expanded(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.anime.plataformas.map((platform) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                platform.iconPath,
                                width: 30,
                                height: 30,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                platform.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      fontSize: _getFontSize(14),
                                    ),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Géneros
              Text(
                'Géneros: ${widget.anime.generos.map((g) => g.toString().split('.').last).join(', ')}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: _getFontSize(16),
                      color: Colors.black87
                    ),
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
              const SizedBox(height: 16),
              // Botón de volver
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Volver'),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () => commentPage(), child: const Text('Comentarios'
                  ),
                ) 
              ),
            ],
          ),
        ),
      ),
    );
  }
}