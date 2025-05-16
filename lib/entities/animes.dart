

import 'package:terrain_anime/entities/generos.dart';

import 'plataformas.dart';

class Anime{
    String name;
    int clasificacion;
    String portada;
    double width;
    double heigth;
    List<Plataformas> plataformas;
    List<Generos> generos;
    Anime(this.name,this.clasificacion,this.portada,this.width,this.heigth,this.plataformas,this.generos);
    
}