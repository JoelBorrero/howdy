import 'package:howdy/widgets/constants.dart';

import 'sign_in.dart';
import 'register.dart';
import 'package:flutter/material.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

PageController _verticalController = PageController(),
    _horizontalController = PageController();
void goToPage(int page, {bool horizontal = true}) {
  (horizontal ? _horizontalController : _verticalController).animateToPage(page,
      duration: Duration(milliseconds: 800), curve: Curves.fastOutSlowIn);
}

class _AuthenticationState extends State<Authentication> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
      controller: _verticalController,
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      children: [
        PageView(controller: _horizontalController, children: [
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              padding: EdgeInsets.only(top: 30),
              alignment: Alignment.bottomRight,
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                TextButton(child: Text('Saltar'), onPressed: () => goToPage(2)),
                IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () => goToPage(2))
              ]),
            ),
            Text('1',
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 100)),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              TextButton(
                  child: Text('Siguiente'), onPressed: () => goToPage(1)),
              IconButton(
                  icon: Icon(Icons.arrow_forward_ios),
                  onPressed: () => goToPage(1))
            ])
          ]),
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(),
            Text('2',
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 100)),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: [
                IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () => goToPage(0)),
                TextButton(
                    child: Text('Anterior'), onPressed: () => goToPage(0))
              ]),
              Row(children: [
                TextButton(
                    child: Text('Siguiente'), onPressed: () => goToPage(2)),
                IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () => goToPage(2))
              ]),
            ])
          ]),
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('Howdy',
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 72)),
            Text('Encuentra a miles de personas.\nConecta con ellas',
                style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
            bigButton(
                context: context,
                onPressed: () => goToPage(2, horizontal: false),
                text: 'Crear una cuenta'),
            bigButton(
                context: context,
                color: Colors.grey[200],
                onPressed: () => goToPage(1, horizontal: false),
                text: 'Ya tengo una cuenta',
                textColor: Colors.black54),
          ])
        ]),
        SignIn(),
        Register()
      ],
    ));
  }
}
