import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:howdy/models/user_info.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});
  //Collection reference
  final CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users'),
      postsCollection = FirebaseFirestore.instance.collection('posts');

  Future createUser(
      String name, String username, String phone, List location) async {
    return await usersCollection.doc(uid).set(
      {
        'name': name,
        'username': username,
        'biography': 'Hola! Soy nuevo en Howdy',
        'friends': [],
        'interest': [],
        'location': GeoPoint(location[0], location[1]),
        'phoneNumber': phone,
        'posts': [],
        'preferences': [],
        'private': false,
        'profilePicUrl': ''
      },
    );
  }

  //POST
  Future addNewPost(String footer) async {
    return await postsCollection.doc().set({'author': uid, 'footer': footer});
  }

  Future<PersonalInfo> getPersonalInfo(String id) async {
    return PersonalInfo.fromSnapshot(await usersCollection.doc(id).get());
  }
}
