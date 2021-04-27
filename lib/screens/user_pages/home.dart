import 'dart:io';
import 'package:howdy/shared/functions.dart';

import 'user_profile.dart';
import 'package:flutter/material.dart';
import 'package:howdy/widgets/loading.dart';
import 'package:howdy/models/user_info.dart';
import 'package:howdy/services/database.dart';
import 'package:howdy/widgets/constants.dart';
import 'package:howdy/widgets/post_feed.dart';
import 'package:howdy/widgets/user_card.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

TextEditingController _footerController = TextEditingController();
PersonalInfo _user;
User _fbUser = FirebaseAuth.instance.currentUser;
DatabaseService _db = DatabaseService(uid: _fbUser.uid);

void _load() async {
  _user = await DatabaseService().getPersonalInfo(_fbUser.uid);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            actions: [
              IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => _search())))
            ],
            backgroundColor: Colors.white,
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text('Howdy',
                style: TextStyle(color: Theme.of(context).accentColor))),
        body: _postList(),
        drawer: _drawer(context),
        floatingActionButton: _newPostButton(context));
  }
}

Widget _drawer(BuildContext context) {
  return Drawer(
      child: Column(children: [
    UserAccountsDrawerHeader(
        currentAccountPicture: CircleAvatar(
          child: Text('J'),
        ),
        accountName: Text('${_user?.name}'),
        accountEmail: Text('@${_user?.username}')),
    ListTile(
      leading: Icon(Icons.people_alt_outlined, color: Colors.grey),
      title: Text('Crear grupo'),
      onTap: () {
        Navigator.pop(context);
      },
    ),
    ListTile(
      leading: Icon(Icons.person_outline, color: Colors.grey),
      title: Text('Amigos y grupos'),
      onTap: () {},
    ),
    ListTile(
      leading: Icon(Icons.message_outlined, color: Colors.grey),
      title: Text('Chats directos'),
      onTap: () {},
    ),
    ListTile(
      leading: Icon(Icons.search, color: Colors.grey),
      title: Text('Descubrir'),
      onTap: () {},
    ),
    ListTile(
      leading: Icon(Icons.edit_outlined, color: Colors.grey),
      title: Text('Editar perfil'),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UserDetailView(profileOwner: _user)));
      },
    ),
    ListTile(
      leading: Icon(Icons.settings_outlined, color: Colors.grey),
      title: Text('Configuración'),
      onTap: () {},
    ),
  ]));
}

Widget _search() {
  return StreamBuilder(
      stream: _db.usersCollection.snapshots(),
      builder: (context, snapshot) {
        return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                'Descubrir',
                style: TextStyle(color: Colors.black),
              ),
              iconTheme: IconThemeData(color: Colors.black),
            ),
            body: snapshot.hasData
                ? _usersList(context, snapshot.data.docs)
                : Center(child: Text('Cargando...')));
      });
}

Widget _postList() {
  return StreamBuilder(
      stream: _db.postsCollection.snapshots(),
      builder: (context, snapshot) {
        print(snapshot.data.docs.length);
        return snapshot.hasData
            ? snapshot.data.docs.length > 0
                ? _postsList(context, snapshot.data.docs)
                : Center(
                    child: Text(
                        'Todo está tranquilo por aquí\n\n¿Qué tal si posteamos algo?'))
            : Loading();
      });
}

Widget _postsList(BuildContext context, List<DocumentSnapshot> snapshot) {
  return ListView(children: snapshot.map((data) => Post(data: data)).toList());
}

Widget _usersList(BuildContext context, List<DocumentSnapshot> snapshot) {
  return ListView(
      children: snapshot.map((data) => UserCard(data: data)).toList());
}

FloatingActionButton _newPostButton(BuildContext context) {
  List<File> _images = [];
  return FloatingActionButton(
      child: Icon(Icons.post_add),
      onPressed: () => showModalBottomSheet(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topRight: Radius.circular(50))),
          context: context,
          builder: (_) => SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Nuevo post\n\n',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 22,
                            fontWeight: FontWeight.bold)),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              icon: Icon(Icons.image),
                              onPressed: () {
                                chooseImage(ImageSource.gallery,
                                    images: _images);
                              }),
                          IconButton(
                              icon: Icon(Icons.camera),
                              onPressed: () => chooseImage(ImageSource.camera,
                                  images: _images)),
                        ]),
                    TextField(
                        controller: _footerController,
                        decoration: textInputDecoration.copyWith(
                            labelText: 'Añade un pie de foto')),
                    ElevatedButton(
                        child: Text('Publicar'),
                        onPressed: () {
                          _db.addNewPost(_images, _footerController.text);
                          Navigator.pop(context);
                          _footerController.clear();
                        })
                  ]))));
}
