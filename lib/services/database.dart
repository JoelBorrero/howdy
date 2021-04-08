import 'package:howdy/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});
  //Collection reference
  final CollectionReference usersCollection =
      Firestore.instance.collection('users');

  Future updateUserData(String name, String username) async {
    return await usersCollection
        .document(uid)
        .setData({'name': name, 'username': username}, merge: true);
  }

  //PersonalInfo from snapshot
  PersonalInfo _personalInfoFromSnapshot(DocumentSnapshot snapshot) {
    return PersonalInfo(
        uid: uid,
        name: snapshot.data['name'],
        username: snapshot.data['username']);
  }

  //Get user doc stream
  Stream<PersonalInfo> get personalInfo {
    return usersCollection
        .document(uid)
        .snapshots()
        .map(_personalInfoFromSnapshot);
  }
}
