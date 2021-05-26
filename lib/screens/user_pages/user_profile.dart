import 'home.dart';
import 'my_interest.dart';
import 'package:flutter/material.dart';
import 'package:howdy/models/user_info.dart';
import 'package:howdy/widgets/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:howdy/widgets/frnd_info_widget.dart';
import 'package:howdy/widgets/little_post_widget.dart';

bool _myProfile = false;

class UserDetailView extends StatefulWidget {
  final PersonalInfo profileOwner;
  UserDetailView({this.profileOwner});

  @override
  _UserDetailViewState createState() => _UserDetailViewState();
}

class _UserDetailViewState extends State<UserDetailView> {
  @override
  Widget build(BuildContext context) {
    _myProfile = firebaseUser.uid == widget.profileOwner.reference.id;
    return Scaffold(
        body: CustomScrollView(slivers: <Widget>[
      SliverAppBar(
          textTheme: TextTheme(
              headline6: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500)),
          leading: (IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context))),
          actions: [_myProfile ? Text('') : _followButton()],
          backgroundColor: Color(0xffc4c7ce),
          pinned: true,
          expandedHeight: MediaQuery.of(context).size.width,
          title: Text('@${widget.profileOwner.username}'),
          flexibleSpace: FlexibleSpaceBar(
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
                                  await database.setProfilePic(
                                      context, ImageSource.gallery);
                                  setState(() {});
                                }))
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
                  Row(children: [
                    titleText(text: "Biografía"),
                    _myProfile
                        ? _textButton(text: 'editar', onPressed: () {})
                        : Text('')
                  ]),
                  Align(
                      child: Text(widget.profileOwner.biography),
                      alignment: Alignment.bottomLeft),
                  SizedBox(height: 16),
                  Row(children: [
                    titleText(text: "Match Info"),
                    _textButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyInterest()));
                        },
                        text: 'editar'),
                  ]),
                  chipsList(param: widget.profileOwner.reference.id),
                  SizedBox(height: 16),
                  Row(children: [titleText(text: "Post info")]),
                  Wrap(children: [
                    LittlePostRectangleWidget(),
                    LittlePostRectangleWidget(),
                    LittlePostRectangleWidget(),
                    LittlePostRectangleWidget(),
                    LittlePostRectangleWidget(),
                    LittlePostRectangleWidget(),
                    LittlePostRectangleWidget(),
                    LittlePostRectangleWidget(),
                  ]),
                  Divider(height: 40, thickness: 1, indent: 20, endIndent: 20)
                ]))
      ]))
    ]));
  }

  Widget _followButton() => Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextButton(
          onPressed: () => print(
              '_myProfile\n${FirebaseAuth.instance.currentUser.uid} == ${widget.profileOwner.reference.id}'),
          child: Text("Seguir",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          style: TextButton.styleFrom(
              primary: Colors.blue,
              backgroundColor: Color(0xff9097fd),
              onSurface: Colors.red)));

  Widget _textButton({String text, Function() onPressed}) => TextButton(
      onPressed: onPressed,
      child: Text(text, style: TextStyle(color: Color(0xff9097fd))));
}
