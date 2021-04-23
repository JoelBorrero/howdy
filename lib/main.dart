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
        title: 'Howdy',
        theme: ThemeData(
            primaryColor: Colors.deepPurple, primarySwatch: Colors.purple),
        home: FutureBuilder(
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
                    ],
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return Wrapper();
              }
              return Loading();
            }),
        debugShowCheckedModeBanner: false);
  }
}
