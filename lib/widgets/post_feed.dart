import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:howdy/models/user_info.dart';
import 'package:howdy/screens/user_detail_new.dart';
import 'package:howdy/services/database.dart';

class Post extends StatefulWidget {
  final DocumentSnapshot data;
  Post({this.data});

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  PersonalInfo _author;

  void _loadAuthor() async {
    _author = await DatabaseService().getPersonalInfo(widget.data['author']);
    setState(() {});
  }

  void showProfile(BuildContext context, String uid) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserDetailView(author: _author)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_author == null) _loadAuthor();
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
                  TextButton(
                      child: Text(
                        "${_author?.name}",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () =>
                          showProfile(context, widget.data['author'])),
                  Text("@${_author?.username}"),
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
                  text: "@${_author?.username} ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: widget.data['footer']),
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
