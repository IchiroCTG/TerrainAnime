

import 'package:flutter/material.dart';
import 'package:terrain_anime/entities/animes.dart';
import 'package:terrain_anime/entities/perfil_person.dart';
import 'package:terrain_anime/pages/Catologo.dart';
import 'package:terrain_anime/pages/anime_page.dart';
import 'package:terrain_anime/pages/myhomepage.dart';

PerfilPerson perfil =PerfilPerson("Lautaro", [animes[0]],'lib/assets/images/perfil.png',200,200);

class PerfilPage extends StatelessWidget{
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {

void animepage(){
 Navigator.push(context,MaterialPageRoute(builder: (context)=> AnimePage())); 
}
void perfilpage(){
  Navigator.push(context,MaterialPageRoute(builder: (context)=>PerfilPage())); 
}
void catalogopage(){
  Navigator.push(context,MaterialPageRoute(builder: (context)=>catalogoPage())); 
}
    void inicioPage(){
       Navigator.push(context,MaterialPageRoute(builder: (context)=> MyHomePage(title: "Anime Terrain",))); 
    }
  

    return Scaffold(
      appBar: AppBar(title: Text("Perfil")),

      drawer: Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: Colors.blue),
          child: Text(
            "Navegación",
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
        ListTile(
          title: Text("Inicio"),
          onTap: () => inicioPage(),
        ),
        ListTile(
          title: Text("Catologo"),
          onTap: () => catalogopage(),
        ),

      ],
    ),
  ),
      body: Center(
        child: Column(
          children: [
                Row(
                  children: [
                    Image.asset(perfil.iconPath,width: perfil.width,height: perfil.heigth),
                    Text(perfil.nombre),
                  ],
                ),
                Text("Animes Favoritos"),
                Container(
                  color: Colors.amber,
                  height: 220,
                  child: Row(
                    children: [
                       Row(
                  children: [
                    GestureDetector(
                      onTap:()=>animepage() ,
                      child: Image.asset(animes[0].portada,width: 200,height: 200),
                    )
                  ]
                  
                )
                    ],
                  ),
                )
            ],
          ),
        )
      /*persistentFooterButtons: [

      ],*/

      
    );
  }


}