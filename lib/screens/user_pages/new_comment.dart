import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:howdy/widgets/constants.dart';

class NewComment extends StatefulWidget {
  final DocumentSnapshot post;

  const NewComment({this.post});
  @override
  _NewCommentState createState() => _NewCommentState();
}

class _NewCommentState extends State<NewComment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Comentar')),
        body: SingleChildScrollView(
            child: widget.post['comments'].length > 0
                ? ListView.builder(
                    itemBuilder: (context, index) =>
                        Text(widget.post['comments'][index]))
                : Text('No comments')),
        bottomNavigationBar: Row(children: [
          SizedBox(width: 30),
          Flexible(
            child: TextField(
                decoration: textInputDecoration.copyWith(
                    labelText: 'Escribe un comentario...')),
          ),
          IconButton(icon: Icon(Icons.send), onPressed: () {}),
          SizedBox(width: 30)
        ]));
  }
}
