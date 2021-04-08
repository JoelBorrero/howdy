import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                gradient: RadialGradient(colors: [
              Theme.of(context).primaryColorDark,
              Theme.of(context).primaryColorDark,
              Theme.of(context).primaryColor,
            ])),
            child: Stack(alignment: Alignment.center, children: <Widget>[
              SpinKitRing(
                  color: Theme.of(context).primaryColor,
                  lineWidth: 30,
                  size: MediaQuery.of(context).size.width / 2),
              Text('Howdy',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      letterSpacing: 3,
                      fontWeight: FontWeight.bold)),
              Padding(
                  padding: EdgeInsets.only(top: 250),
                  child: Text('Estamos preparando todo para ti...',
                      style: TextStyle(color: Colors.white, fontSize: 12)))
            ])));
  }
}
