import 'package:flutter/material.dart';
import 'package:howdy/models/user_info.dart';
import 'package:howdy/screens/user_pages/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:howdy/screens/user_pages/new_comment.dart';
import 'package:howdy/screens/user_pages/user_profile.dart';

class Post extends StatefulWidget {
  final DocumentSnapshot data;
  Post({this.data});

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  int _page = 1;

  void _showProfile(BuildContext context, PersonalInfo user) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UserDetailView(profileOwner: user)),
    );
  }

  void _newComment(BuildContext context, DocumentSnapshot data) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewComment(post: data)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PersonalInfo>(
        future: database.getPersonalInfo(widget.data["author"]),
        builder: (context, AsyncSnapshot<PersonalInfo> _author) {
          List _images = widget.data['images'];
          return Column(children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(16),
                child: Row(children: <Widget>[
                  _author.data.profilePic.isEmpty
                      ? CircleAvatar(child: Icon(Icons.person_outline))
                      : CircleAvatar(
                          backgroundImage:
                              NetworkImage(_author.data.profilePic)),
                  Column(children: <Widget>[
                    TextButton(
                        child: Text(
                          "${_author.data.name}",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () => _showProfile(context, _author.data)),
                    Text("@${_author.data.username}")
                  ]),
                  Spacer(),
                  TextButton(
                      onPressed: () async {
                        await database.follow(widget.data["author"]);
                        setState(() {
                          userPersonalInfo.friends
                                  .contains(widget.data["author"])
                              ? userPersonalInfo.friends
                                  .remove(widget.data["author"])
                              : userPersonalInfo.friends
                                  .add(widget.data["author"]);
                        });
                      },
                      child: Text(
                          userPersonalInfo.friends
                                  .contains(widget.data["author"])
                              ? "Siguiendo"
                              : "Seguir",
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.bold)))
                ])),
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
                        : Container(
                            height: MediaQuery.of(context).size.width - 20,
                            width: MediaQuery.of(context).size.width - 20,
                            child:
                                Stack(alignment: Alignment.topRight, children: [
                              PageView.builder(
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
                                  scrollDirection: Axis.horizontal),
                              _images.isNotEmpty
                                  ? Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Container(
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Text(
                                            '  $_page/${_images.length}  ',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                    )
                                  : Text('')
                            ])))),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Row(children: <Widget>[
                  IconButton(
                      onPressed: () async =>
                          await database.likePost(widget.data),
                      icon: Icon(
                          widget.data['likes'].contains(firebaseUser.uid)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Theme.of(context).accentColor,
                          size: 25)),
                  IconButton(
                      onPressed: () => _newComment(context, widget.data),
                      icon: Icon(Icons.messenger_outline,
                          color: Theme.of(context).accentColor, size: 25)),
                  Spacer(),
                  Text('${widget.data["likes"].length} Me gusta')
                ])),
            TextButton(
                child: Text(
                    widget.data["comments"].length > 0
                        ? 'Ver todos los ${widget.data["comments"].length} comentarios'
                        : 'Agregar un comentario...',
                    style: TextStyle(color: Colors.grey)),
                onPressed: () => _newComment(context, widget.data)),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: RichText(
                    text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                      TextSpan(
                          text: "@${_author.data.username} ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: widget.data['footer'])
                    ]))),
            const Divider(height: 40, thickness: 1, indent: 20, endIndent: 20)
          ]);
        });
  }
}
