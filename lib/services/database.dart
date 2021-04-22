import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});
  //Collection reference
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future createUser(String name, String username, List location) async {
    return await usersCollection.doc(uid).set(
      {
        'name': name,
        'username': username,
        'biography': 'Hola! Soy nuevo en Howdy',
        'friends': [],
        'interest': [],
        'location': GeoPoint(location[0], location[1]),
        'phoneNumber': '',
        'posts': [],
        'preferences': [],
        'private': false,
        'profilePicUrl': '',
        uid: uid,
      },
    );
  }

  //POST
  Future addNewPost(String footer) async {
    return await usersCollection
        .doc(uid)
        .collection('posts')
        .doc()
        .set({'footer': footer});
  }
}
