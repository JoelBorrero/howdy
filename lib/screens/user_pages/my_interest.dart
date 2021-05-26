import 'package:flutter/material.dart';
import 'package:howdy/widgets/groups.dart';
import 'package:howdy/widgets/loading.dart';
import 'package:howdy/widgets/constants.dart';
import 'package:howdy/screens/user_pages/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyInterest extends StatefulWidget {
  @override
  _MyInterestState createState() => _MyInterestState();
}

class _MyInterestState extends State<MyInterest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(),
        body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                titleText(text: 'Populares', size: 32),
                TextButton(child: Text("Ver más"), onPressed: () {})
              ]),
              chipsList()
            ])));
  }
}

AppBar _appBar() => AppBar(
      title: Text('Match info'),
      actions: [TextButton(child: Text('Guardar'), onPressed: () async {})],
    );

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
