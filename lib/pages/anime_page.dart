import 'package:flutter/material.dart';
import 'package:terrain_anime/pages/Catologo.dart';
import 'package:terrain_anime/pages/myhomepage.dart';
import 'package:terrain_anime/pages/perfil.dart';

class AnimePage extends StatelessWidget{
  const AnimePage({super.key});

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
    }  /*void _nextPage(){
      Navigator.push(context, MaterialPageRoute(builder: (context) => aboutPage()));
  }*/


    return Scaffold(
      appBar: AppBar(title: Text('Catalogo')),
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
          title: Text("Catalogo"),
          onTap: () => catalogopage(),
        ),
        ListTile(
          title: Text("Perfil"),
          onTap: () => perfilpage(),
        ),

      ],
    ),
  ),
        body: Center(
          child: Column(
            children: [
              Container(
                color: Colors.orange,
                child: Row(
                  children: [
                    Image.asset(animes[0].portada,width: 150,height: 150,),
                    Text("Anime: "),
                    Text(animes[0].name),
                  ],
                )
              ),
              Container(
                color: Colors.lightBlue,
                child: Row(
                  children: [
                    Text("Plataformas: "),
                    Image.asset(animes[0].plataformas[0].iconPath,width: 50, height: 50),
                    Text(animes[0].plataformas[0].name),
                    Image.asset(animes[0].plataformas[1].iconPath,width: 50, height: 50),
                    Text(animes[0].plataformas[1].name),
                  ],
                )
              )
            ],
          )
        )
      
  

      
    );
  }


}