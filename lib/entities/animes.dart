

import 'package:terrain_anime/entities/generos.dart';

import 'plataformas.dart';

class Anime{
    String name;
    double clasificacion;
    int episodios;
    String descripcion;
    String portada;
    List<Plataformas> plataformas;
    List<Generos> generos;
    Anime(this.name,this.clasificacion,this.episodios,this.descripcion,this.portada,this.plataformas,this.generos);
    
}