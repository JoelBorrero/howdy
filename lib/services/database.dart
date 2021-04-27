import 'dart:io';
import 'package:howdy/models/user_info.dart';
import 'package:howdy/shared/functions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

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
        'profilePic': ''
      },
    );
  }

  //POST
  Future addNewPost(List<File> images, String footer) async {
    List _paths = [];
    await uploadImages(images, _paths);
    return await postsCollection
        .doc()
        .set({'author': uid, 'images': _paths, 'footer': footer});
  }

  Future uploadImages(List<File> images, List paths) async {
    print('${images.length} imagenes');
    firebase_storage.Reference ref;
    for (var img in images) {
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${img.path}');
      await ref
          .putFile(img)
          .whenComplete(() async => await ref.getDownloadURL().then((value) {
                paths.add(value);
                print(value);
              }));
    }
  }

  Future setProfilePic(ImageSource source) async {
    PickedFile _image = await chooseImage(source);
    List _path = [];
    await uploadImages([File(_image.path)], _path);
    return await usersCollection.doc(uid).update({'profilePic': _path.first});
  }

  Future<PersonalInfo> getPersonalInfo(String id) async {
    return PersonalInfo.fromSnapshot(await usersCollection.doc(id).get());
  }
}
