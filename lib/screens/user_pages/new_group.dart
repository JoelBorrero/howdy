import 'package:flutter/material.dart';
import 'package:howdy/widgets/constants.dart';
import 'package:howdy/screens/user_pages/home.dart';
import 'package:howdy/widgets/interest_widget.dart';
import 'package:howdy/widgets/loading.dart';

import 'my_groups.dart';

TextEditingController _name = TextEditingController(),
    _tag = TextEditingController(),
    _description = TextEditingController();
final _formKey = GlobalKey<FormState>();
String error = '';
bool _loading = false;

class NewGroup extends StatefulWidget {
  @override
  NewGroupState createState() => NewGroupState();
}

class NewGroupState extends State<NewGroup> {
  @override
  Widget build(BuildContext context) {
    return _loading
        ? Loading()
        : Scaffold(
            appBar: _appBar(),
            body: Padding(
                padding: EdgeInsets.all(20),
                child: Form(
                    key: _formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextFormField(
                              controller: _name,
                              validator: (val) => val.isEmpty
                                  ? 'Ingrese un nombre para el grupo'
                                  : null,
                              decoration: textInputDecoration.copyWith(
                                  labelText: 'Nombre de grupo')),
                          TextFormField(
                              controller: _tag,
                              validator: (val) => val.isEmpty
                                  ? 'Ingrese un tag para el grupo'
                                  : null,
                              decoration: textInputDecoration.copyWith(
                                  labelText: '@tag de grupo')),
                          Text(error, style: TextStyle(color: Colors.red)),
                          Row(children: [titleText(text: "Descripción")]),
                          TextField(
                              controller: _description,
                              decoration: textInputDecoration.copyWith(
                                  labelText: 'Descripción para el grupo')),
                          Row(children: [
                            titleText(text: "Match Info"),
                            TextButton(onPressed: () {}, child: Text('editar'))
                          ]),
                          UserInterestWidget()
                        ]))));
  }

  AppBar _appBar() => AppBar(title: Text('Crear grupo'), actions: [
        TextButton(
            child: Text('Guardar'),
            onPressed: () async {
              setState(() {
                _loading = true;
              });
              if (_formKey.currentState.validate()) {
                bool ans = await database.createGroup(
                    _name.text, _tag.text, _description.text);
                setState(() {
                  _loading = false;
                  if (ans) {
                    error = '';
                    _name.clear();
                    _tag.clear();
                    _description.clear();
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyGroups()));
                  } else {
                    error = 'El tagname ya existe';
                  }
                });
              }
            })
      ]);
}
