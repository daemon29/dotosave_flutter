import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;

Future<String> uploadPic(File file, uid) async {
  var uuid = new Uuid();
  String filename = uid + uuid.v4();
  print("3");
  StorageReference reference = _storage.ref().child('Item/$filename.jpg');
  print("4");
  StorageUploadTask uploadTask = reference.putFile(file);
  print("5");
  await uploadTask.onComplete;
  print("6");
  var url = await reference.getDownloadURL();
  print(url);
  print("7");
  return url;
}

Future<String> submit(File file, Set<String> items, String body) async {
  print("1");
  if (file == null) throw "No file";
  if (items == null) throw "No items";
  if (body == null) throw "Body cant not be emty";
  final FirebaseUser _user = await FirebaseAuth.instance.currentUser();
  if (_user == null) throw "Must be a user";
  print("2");

  String uid = _user.uid;
  final Firestore fireStore = Firestore.instance;
  GeoPoint geoPoint = GeoPoint(90, -90);
  await uploadPic(file, uid).then((uri) {
    print(uid);
    print(uri);
    fireStore
        .collection("User")
        .document("$uid")
        .collection("Item")
        .document()
        .setData({
      "body": body,
      "url": uri,
      "geo": geoPoint,
      "item": items
    }).catchError((e) {
      print(e);
    });
    print("8");
    return "Success";
  }).catchError(() {
    return "Error";
  });
}
