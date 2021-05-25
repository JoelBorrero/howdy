import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:howdy/screens/user_pages/home.dart';
import 'constants.dart';

class GroupTile extends StatelessWidget {
  final DocumentSnapshot data;
  GroupTile({this.data});
  Color _color = randomColor();
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: CircleAvatar(
          backgroundColor: _color,
          child: Text(data["name"][0].toUpperCase(),
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
      subtitle: Text("@${data["tagname"]}"),
      title: Text(data["name"]),
      children: [
        Text(data["description"]),
        Text("${data["members"].length} miembros"),
        Text("Intereses:"),
        ElevatedButton.icon(
            onPressed: () => database.joinOrLeaveGroup(data),
            icon: Icon(data["members"].contains(firebaseUser.uid)
                ? Icons.person_remove
                : Icons.person_add),
            label: Text(data["members"].contains(firebaseUser.uid)
                ? 'Abandonar'
                : 'Unirme'),
            style: ElevatedButton.styleFrom(
                primary: _color,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50))))
      ],

      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
