import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:howdy/models/user_info.dart';
import 'package:howdy/screens/user_detail_new.dart';

class UserCard extends StatefulWidget {
  final DocumentSnapshot data;
  UserCard({this.data});
  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
          leading: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                          "https://cdn140.picsart.com/315324509038201.jpg?type=webp&to=min&r=640")))),
          title: Text(widget.data['name']),
          subtitle: Text('@${widget.data['username']}'),
          trailing: Icon(Icons.person_add),
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UserDetailView(
                      author: PersonalInfo.fromSnapshot(widget.data)))))
    ]);
  }
}
