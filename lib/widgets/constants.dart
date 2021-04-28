import 'package:flutter/material.dart';

InputDecoration textInputDecoration = InputDecoration(
    enabledBorder:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color.fromRGBO(103, 15, 128, 1))));

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
