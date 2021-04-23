import 'package:flutter/material.dart';

class LittlePostRectangleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 90,
        width: 90,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          image: DecorationImage(
            fit: BoxFit.fill,
            image: NetworkImage("https://cdn140.picsart.com/315324509038201.jpg?type=webp&to=min&r=640"),
          ),
        ),
      ),
    );
  }
}