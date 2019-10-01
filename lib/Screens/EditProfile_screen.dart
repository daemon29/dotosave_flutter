import 'dart:io';

import 'package:LadyBug/Customize/MultiLanguage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class EditProfileScreen extends StatefulWidget {
  final String uid;
  EditProfileScreen(this.uid);
  @override
  EditProfileScreenState createState() {
    // TODO: implement createState
    return EditProfileScreenState(uid);
  }
}

class EditProfileScreenState extends State<EditProfileScreen> {
  final String uid;
  EditProfileScreenState(this.uid);
  Future getUserInformation() async {
    DocumentSnapshot docs =
        await Firestore.instance.collection('User').document(uid).get();
    return docs.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            captions[setLanguage]["editprofile"],
          ),
        ),
        body: Card(
            child: FutureBuilder(
                future: getUserInformation(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Container();
                  if (snapshot.connectionState == ConnectionState.done)
                    return Edit_Profile_Top(snapshot.data, uid);
                })));
  }
}

class Edit_Profile_Top extends StatefulWidget {
  final String currentuid;
  final Map<String, dynamic> user;
  Edit_Profile_Top(this.user, this.currentuid);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Edit_Profile_Top_State(this.user, this.currentuid);
  }
}

class Edit_Profile_Top_State extends State<Edit_Profile_Top> {
  final String currentuid;
  final Map<String, dynamic> user;
  File backgroundimage, avatar;
  Edit_Profile_Top_State(this.user, this.currentuid);
  bool _busy = false;
  bool isDisable = false;
  var name, bio, nickname;
  @override
  void initState() {
    name = new TextEditingController(text: user['name']);
    bio = new TextEditingController(text: user['bio']);
    nickname = new TextEditingController(text: user['nickname']);
    super.initState();
  }

  Future submit() async {
    this.setState(() {
      _busy = true;
    });
    var uuid = new Uuid();
    if (backgroundimage != null) {
      String filename = currentuid + uuid.v1();
      StorageReference reference =
          FirebaseStorage.instance.ref().child('Images/$filename');
      StorageUploadTask uploadTask = reference.putFile(backgroundimage);
      StorageTaskSnapshot storageTaskSnapshot;
      uploadTask.onComplete.then((value) {
        if (value.error == null) {
          storageTaskSnapshot = value;
          storageTaskSnapshot.ref.getDownloadURL().then((url) {
            Firestore.instance
                .collection("User")
                .document(currentuid)
                .updateData({'backgroundurl': url}).then((onValue) {
              this.setState(() {
                _busy = false;
              });
            }).catchError((error) {
              this.setState(() {
                _busy = false;
              });
              Fluttertoast.showToast(
                msg: error.toString(),
                backgroundColor: Colors.deepOrange[700],
                textColor: Colors.white,
              );
            });
          }).catchError((error) {
            this.setState(() {
              _busy = false;
            });
            Fluttertoast.showToast(msg: error.toString());
          });
        } else {
          setState(() {
            _busy = false;
          });
          Fluttertoast.showToast(
            msg: captions[setLanguage]["This file is not an image"],
            backgroundColor: Colors.deepOrange[700],
            textColor: Colors.white,
          );
        }
      }, onError: (err) {
        setState(() {
          _busy = false;
        });
        Fluttertoast.showToast(
          msg: err.toString(),
          backgroundColor: Colors.deepOrange[700],
          textColor: Colors.white,
        );
      });
    }
    if (avatar != null) {
      String filename = currentuid + uuid.v1();
      StorageReference reference =
          FirebaseStorage.instance.ref().child('Images/$filename');
      StorageUploadTask uploadTask = reference.putFile(avatar);
      StorageTaskSnapshot storageTaskSnapshot;
      uploadTask.onComplete.then((value) {
        if (value.error == null) {
          storageTaskSnapshot = value;
          storageTaskSnapshot.ref.getDownloadURL().then((url) {
            Firestore.instance
                .collection("User")
                .document(currentuid)
                .updateData({'imageurl': url}).then((onValue) {
              this.setState(() {
                _busy = false;
              });
            }).catchError((error) {
              this.setState(() {
                _busy = false;
              });
              Fluttertoast.showToast(msg: error.toString());
            });
          }).catchError((error) {
            this.setState(() {
              _busy = false;
            });
            Fluttertoast.showToast(
              msg: error.toString(),
              backgroundColor: Colors.deepOrange[700],
              textColor: Colors.white,
            );
          });
        } else {
          setState(() {
            _busy = false;
          });
          Fluttertoast.showToast(
            msg: captions[setLanguage]["This file is not an image"],
            backgroundColor: Colors.deepOrange[700],
            textColor: Colors.white,
          );
        }
      }, onError: (err) {
        setState(() {
          _busy = false;
        });
        Fluttertoast.showToast(
          msg: err.toString(),
          backgroundColor: Colors.deepOrange[700],
          textColor: Colors.white,
        );
      });
    }
    Firestore.instance.collection("User").document(currentuid).updateData({
      'name': (name.text != "") ? name.text : user['name'],
      'nickname': (nickname.text != "") ? nickname.text : user['nickname'],
      'bio': (bio.text != "") ? bio.text : user['bio']
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: ListView(children: <Widget>[
          SizedBox(
              height: 210,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: <Widget>[
                  Positioned(
                      top: 0,
                      left: 0,
                      child: InkWell(
                        onTap: () async {
                          var image = await ImagePicker.pickImage(
                              source: ImageSource.gallery, imageQuality: 10);
                          if (image == null) return;
                          setState(() {
                            backgroundimage = image;
                          });
                        },
                        child: SizedBox(
                            height: 170.0,
                            width: MediaQuery.of(context).size.width,
                            child: Stack(children: [
                              (backgroundimage == null)
                                  ? (user['backgroundurl'] == "")
                                      ? Container()
                                      : Positioned(
                                          top: 0,
                                          left: 0,
                                          right: 0,
                                          child: CachedNetworkImage(
                                              placeholder: (context, url) => Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                              imageUrl: user['backgroundurl'],
                                              fit: BoxFit.cover))
                                  : Positioned(
                                      top: 0,
                                      left: 0,
                                      right: 0,
                                      child: Image.file(
                                        backgroundimage,
                                        fit: BoxFit.cover,
                                      )),
                              (backgroundimage == null)
                                  ? Positioned(
                                      top: 5,
                                      right: 5,
                                      child: Container(
                                          padding: EdgeInsets.all(5),
                                          child: Icon(
                                            Icons.edit,
                                          )),
                                    )
                                  : Positioned(
                                      top: 5,
                                      right: 5,
                                      child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              backgroundimage = null;
                                            });
                                          },
                                          child: Container(
                                              padding: EdgeInsets.all(5),
                                              child: Icon(
                                                Icons.clear,
                                              ))),
                                    )
                            ])),
                      )),
                  Positioned(
                      left: 10,
                      top: 90,
                      child: GestureDetector(
                        onTap: () async {
                          var image = await ImagePicker.pickImage(
                              source: ImageSource.gallery, imageQuality: 10);
                          if (image == null) return;
                          setState(() {
                            avatar = image;
                          });
                        },
                        child: Stack(children: [
                          (avatar == null)
                              ? Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 120 * 0.03,
                                          color: Colors.white),
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: CachedNetworkImageProvider(
                                              user['imageurl']))))
                              : Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 120 * 0.03,
                                          color: Colors.white),
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: FileImage(avatar)))),
                          (avatar == null)
                              ? Positioned(
                                  bottom: 5,
                                  right: 5,
                                  child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.deepOrange[50],
                                        border: Border.all(color: Colors.white),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.deepOrange[700],
                                      )),
                                )
                              : Positioned(
                                  bottom: 5,
                                  right: 5,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        avatar = null;
                                      });
                                    },
                                    child: Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: Colors.deepOrange[50],
                                          border:
                                              Border.all(color: Colors.white),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.clear,
                                          color: Colors.deepOrange[700],
                                        )),
                                  ))
                        ]),
                      )),
                ],
              )),
          Padding(
              padding: EdgeInsets.only(left: 10),
              child: TextFormField(
                  controller: name,
                  //maxLength: 35,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(30),
                  ],
                  style: TextStyle(
                      fontFamily: 'Segoeu',
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                  //initialValue: user["name"],
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: captions[setLanguage]['namehere!']))),
          Divider(
            indent: 10,
            endIndent: 10,
          ),
          Padding(
              padding: EdgeInsets.only(left: 10),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.edit,
                  ),
                  Text(captions[setLanguage]["nickname"],
                      style: TextStyle(
                          fontFamily: 'Segoeu',
                          color: Colors.black,
                          fontWeight: FontWeight.bold))
                ],
              )),
          Padding(
              padding: EdgeInsets.only(left: 10),
              child: TextFormField(
                  controller: nickname,
                  maxLength: 20,
                  maxLines: 1,
                  //initialValue: user["nickname"],
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: captions[setLanguage]['nicknamehere!']))),
          Divider(
            indent: 10,
            endIndent: 10,
          ),
          Padding(
              padding: EdgeInsets.only(left: 10),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.edit,
                  ),
                  Text(captions[setLanguage]["bio"],
                      style: TextStyle(
                          fontFamily: 'Segoeu',
                          color: Colors.black,
                          fontWeight: FontWeight.bold))
                ],
              )),
          Padding(
              padding: EdgeInsets.only(left: 10),
              child: TextFormField(
                  controller: bio,
                  maxLength: 160,
                  maxLines: null,
                  //initialValue: user["bio"],
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: captions[setLanguage]['biohere!']))),
          Divider(
            indent: 10,
            endIndent: 10,
          ),
          RaisedButton(
            onPressed: (isDisable)
                ? null
                : () {
                    setState(() {
                      isDisable = true;
                    });
                    submit();
                    Navigator.pop(context);
                  },
            child: Text(
              captions[setLanguage]["save"],
              style: TextStyle(fontFamily: 'Segoeu'),
            ),
          )
        ]));
  }
}
