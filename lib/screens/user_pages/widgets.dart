//tendra el UI del post
//info basica del propietario del post
//Post como tal
//Acciones y descripcion del post (like, comments)
import 'package:flutter/material.dart';
import 'dart:math';

//! Esto se tiene que mandar por algun lado!!!
//Definir lista aqui con los datos obtenidos de tabla: Post
List<String> items = ["Jhon", "Keneth", "Joel", "Andres"];
List<String> username = ["jhonW1", "kenethL2", "joelB3", "andresC4"];
String description =
    "Este es el primer y unico post de User jeje. Solo para variar algo de contenido y no mostrar informacion generica en la interfaz. Tambien puedes ingresar a detalles del post dando tap al username o photo :D";

//////////////////////////////////////////////
class Post extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int rand = Random().nextInt(4);
    return Column(
      children: <Widget>[
        //Row para info basica del user
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: <Widget>[
              //SizedBox(width: 10,),
              //avatar
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(
                        "https://cdn140.picsart.com/315324509038201.jpg?type=webp&to=min&r=640"),
                  ),
                ),
              ),
              //Column con User Name & @username
              Column(
                children: <Widget>[
                  Text(
                    "${items[rand]}",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                      "@${username[rand]}"), //? tal bez cambiar por distancia jeje
                ],
              ),
              //Spacer
              Spacer(),
              //button "seguir"
              TextButton(
                onPressed: () {},
                child: Text(
                  "Seguir",
                  style: TextStyle(
                    color: Color(0xff9097fd),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              //SizedBox(width: 10,),
            ],
          ),
        ),
        //Widget para foto
        Padding(
          padding: EdgeInsets.only(
            right: 16,
            left: 16,
          ),
          child: ClipRRect(
            //height: 100,
            //width: MediaQuery.of(context).size.width,
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
                "https://cdn.noticiasenlamira.com/2021/04/Save-Ralph.jpg"),
          ),
        ),

        //SizedBox(height: 10,),
        // Likes comment
        Container(
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 30,
              ),
              //like icon
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.favorite,
                  color: Color(0xff9097fd),
                  size: 25,
                ),
              ),
              //comment
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.messenger,
                  color: Color(0xff9097fd),
                  size: 25,
                ),
              ),
              Spacer(),
              Text("* * * * "),
              SizedBox(
                width: 30,
              ),
            ],
          ),
        ),
        //! Descripcion
        Padding(
          padding: EdgeInsets.only(
            right: 16,
            left: 16,
          ),
          child: RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                  text: "@${username[rand]} ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: "$description"),
              ],
            ),
          ),
        ),
        const Divider(
          height: 40,
          thickness: 1,
          indent: 20,
          endIndent: 20,
        ),
      ],
    );
  }
}
