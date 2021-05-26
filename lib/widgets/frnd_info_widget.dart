import 'package:flutter/material.dart';

import 'constants.dart';

class UserFrndInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(children: [
      // Divider(
      //   height: 40,
      //   thickness: 1,
      //   indent: 20,
      //   endIndent: 20,
      // ),
      Center(
          child: Container(
              //color: Color(0xffe4e4e4),
              child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          titleText(text: "Amigos: "),
          Text("1789", style: TextStyle(fontSize: 18))
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          titleText(text: "Posts totales: "),
          Text("104", style: TextStyle(fontSize: 18))
        ])
      ]))),
      Divider(height: 40, thickness: 1, indent: 20, endIndent: 20)
    ]));
  }
}
