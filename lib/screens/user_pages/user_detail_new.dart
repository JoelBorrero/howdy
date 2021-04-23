import 'package:flutter/material.dart';
import 'package:howdy/widgets/frnd_info_widget.dart';
import 'package:howdy/widgets/interest_widget.dart';
import 'package:howdy/widgets/little_post_widget.dart';

bool profilePicture = true;
bool matchInfo = true;
bool hasPosts = true;
bool _isSelected = false;


class UserDetailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: (
              IconButton(
                icon: Icon(Icons.arrow_back), 
                onPressed: () {  }, 
              )
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextButton(
                  onPressed: () => {}, 
                  child: Text(
                    "Seguir",
                    style: TextStyle(
                      color: Colors.white,
                      
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    primary: Colors.blue,
                    backgroundColor: Color(0xff9097fd),
                    onSurface: Colors.red,
                  ),
                ),
              ),
            ],
            backgroundColor: Color(0xffc4c7ce),
            pinned: true,
            expandedHeight: MediaQuery.of(context).size.width,
            flexibleSpace: FlexibleSpaceBar(
              //titlePadding: EdgeInsets.all(12),
              
              title: Text(
                "Nombre de Usuario",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),
              ),
              
              background: (profilePicture)? 
                  //imgen desde base de datos
                  //! corregir tamaño que ocupa en container (no sale completo)
                Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      "https://cdn140.picsart.com/315324509038201.jpg?type=webp&to=min&r=640", 
                      fit: BoxFit.cover,  
                    ),
                  ],
                ):
                Center(
                  child: Text(
                    "Subir Imagen",
                    style: TextStyle(
                      color: Color(0xffe4e4e4),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              //va a estar toda la info del user
              children: <Widget>[
                UserFrndInfo(),
                Row(
                  children: [
                    Text(
                      "Biografía", 
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    TextButton(
                      onPressed: (){}, //Abrir ventana para editar Biografia
                      child: Text("editar", style: TextStyle(color: Color(0xff9097fd),),)
                      
                    ),
                  ],
                ),
                Align(
                  child: Text("Agrega algo sobre ti."),
                  alignment: Alignment.bottomLeft,
                ),
                SizedBox(
                  height: 16,
                ),
                //Match info
                Row(
                  children: [
                    Text(
                      "Match Info", 
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    TextButton(
                      onPressed: (){}, //Abrir ventana para editar Biografia
                      child: Text("editar", style: TextStyle(color: Color(0xff9097fd),),)
                    ),
                  ],
                ),
                //Mostrar intereses
                (matchInfo)? UserInterestWidget()
                : Align(
                child: Text("Agrega lo que te guste aqui."),
                alignment: Alignment.topLeft,
                ),
                SizedBox(
                  height: 16,
                ),
                //Post Info
                Row(
                  children: [
                    Text(
                      "Post info", 
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    TextButton(
                      onPressed: (){}, //Abrir UserPostView()
                      //mostrar todos los post publicados por este usuario
                      child: (hasPosts)?Text(
                        "ver más", 
                        style: TextStyle(color: Color(0xff9097fd),),):
                      Text(
                        "agregar", 
                        style: TextStyle(color: Color(0xff9097fd),),),
                    ),
                  ],
                ),
                //todo Post recientes, ooo mensaje que diga que aun no tienes posts
                (hasPosts)? Wrap(
                  children: [
                   LittlePostRectangleWidget(),
                   LittlePostRectangleWidget(),
                   LittlePostRectangleWidget(),
                   LittlePostRectangleWidget(),
                   LittlePostRectangleWidget(),
                   LittlePostRectangleWidget(),
                   LittlePostRectangleWidget(),
                   LittlePostRectangleWidget(),
                  ],
                )
                : Align(
                child: Text("Aún no tienes Post, prueba a \"agregar\""),
                alignment: Alignment.topLeft,
                ),
                Divider(
                  height: 40,
                  thickness: 1,
                  indent: 20,
                  endIndent: 20,
                ),
              ],
            ),
          ),
              ]
            ),
            
          ),
        ],
      ),
    );
  }
}