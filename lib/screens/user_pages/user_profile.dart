import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:howdy/models/user_info.dart';
import 'package:howdy/services/database.dart';
import 'package:howdy/widgets/frnd_info_widget.dart';
import 'package:howdy/widgets/interest_widget.dart';
import 'package:howdy/widgets/little_post_widget.dart';
import 'package:image_picker/image_picker.dart';

bool profilePicture = true,
    matchInfo = true,
    hasPosts = true,
    _myProfile = false;
String _uid = FirebaseAuth.instance.currentUser.uid;
DatabaseService _db = DatabaseService(uid: _uid);

class UserDetailView extends StatefulWidget {
  final PersonalInfo profileOwner;
  UserDetailView({this.profileOwner});

  @override
  _UserDetailViewState createState() => _UserDetailViewState();
}

class _UserDetailViewState extends State<UserDetailView> {
  @override
  Widget build(BuildContext context) {
    print(widget.profileOwner.profilePic);
    _myProfile = _uid == widget.profileOwner.reference.id; //Temporal xD
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
              leading: (IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context))),
              actions: [
                _myProfile ? Text('') : _followButton(),
              ],
              backgroundColor: Color(0xffc4c7ce),
              pinned: true,
              expandedHeight: MediaQuery.of(context).size.width,
              title: Text('@${widget.profileOwner.username}'),
              flexibleSpace: FlexibleSpaceBar(
                  //titlePadding: EdgeInsets.all(12),
                  title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.profileOwner.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        _myProfile
                            ? Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: FloatingActionButton(
                                    mini: true,
                                    child: Icon(Icons.camera_alt_outlined,
                                        color: Colors.white),
                                    onPressed: () async {
                                      await _db.setProfilePic(
                                          context, ImageSource.gallery);
                                      setState(() {});
                                    }),
                              )
                            : Text('')
                      ]),
                  background: widget.profileOwner.profilePic != ''
                      ? Container(
                          child: Image.network(widget.profileOwner.profilePic,
                              fit: BoxFit.cover))
                      : Icon(Icons.person_outline,
                          color: Colors.white30, size: 200))),
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
                      child: Text(widget.profileOwner.biography),
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
                                    color: Theme.of(context).accentColor,
                                  ),
                                )
                              : Text(
                                  "agregar",
                                  style: TextStyle(
                                    color: Theme.of(context).accentColor,
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
    );
  }

  Widget _followButton() => Padding(
        padding: const EdgeInsets.all(12.0),
        child: TextButton(
          onPressed: () => print(
              '_myProfile\n${FirebaseAuth.instance.currentUser.uid} == ${widget.profileOwner.reference.id}'),
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
