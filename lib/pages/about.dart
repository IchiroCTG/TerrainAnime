import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final _formKey = GlobalKey<FormState>();
  final _favoriteAnimeController = TextEditingController();
  final _appFeaturesController = TextEditingController();
  final _featuresController = TextEditingController();
  final _animesPerMonthController = TextEditingController();
  List<String> _selectedFeatures = [];
  double _rating = 3.0;
  String? _selectedPlatform;
  bool _notifications = false;
  String _fontSize = 'Normal';
  String _backgroundColor = 'Blanco';

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
        return Colors.white;
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final formData = {
        'favorite_anime': _favoriteAnimeController.text,
        'app_features': _selectedFeatures,
        'rating': _rating,
        'platform': _selectedPlatform,
        'notifications': _notifications,
        'desired_features': _featuresController.text,
        'animes_per_month': _animesPerMonthController.text,
      };
      final jsonData = jsonEncode(formData);

      final email = 'pgutierrez21@alumnos.utalca.cl';
      final subject = Uri.encodeComponent('Anime Terrain Form Submission');
      final body = Uri.encodeComponent('Form Data:\n$jsonData');
      final mailtoUrl = Uri.parse('mailto:$email?subject=$subject&body=$body');

      try {
        if (await canLaunchUrl(mailtoUrl)) {
          await launchUrl(mailtoUrl);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se pudo abrir la aplicación de correo')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al abrir el correo: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _favoriteAnimeController.dispose();
    _appFeaturesController.dispose();
    _featuresController.dispose();
    _animesPerMonthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Acerca de")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          color: _getBackgroundColor(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Anime Terrain',
                style: TextStyle(
                  fontSize: _getFontSize(24),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Desarrollado por IchiroCTG',
                style: TextStyle(fontSize: _getFontSize(18)),
              ),
              const SizedBox(height: 16),
              Text(
                'Correo de contacto:',
                style: TextStyle(fontSize: _getFontSize(18)),
              ),
              Text(
                'pgutierrez21@alumnos.utalca.cl',
                style: TextStyle(
                  fontSize: _getFontSize(18),
                  color: Colors.amber,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Formulario de Retroalimentación',
                style: TextStyle(
                  fontSize: _getFontSize(20),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Q1: Favorite Anime
                    TextFormField(
                      controller: _favoriteAnimeController,
                      decoration: const InputDecoration(
                        labelText: '¿Cuál es tu anime favorito?',
                        border: OutlineInputBorder(),
                      ),
                      style: TextStyle(fontSize: _getFontSize(16)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese su anime favorito';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Q2: App Features (Multiple Choice)
                    Text(
                      '¿Qué sueles buscar en una app de anime?',
                      style: TextStyle(fontSize: _getFontSize(16)),
                    ),
                    ...[
                      'Dónde ver un anime',
                      'Puntajes y reseñas de usuarios',
                      'Información del anime',
                      'Recomendaciones personalizadas',
                      'Seguir y comentar capítulos'
                    ].map((option) => CheckboxListTile(
                          title: Text(
                            option,
                            style: TextStyle(fontSize: _getFontSize(16)),
                          ),
                          value: _selectedFeatures.contains(option),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                _selectedFeatures.add(option);
                              } else {
                                _selectedFeatures.remove(option);
                              }
                            });
                          },
                        )),
                    const SizedBox(height: 16),
                    // Q3: Rating
                    Text(
                      '¿Qué tan útil te parece la aplicación Anime Terrain?',
                      style: TextStyle(fontSize: _getFontSize(16)),
                    ),
                    Slider(
                      value: _rating,
                      min: 1,
                      max: 5,
                      divisions: 4,
                      label: _rating.round().toString(),
                      onChanged: (value) {
                        setState(() {
                          _rating = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    // Q4: Platform Dropdown
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: '¿Cuál es tu plataforma de anime favorita?',
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedPlatform,
                      items: [
                        'Crunchyroll',
                        'Netflix',
                        'Amazon Prime Video',
                        'HiDive',
                        'AnimeFLV',
                        'Otra'
                      ].map((String platform) {
                        return DropdownMenuItem<String>(
                          value: platform,
                          child: Text(
                            platform,
                            style: TextStyle(fontSize: _getFontSize(16)),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedPlatform = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Por favor seleccione una plataforma';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Q5: Notifications (Boolean)
                    CheckboxListTile(
                      title: Text(
                        '¿Te gustaría recibir notificaciones?',
                        style: TextStyle(fontSize: _getFontSize(16)),
                      ),
                      value: _notifications,
                      onChanged: (bool? value) {
                        setState(() {
                          _notifications = value ?? false;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    // Q6: Desired Features
                    TextFormField(
                      controller: _featuresController,
                      decoration: const InputDecoration(
                        labelText: '¿Qué características te gustaría ver?',
                        border: OutlineInputBorder(),
                      ),
                      style: TextStyle(fontSize: _getFontSize(16)),
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese las características deseadas';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Q7: Animes per Month
                    TextFormField(
                      controller: _animesPerMonthController,
                      decoration: const InputDecoration(
                        labelText: '¿Cuántos animes ves al mes?',
                        border: OutlineInputBorder(),
                      ),
                      style: TextStyle(fontSize: _getFontSize(16)),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese un número';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Por favor ingrese un número válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text(
                        'Enviar Mensaje',
                        style: TextStyle(fontSize: _getFontSize(16)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}