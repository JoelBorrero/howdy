import 'dart:io';
import 'package:flutter/material.dart';
import 'package:howdy/shared/functions.dart';
import 'package:howdy/widgets/constants.dart';
import 'package:image_picker/image_picker.dart';

import 'home.dart';

class NewPost extends StatefulWidget {
  @override
  _NewPostState createState() => _NewPostState();
}

int _page = 1;
List<File> _images = [];
TextEditingController _footerController = TextEditingController();

class _NewPostState extends State<NewPost> {
  @override
  void initState() {
    super.initState();
    _images.clear();
    _page = 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Nuevo post',
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.black)),
      body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Stack(alignment: Alignment.topRight, children: [
                  Container(
                      alignment: Alignment.center,
                      height: 300,
                      width: 300,
                      child: PageView.builder(
                          itemBuilder: (context, i) => Image.file(
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
                                  borderRadius: BorderRadius.circular(20)),
                              child: Text(
                                '  $_page/${_images.length}  ',
                                style: TextStyle(color: Colors.white),
                              )),
                        )
                      : Text(''),
                ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          icon: Icon(Icons.image),
                          onPressed: () async {
                            await chooseImage(ImageSource.gallery,
                                images: _images);
                            setState(() {});
                          }),
                      IconButton(
                          icon: Icon(Icons.camera),
                          onPressed: () =>
                              chooseImage(ImageSource.camera, images: _images)),
                    ]),
                TextField(
                    controller: _footerController,
                    decoration: textInputDecoration.copyWith(
                        labelText: 'Añade un pie de foto')),
                ElevatedButton(
                    child: Text('Publicar'),
                    onPressed: () {
                      db.addNewPost(_images, _footerController.text);
                      Navigator.pop(context);
                      _footerController.clear();
                    })
              ])),
    );
  }
}
