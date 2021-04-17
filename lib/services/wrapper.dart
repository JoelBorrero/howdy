import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:howdy/models/user.dart';
import 'package:howdy/screens/user_pages/home.dart';
import 'package:howdy/screens/authentication/authentication.dart';

User user;

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    return user == null ? Authentication() : Home();
  }
}
