import 'package:cloud_firestore/cloud_firestore.dart';

class PersonalInfo {
  final String name, username, biography, profilePicUrl, phoneNumber, email;
  final bool private;
  final List interest, posts, friends, preferences;
  final GeoPoint location;
  final DocumentReference reference;
  //  assert(map['name']!=null);
  PersonalInfo.fromMap(Map<String, dynamic> map, {this.reference})
      : name = map['name'],
        username = map['username'],
        biography = map['biography'],
        profilePicUrl = map['profilePicUrl'],
        phoneNumber = map['phoneNumber'],
        email = map['email'],
        private = map['private'],
        interest = map['interest'],
        posts = map['posts'],
        friends = map['friends'],
        preferences = map['preferences'],
        location = map['location'];
  PersonalInfo.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
