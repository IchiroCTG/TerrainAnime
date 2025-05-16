
import 'package:flutter/material.dart';
import 'package:terrain_anime/entities/animes.dart';
import 'package:terrain_anime/entities/generos.dart';
import 'package:terrain_anime/entities/plataformas.dart';
import 'package:terrain_anime/pages/anime_page.dart';
import 'package:terrain_anime/pages/Catologo.dart';
import 'package:terrain_anime/pages/perfil.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
List<Plataformas> plataformas = [Plataformas("Crunchyroll", "lib/assets/images/crunchyroll.png",50,50),
Plataformas("Netflix", "lib/assets/images/netflix.jpg",50,50)];

List<Anime> animes = [ Anime("Ao No Exorcist",4,'lib/assets/images/AoNoExorcist.jpg',100,100, [plataformas[0],plataformas[1]],[Generos.aventura,Generos.fantasia,Generos.accion])];
class _MyHomePageState extends State<MyHomePage> {

void animepage(){
 Navigator.push(context,MaterialPageRoute(builder: (context)=>AnimePage())); 
}
void perfilpage(){
  Navigator.push(context,MaterialPageRoute(builder: (context)=>PerfilPage())); 
}
void catalogopage(){
  Navigator.push(context,MaterialPageRoute(builder: (context)=>catalogoPage())); 
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          Padding(padding: EdgeInsets.only( right: 10),
            child: GestureDetector(
              onTap:() => perfilpage(),
              child:CircleAvatar(
              backgroundImage: AssetImage(perfil.iconPath),
              radius:20,
              )
            ),
          )
        ],
        
      ),
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
          title: Text("Perfil"),
          onTap: () => perfilpage(),
        ),
        ListTile(
          title: Text("Catálogo"),
          onTap: () => catalogopage(),
        ),

      ],
    ),
  ),

      body: Center(
         child: Container(
          color: Colors.blueGrey,
          child:Column(
            children: [            
              Row(  
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Animes de Fantasía",
                        textAlign:TextAlign.center, style: TextStyle(color: Colors.white),),      
                 
                ],
              ),
              Container(
                color: Colors.black,
                height: 120,
                alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                  
                    children: [
                       Column(
                        children: [
                          GestureDetector(
                            onTap:() => animepage(),
                            child: Image.asset(animes[0].portada,width: animes[0].width,height: animes[0].heigth),
                          )
                          
                          ],
                       ),
                    ]
                    ),

              )
            
            
            ],
          ),
         ),
        
      ),

    );
  }
}