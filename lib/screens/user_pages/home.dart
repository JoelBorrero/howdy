import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:howdy/models/user.dart';
import 'package:howdy/services/auth.dart';
import 'package:howdy/services/database.dart';
import 'package:howdy/services/wrapper.dart';
import 'package:howdy/shared/constants.dart';
import 'package:image_picker/image_picker.dart';

import 'widgets.dart';

PersonalInfo _userInfo = PersonalInfo(name: 'Name', username: 'Username');
PageController _mainController = PageController();
TextEditingController _footerController = TextEditingController();
int _page = 1;
DatabaseService _db = DatabaseService(uid: user.uid);

_loadInfo() async {
  _userInfo = await _db.personalInfo.first;
}
Future _setImage(ImageSource source) async {
      final image = await ImagePicker().getImage(source: source);
      if (image != null) {
        StorageReference storageReference =
            FirebaseStorage.instance.ref().child('users/${user.uid}/profilePic.jpeg');
        StorageUploadTask uploadTask =
            storageReference.putFile(File(image.path));
        await uploadTask.onComplete;
        Firestore.instance.collection('userData').document(user.uid).setData({
          'profilePicUrl': (await storageReference.getDownloadURL()).toString()
        }, merge: true);
      }
    }

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    _loadInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Howdy'), centerTitle: true),
      body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _mainController,
          children: [
            Text('Search'),
            ListView.builder(
                itemCount: 6,
                itemBuilder: (BuildContext context, int index) {
                  return Post();
                }),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(_userInfo.name, style: TextStyle(fontSize: 20)),
                  Text('${_userInfo.username}\n\n' ?? 'Usuario',
                      style: TextStyle(fontSize: 20)),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          child: ElevatedButton.icon(
                              onPressed: () => AuthService().signOut(),
                              label: Text('\nCerrar sesión\n'),
                              icon: Icon(Icons.logout),
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(50))))))
                ])
          ]),
      bottomNavigationBar: CurvedNavigationBar(
        index: 1,
        color: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).canvasColor,
        height: 50,
        items: [
          Icon(Icons.search, color: Colors.white),
          Icon(Icons.home, color: Colors.white),
          Icon(Icons.person, color: Colors.white)
        ],
        onTap: (i) {
          setState(() {
            _page = i;
            _mainController.animateToPage(i,
                duration: Duration(milliseconds: 800),
                curve: Curves.fastOutSlowIn);
          });
        },
      ),
      floatingActionButton: _page == 1
          ? FloatingActionButton(
              child: Icon(Icons.post_add),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (_) => Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Nuevo post',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 20),
                              ),
                              IconButton(
                                  icon: Icon(Icons.image), onPressed: () =>_setImage(ImageSource.gallery)),
                              IconButton(
                                  icon: Icon(Icons.camera), onPressed: () =>_setImage(ImageSource.camera)),
                              TextField(
                                  controller: _footerController,
                                  decoration: textInputDecoration.copyWith(
                                      labelText: 'Añade un pie de foto')),
                              ElevatedButton(
                                  child: Text('Publicar'),
                                  onPressed: () {
                                    _db.addNewPost(_footerController.text);
                                  })
                            ]));
              })
          : null,
    );
  }
}
