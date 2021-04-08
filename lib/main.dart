import 'models/user.dart';
import 'services/auth.dart';
import 'services/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
        value: AuthService().user,
        child: MaterialApp(
            title: 'Howdy',
            theme: ThemeData(primarySwatch: Colors.deepPurple),
            home: Wrapper(),
            debugShowCheckedModeBanner: false));
  }
}
