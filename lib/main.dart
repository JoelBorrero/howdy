import 'services/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'widgets/loading.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: _darkTheme(),
      debugShowCheckedModeBanner: false,
      home: _home(),
      title: 'Howdy',
      theme: _normalTheme(),
    );
  }

  Widget _home() => FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
              body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                Icon(Icons.error_outline, size: 50),
                Text('\nOops, lo sentimos\n\nParece que hubo un error')
              ]));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Wrapper();
        }
        return Loading();
      });
}

ThemeData _darkTheme() => ThemeData(
    accentColor: Color(0xff9097fd),
    cardColor: Colors.deepPurple,
    primaryColor: Colors.deepPurple,
    canvasColor: Colors.black54,
    textTheme: TextTheme(
        button: TextStyle(color: Colors.amber),
        bodyText1: TextStyle(color: Colors.white60),
        bodyText2: TextStyle(color: Colors.white70)),
    primarySwatch: Colors.purple,
    scaffoldBackgroundColor: Colors.black87);

ThemeData _normalTheme() => ThemeData(
    appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        textTheme: TextTheme(
            headline6: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w500)),
        iconTheme: IconThemeData(color: Colors.black)),
    accentColor: Color(0xff9097fd),
    cardColor: Color(0xff9097fd),
    primaryColor: Colors.deepPurple,
    primarySwatch: Colors.purple);
