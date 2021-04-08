import 'package:flutter/material.dart';
import 'package:howdy/models/user.dart';
import 'package:howdy/services/database.dart';
import 'package:provider/provider.dart';
import 'package:howdy/screens/authentication/authentication.dart';

import 'auth.dart';

User user;
PersonalInfo _userInfo = PersonalInfo(name: 'Name', username: 'Username');
_loadInfo() async {
  _userInfo = await DatabaseService(uid: user.uid).personalInfo.last;
}

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    _loadInfo();
    if (user == null) {
      return Authentication();
    } else {
      return Scaffold(
          appBar: AppBar(title: Text('Howdy'), centerTitle: true),
          body: Column(
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
                                borderRadius: BorderRadius.circular(50))))),
              )
            ],
          ));
    }
  }
}
