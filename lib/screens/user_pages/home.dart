import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:howdy/services/auth.dart';
import 'package:howdy/services/database.dart';
import 'package:howdy/widgets/constants.dart';
import 'package:howdy/widgets/post_feed.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

PageController _pageController = PageController(initialPage: 1);
TextEditingController _footerController = TextEditingController();
User _user = FirebaseAuth.instance.currentUser;
DatabaseService _db = DatabaseService(uid: _user.uid);
int _page = 0;

void _goToPage(int i) {
  _pageController.animateToPage(i,
      duration: Duration(milliseconds: 800), curve: Curves.fastOutSlowIn);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Howdy'), centerTitle: true),
        body: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: [
              TextButton(child: Text('Search'), onPressed: () {}),
              _postList(),
              _userProfile(context)
            ]),
        bottomNavigationBar: CurvedNavigationBar(
          index: 1,
          color: Theme.of(context).primaryColor,
          backgroundColor: Colors.transparent,
          // backgroundColor: Theme.of(context).canvasColor,
          height: 50,
          items: [
            Icon(Icons.search, color: Colors.white),
            Icon(Icons.home, color: Colors.white),
            Icon(Icons.person, color: Colors.white)
          ],
          onTap: (i) {
            setState(() {
              _page = i;
              _goToPage(i);
            });
          },
        ),
        extendBody: true,
        floatingActionButton: _page == 1 //
            ? _newPostButton(context)
            : null,
        resizeToAvoidBottomInset: false);
  }
}

Widget _postList() {
  return StreamBuilder(
      stream: _db.postsCollection.snapshots(),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? _list(context, snapshot.data.docs)
            : Text('Cargando...');
      });
}

Widget _userProfile(BuildContext context) {
  return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('${_user.displayName}', style: TextStyle(fontSize: 20)),
        Text('${_user.email}\n\n', style: TextStyle(fontSize: 20)),
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
                            borderRadius: BorderRadius.circular(50))))))
      ]);
}

Widget _list(BuildContext context, List<DocumentSnapshot> snapshot) {
  return ListView(children: snapshot.map((data) => Post(data: data)).toList());
}

FloatingActionButton _newPostButton(BuildContext context) =>
    FloatingActionButton(
        child: Icon(Icons.post_add),
        onPressed: () {
          showModalBottomSheet(
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(50))),
              context: context,
              builder: (_) => SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Nuevo post\n\n',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                    icon: Icon(Icons.image), onPressed: null),
                                IconButton(
                                    icon: Icon(Icons.camera), onPressed: null)
                              ]),
                          TextField(
                              controller: _footerController,
                              decoration: textInputDecoration.copyWith(
                                  labelText: 'Añade un pie de foto')),
                          ElevatedButton(
                              child: Text('Publicar'),
                              onPressed: () {
                                _db.addNewPost(_footerController.text);
                                Navigator.pop(context);
                                _footerController.clear();
                              })
                        ]),
                  ));
        });
