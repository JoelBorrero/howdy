import 'package:flutter/material.dart';

var tags = [
  "love",
  "music",
  "happy",
  "selfie",
  "computacion",
  "naturaleza"
  "vacaciones",
];

var selectedTags = ["computacion", "naturaleza", "vacaciones"];

class UserInterestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: <Widget>[
          getChip("Música"),
          getChip("Figma"),
          getChip("VSCO"),
          getChip("Video Juegos"),
          getChip("Flutter"),
          getChip("Tecnología"),
          getChip("Programación"),
        ],
      ),
    );
  }
}

// generateTags(){
//   return tags.map((tap) => getChip(tap)).toList;
// }

getChip(name){
  return Chip(
    padding: EdgeInsets.all(12),
    //selected: true,//selectedTags.contains(name),
    //selectedColor: Color(0xff9097fd),
    //disabledColor: Colors.blue.shade400,
    backgroundColor: Color(0xff9097fd),
    labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    label: Text("$name"), 
    //onSelected: (bool value) { print("$name seleccionado"); },
  );
}
