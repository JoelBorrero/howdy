import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:howdy/services/auth.dart';
import 'package:howdy/services/database.dart';
import 'package:howdy/widgets/constants.dart';
import 'package:howdy/widgets/post_feed.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:howdy/screens/user_pages/user_detail_new.dart';

PageController _mainController = PageController();
TextEditingController _footerController = TextEditingController();
int _page = 1;
// DatabaseService _db = DatabaseService(uid: user.uid);

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
          controller: _mainController,
          children: [
            TextButton(
                child: Text('Search'),
                onPressed: null), //() => print(Provider.of<User>(context))),
            ListView.builder(
                itemCount: 6,
                itemBuilder: (BuildContext context, int index) {
                  return Post();
                }),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('_userInfo.name', style: TextStyle(fontSize: 20)),
                  Text('{_userInfo.username}\n\n' ?? 'Usuario',
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Nuevo post',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 20),
                              ),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                        icon: Icon(Icons.image),
                                        onPressed: null),
                                    IconButton(
                                        icon: Icon(Icons.camera),
                                        onPressed: null)
                                  ]),
                              TextField(
                                  controller: _footerController,
                                  decoration: textInputDecoration.copyWith(
                                      labelText: 'Añade un pie de foto')),
                              ElevatedButton(
                                  child: Text('Publicar'),
                                  onPressed: () {
                                    // _db.addNewPost(_footerController.text);
                                  })
                            ]));
              })
          : null,
    );
  }
}
