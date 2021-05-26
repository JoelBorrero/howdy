import 'dart:io';
import 'package:flutter/material.dart';
import 'package:howdy/models/user_info.dart';
import 'package:howdy/shared/functions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});
  //Collection references
  final CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users'),
      postsCollection = FirebaseFirestore.instance.collection('posts'),
      groupsCollection = FirebaseFirestore.instance.collection('groups'),
      tagsCollection = FirebaseFirestore.instance.collection('tags');

  ///Registra un nuevo usuario en la base de datos
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

  ///Añade un nuevo post a la base de datos
  ///
  ///Recibe una lista de archivos `images` a postear junto con el pie de foto o descripción `footer`
  ///
  ///El id del usuario se toma de forma implícita al llamar al servicio de `DatabaseService` con el id del usuario `uid` como constructor
  Future addNewPost(List<File> images, String footer) async {
    List _paths = [];
    await uploadImages(images, _paths);
    return await postsCollection.doc().set({
      'author': uid,
      'comments': [],
      'footer': footer,
      'images': _paths,
      'likes': []
    });
  }

  ///Carga la lista de imagenes hacia el `Firebase Storage`
  Future uploadImages(List<File> images, List paths) async {
    firebase_storage.Reference ref;
    for (var img in images) {
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${img.path}');
      await ref
          .putFile(img)
          .whenComplete(() async => await ref.getDownloadURL().then((value) {
                paths.add(value);
              }));
    }
  }

  ///Me gusta/no me gusta
  Future likePost(DocumentSnapshot data) async {
    List _likes = data['likes'];
    if (_likes.contains(uid)) {
      _likes.remove(uid);
    } else {
      _likes.add(uid);
    }
    await postsCollection.doc(data.id).update({'likes': _likes});
  }

  ///Seguir o dejar de seguir
  Future follow(String followId) async {
    List _following =
        await usersCollection.doc(uid).get().then((doc) => doc['friends']);
    _following.contains(followId)
        ? _following.remove(followId)
        : _following.add(followId);
    await usersCollection.doc(uid).update({'friends': _following});
  }

  Future<bool> isFollowing(String followId) async {
    return (await usersCollection.doc(uid).get().then((doc) => doc['friends']))
        .contains(followId);
  }

  ///Añade una foto de perfil
  Future setProfilePic(BuildContext context, ImageSource source) async {
    File _image = await chooseImage(context, source);
    List _path = [];
    await uploadImages([_image], _path);
    return await usersCollection.doc(uid).update({'profilePic': _path.first});
  }

  Future<bool> createGroup(
      String name, String tagname, String description) async {
    QuerySnapshot a =
        await groupsCollection.where('tagname', isEqualTo: tagname).get();
    if (a.size > 0) {
      return false;
    } else {
      groupsCollection.doc().set({
        'name': name,
        'tagname': tagname,
        'description': description,
        'members': [uid]
      });
      return true;
    }
  }

  ///Unirse al grupo o abandonarlo si pertenece
  Future joinOrLeaveGroup(DocumentSnapshot data) async {
    List _members = data['members'];
    if (_members.contains(uid)) {
      _members.remove(uid);
    } else {
      _members.add(uid);
    }
    await groupsCollection.doc(data.id).update({'members': _members});
  }

  ///Seguir o dejar de seguir un tag
  Future toggleTag(String tag) async {
    List _interest =
        await usersCollection.doc(uid).get().then((doc) => doc['interest']);
    int _likes =
        await tagsCollection.doc(tag).get().then((doc) => doc['likes']);
    if (_interest.contains(tag)) {
      _interest.remove(tag);
      _likes -= 1;
    } else {
      _interest.add(tag);
      _likes += 1;
    }
    await usersCollection.doc(uid).update({'interest': _interest});
    await tagsCollection.doc(tag).update({'likes': _likes});
  }

  ///Retorna una lista de usuarios
  Stream<QuerySnapshot> getUsers() {
    return usersCollection.snapshots();
  }

  ///Retorna una lista de los posts
  Stream<QuerySnapshot> getPosts() {
    return postsCollection.snapshots();
  }

  ///Retorna una lista de los tags
  Stream<QuerySnapshot> getTags() {
    return tagsCollection.snapshots();
  }

  ///Mapea un `snapshot` para convertirlo en un objeto de tipo `PersonalInfo`
  Future<PersonalInfo> getPersonalInfo(String id) async {
    return PersonalInfo.fromSnapshot(await usersCollection.doc(id).get());
  }

  ///Mapea un `snapshot` para convertirlo en un objeto de tipo `PersonalInfo`
  Stream<DocumentSnapshot> getUserStream(String id) {
    return usersCollection.doc(id).snapshots();
  }
}
