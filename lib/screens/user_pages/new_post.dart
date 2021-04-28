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
String _error = '';
List<File> _images = [];
TextEditingController _footerController = TextEditingController();

class _NewPostState extends State<NewPost> {
  @override
  void initState() {
    super.initState();
    _page = 1;
    _error = '';
    _images.clear();
    _footerController.clear();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
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
                  _images.isNotEmpty
                      ? Stack(alignment: Alignment.topRight, children: [
                          Container(
                              alignment: Alignment.center,
                              height: _size.width - 50,
                              width: _size.width - 50,
                              child: PageView.builder(
                                  itemBuilder: (context, i) =>
                                      Image.file(_images[i], fit: BoxFit.cover),
                                  itemCount: _images.length,
                                  onPageChanged: (i) {
                                    setState(() {
                                      _page = i + 1;
                                    });
                                  },
                                  scrollDirection: Axis.horizontal)),
                          Padding(
                              padding: EdgeInsets.all(10),
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Text('  $_page/${_images.length}  ',
                                      style: TextStyle(color: Colors.white)))),
                        ])
                      : Container(
                          alignment: Alignment.center,
                          child: Icon(Icons.collections_outlined, size: 200),
                          color: Colors.grey[200],
                          height: _size.width - 50,
                          width: _size.width - 50),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            icon: Icon(Icons.image),
                            onPressed: () async {
                              await chooseImage(context, ImageSource.gallery,
                                  images: _images);
                              setState(() {});
                            }),
                        IconButton(
                            icon: Icon(Icons.camera),
                            onPressed: () async {
                              await chooseImage(context, ImageSource.camera,
                                  images: _images);
                            })
                      ]),
                  TextField(
                      controller: _footerController,
                      decoration: textInputDecoration.copyWith(
                          labelText: 'Añade un pie de foto')),
                  Text(_error,
                      style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.center),
                  bigButton(
                      context: context,
                      text: 'Publicar',
                      onPressed: () {
                        if (_images.isNotEmpty) {
                          if (_footerController.text.isNotEmpty) {
                            db.addNewPost(_images, _footerController.text);
                            Navigator.pop(context);
                            _footerController.clear();
                          } else {
                            setState(() {
                              _error = 'Oops! Olvidaste escribir algo';
                            });
                          }
                        } else {
                          setState(() {
                            _error = 'Oops!\nOlvidaste cargar algo';
                          });
                        }
                      })
                ])));
  }
}
