import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String name, username, biography, profilePicUrl, phoneNumber, email;
  final bool private;
  final List interest, posts, friends, preferences;
  final String location;
  final DocumentReference reference;
  //  assert(map['name']!=null);
  User.fromMap(Map<String, dynamic> map, {this.reference})
      : name = map['name'],
        username = map['username'],
        biography = map['username'],
        profilePicUrl = map['username'],
        phoneNumber = map['username'],
        email = map['username'],
        private = map['username'],
        interest = map['username'],
        posts = map['username'],
        friends = map['username'],
        preferences = map['username'],
        location = map['username'];
  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
