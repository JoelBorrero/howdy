import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:howdy/models/user_info.dart';
import 'package:howdy/screens/user_pages/home.dart';

InputDecoration textInputDecoration = InputDecoration(
    enabledBorder:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color.fromRGBO(103, 15, 128, 1))));

Widget titleText({@required String text, double size}) => Text(text,
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: size ?? 18));

Widget bigButton(
    {String text,
    Color color,
    Color textColor,
    @required BuildContext context,
    @required Function onPressed}) {
  return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      child: ElevatedButton(
          onPressed: onPressed,
          child: Text('\n${text ?? ""}\n',
              style: TextStyle(color: textColor ?? Colors.white)),
          style: ElevatedButton.styleFrom(
              primary: color,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)))));
}

Widget whiteAppBar({@required String text}) {
  return AppBar(
      backgroundColor: Colors.white,
      title: Text(text, style: TextStyle(color: Colors.black)),
      iconTheme: IconThemeData(color: Colors.black));
}

///El parámetro `param` puede ser el `uid` del perfil visitado o puede ser una `lista` para crear el nuevo grupo
Widget chipsList({param}) => StreamBuilder<QuerySnapshot>(
    stream: database.getTags(),
    builder: (context, snapshot) {
      return snapshot.hasData
          ? param is String
              ? StreamBuilder<DocumentSnapshot>(
                  stream: database.getUserStream(param),
                  builder:
                      (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                    print(userSnapshot.data["interest"]);
                    return userSnapshot.hasError
                        ? Center(child: Text('Error interno'))
                        : Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: snapshot.data.docs
                                .where((tag) => userSnapshot.data["interest"]
                                    .contains(tag.id))
                                .map((i) => getChip(i))
                                .toList());
                  },
                )
              : Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: snapshot.data.docs
                      .map((i) => getChip(i, list: param))
                      .toList())
          : Text('Vacío');
    });

Widget getChip(DocumentSnapshot chip, {List list}) {
  bool _watching = false;
  if (list == null) {
    list = [chip.id];
    _watching = true;
  }
  bool _selected = list.contains(chip.id);
  return InputChip(
      onPressed: () {
        // if (_watching) database.toggleTag(chip.id);
        list.contains(chip.id) ? list.remove(chip.id) : list.add(chip.id);
        _selected = list.contains(chip.id);
        print(list);
      },
      selected: _selected,
      selectedColor: Color(0xff9097fd),
      padding: EdgeInsets.all(12),
      labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      label: Text(chip["name"]));
}
