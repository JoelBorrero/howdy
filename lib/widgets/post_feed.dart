import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:howdy/models/user_info.dart';
import 'package:howdy/screens/user_pages/user_profile.dart';
import 'package:howdy/services/database.dart';

class Post extends StatefulWidget {
  final DocumentSnapshot data;
  Post({this.data});

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  PersonalInfo _author;
  List _images;
  int _page = 1;

  void _loadAuthor() async {
    _author = await DatabaseService().getPersonalInfo(widget.data['author']);
    setState(() {});
  }

  void _showProfile(BuildContext context, String uid) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UserDetailView(profileOwner: _author)),
    );
  }

  @override
  Widget build(BuildContext context) {
    _images = widget.data['images'];
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
                    image: NetworkImage(_author.profilePic == ''
                        ? "https://cdn140.picsart.com/315324509038201.jpg?type=webp&to=min&r=640"
                        : _author.profilePic),
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
                          _showProfile(context, widget.data['author'])),
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
                child: widget.data['images'] == null
                    ? Text('Nulo')
                    : Stack(alignment: Alignment.topRight, children: [
                        Container(
                            alignment: Alignment.center,
                            height: 300,
                            width: 300,
                            child: PageView.builder(
                                itemBuilder: (context, i) => Image.network(
                                      _images[i],
                                      fit: BoxFit.cover,
                                    ),
                                itemCount: _images.length,
                                onPageChanged: (i) {
                                  setState(() {
                                    _page = i + 1;
                                  });
                                },
                                scrollDirection: Axis.horizontal)),
                        _images.isNotEmpty
                            ? Padding(
                                padding: EdgeInsets.all(10),
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Text(
                                      '  $_page/${_images.length}  ',
                                      style: TextStyle(color: Colors.white),
                                    )),
                              )
                            : Text(''),
                      ]))),

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
