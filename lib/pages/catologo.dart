import 'package:flutter/material.dart';
import 'package:terrain_anime/pages/myhomepage.dart';
import 'package:terrain_anime/pages/Catologo.dart';
import 'package:terrain_anime/pages/perfil.dart';
import 'package:terrain_anime/pages/anime_page.dart';

class catalogoPage extends StatelessWidget{
  const catalogoPage({super.key});

  @override
  Widget build(BuildContext context) {

    void inicioPage(){
       Navigator.push(context,MaterialPageRoute(builder: (context)=> MyHomePage(title: "Anime Terrain",))); 
    }
    void perfilpage(){
      Navigator.push(context,MaterialPageRoute(builder: (context)=>PerfilPage())); 
    }
    void animepage(){
      Navigator.push(context,MaterialPageRoute(builder: (context)=>AnimePage())); 
    }

  /*void _nextPage(){
      Navigator.push(context, MaterialPageRoute(builder: (context) => aboutPage()));
  }*/


    return Scaffold(
      appBar: AppBar(title: Text('Catologo')),

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
          title: Text("Perfil"),
          onTap: () => perfilpage(),
        ),

      ],
    ),
  ),
      body:Center(
        child:GestureDetector(
              onTap:() => animepage(),
              child: Image.asset(animes[0].portada,width: animes[0].width,height: animes[0].heigth),
              )
      ),
     
      persistentFooterButtons: [],

      
    );
  }


}