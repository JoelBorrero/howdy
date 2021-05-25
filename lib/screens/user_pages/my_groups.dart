import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:howdy/screens/user_pages/home.dart';
import 'package:howdy/widgets/groups.dart';
import 'package:howdy/widgets/loading.dart';

class MyGroups extends StatefulWidget {
  @override
  _MyGroupsState createState() => _MyGroupsState();
}

class _MyGroupsState extends State<MyGroups> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(), body: _groupsList());
  }
}

AppBar _appBar() => AppBar(title: Text('Grupos'));

Widget _groupsList() {
  return StreamBuilder(
      stream: database.groupsCollection.snapshots(),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? snapshot.data.docs.length > 0
                ? _theList(snapshot.data.docs)
                : Center(
                    child: Text(
                        'Aún no existen grupos, ¿Qué tal si creamos el primero?'))
            : Loading();
      });
}

Widget _theList(List<DocumentSnapshot> snapshot) => ListView(
    padding: EdgeInsets.all(20),
    children: snapshot.map((data) => GroupTile(data: data)).toList());
