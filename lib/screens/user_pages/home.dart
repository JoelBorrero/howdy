import 'package:howdy/screens/user_pages/my_groups.dart';
import 'package:howdy/screens/user_pages/new_group.dart';

import 'user_profile.dart';
import 'package:flutter/material.dart';
import 'package:howdy/services/auth.dart';
import 'package:howdy/widgets/loading.dart';
import 'package:howdy/models/user_info.dart';
import 'package:howdy/services/database.dart';
import 'package:howdy/widgets/post_feed.dart';
import 'package:howdy/widgets/user_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:howdy/screens/user_pages/new_post.dart';

PersonalInfo userPersonalInfo;
User firebaseUser = FirebaseAuth.instance.currentUser;
DatabaseService database = DatabaseService(uid: firebaseUser.uid);
AuthService _auth = AuthService();

void _load() async {
  firebaseUser = FirebaseAuth.instance.currentUser;
  database = DatabaseService(uid: firebaseUser.uid);
  userPersonalInfo = await DatabaseService().getPersonalInfo(firebaseUser.uid);
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
    return FutureBuilder<PersonalInfo>(
        future: database.getPersonalInfo(firebaseUser.uid),
        builder: (context, AsyncSnapshot<PersonalInfo> userSnapshot) {
          return userSnapshot.hasError
              ? Center(child: Text('Error interno'))
              : Scaffold(
                  appBar: AppBar(
                      actions: [
                        IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => _search())))
                      ],
                      backgroundColor: Colors.white,
                      centerTitle: true,
                      iconTheme: IconThemeData(color: Colors.black),
                      title: Text('Howdy',
                          style:
                              TextStyle(color: Theme.of(context).accentColor))),
                  body: _postList(),
                  drawer: _drawer(context),
                  floatingActionButton: FloatingActionButton(
                      child: Icon(Icons.post_add),
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => NewPost()))),
                );
        });
  }
}

Widget _drawer(BuildContext context) {
  return Drawer(
      child: Column(children: [
    UserAccountsDrawerHeader(
        currentAccountPicture: CircleAvatar(
          child: userPersonalInfo?.profilePic == ''
              ? Text(userPersonalInfo.name.substring(0, 1))
              : Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(userPersonalInfo?.profilePic ??
                              "https://cdn140.picsart.com/315324509038201.jpg?type=webp&to=min&r=640")))),
        ),
        accountName: Text('${userPersonalInfo?.name}'),
        accountEmail: Text('@${userPersonalInfo?.username}')),
    _listTile(
        context: context,
        icon: Icons.people_alt_outlined,
        text: 'Crear grupo',
        next: NewGroup()),
    _listTile(
        context: context,
        icon: Icons.group_outlined,
        text: 'Amigos y grupos',
        next: MyGroups()),
    _listTile(
        context: context,
        icon: Icons.message_outlined,
        text: 'Chats directos',
        next: _search()),
    _listTile(
        context: context,
        icon: Icons.search,
        text: 'Descubrir',
        next: _search()),
    _listTile(
        context: context,
        icon: Icons.edit_outlined,
        text: 'Editar perfil',
        next: UserDetailView(profileOwner: userPersonalInfo)),
    _listTile(
        context: context,
        icon: Icons.settings,
        text: "Configuración",
        next: UserDetailView(profileOwner: userPersonalInfo)),
    _listTile(context: context, icon: Icons.logout, text: "Cerrar sesión")
  ]));
}

Widget _listTile(
    {@required BuildContext context,
    @required IconData icon,
    @required String text,
    Widget next}) {
  return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(text),
      onTap: next != null
          ? () {
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => next));
            }
          : () => _auth.signOut());
}

Widget _search() {
  return StreamBuilder(
      stream: database.getUsers(),
      builder: (context, snapshot) {
        return Scaffold(
            appBar: AppBar(title: Text('Descubrir')),
            body: snapshot.hasData
                ? _usersList(context, snapshot.data.docs)
                : Center(child: Text('Cargando...')));
      });
}

Widget _postList() {
  return StreamBuilder(
      stream: database.getPosts(),
      builder: (context, snapshot) {
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
