import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:howdy/models/user_info.dart';
import 'package:howdy/widgets/frnd_info_widget.dart';
import 'package:howdy/widgets/interest_widget.dart';
import 'package:howdy/widgets/little_post_widget.dart';

bool profilePicture = true,
    matchInfo = true,
    hasPosts = true,
    _myProfile = false;

class UserDetailView extends StatelessWidget {
  final PersonalInfo author;
  UserDetailView({this.author});

  @override
  Widget build(BuildContext context) {
    _myProfile = FirebaseAuth.instance.currentUser.uid ==
        author.reference.id; //Temporal xD
    return Scaffold(
      body: Center(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              leading: (IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context))),
              actions: [
                _myProfile
                    ? IconButton(icon: Icon(Icons.edit), onPressed: () {})
                    : _followButton(),
              ],
              backgroundColor: Color(0xffc4c7ce),
              pinned: true,
              expandedHeight: MediaQuery.of(context).size.width,
              title: Text('@${author.username}'),
              flexibleSpace: FlexibleSpaceBar(
                //titlePadding: EdgeInsets.all(12),

                title: Text(
                  author.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),

                background: (profilePicture)
                    ?
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
                      )
                    : Center(
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
              delegate: SliverChildListDelegate([
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
                          _myProfile
                              ? _textButton(text: 'editar', onPressed: () {})
                              : Text(''),
                        ],
                      ),
                      Align(
                        child: Text(author.biography),
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
                          _textButton(onPressed: () {}, text: 'editar'),
                        ],
                      ),
                      //Mostrar intereses
                      (matchInfo)
                          ? UserInterestWidget()
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
                            onPressed: () {}, //Abrir UserPostView()
                            //mostrar todos los post publicados por este usuario
                            child: (hasPosts)
                                ? Text(
                                    "ver más",
                                    style: TextStyle(
                                      color: Color(0xff9097fd),
                                    ),
                                  )
                                : Text(
                                    "agregar",
                                    style: TextStyle(
                                      color: Color(0xff9097fd),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                      //todo Post recientes, ooo mensaje que diga que aun no tienes posts
                      (hasPosts)
                          ? Wrap(
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
                              child: Text(
                                  "Aún no tienes Post, prueba a \"agregar\""),
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
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _followButton() => Padding(
        padding: const EdgeInsets.all(12.0),
        child: TextButton(
          onPressed: () => print(
              '_myProfile\n${FirebaseAuth.instance.currentUser.uid} == ${author.reference.id}'),
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
      );
  Widget _textButton({String text, Function() onPressed}) => TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: Color(0xff9097fd),
        ),
      ));
}
