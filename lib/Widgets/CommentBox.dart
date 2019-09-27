import 'dart:async';
import 'dart:io';
import 'package:LadyBug/Customize/MultiLanguage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class CommentBox extends StatefulWidget {
  final String uid, postId;
  final bool campaign;
  CommentBox(this.uid, this.postId, this.campaign);
  @override
  _CommentBox createState() =>
      _CommentBox(this.uid, this.postId, this.campaign);
}

class _CommentBox extends State<CommentBox> {
  final String uid, postId;
  final bool campaign;
  _CommentBox(this.uid, this.postId, this.campaign);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(captions[setLanguage]["writeacomment"],
              style: const TextStyle(
                fontSize: 22,
                fontFamily: 'Manjari',
              )),
        ),
        body: ListView(children: [
          Padding(
              padding: EdgeInsets.fromLTRB(1, 1, 1, 10),
              child: GetCommentBox(this.uid, this.postId, this.campaign, false))
        ]));
  }
}

class GetCommentBox extends StatefulWidget {
  final String uid, postId;
  final bool campaign;
  final bool bottomsheet;
  GetCommentBox(this.uid, this.postId, this.campaign, this.bottomsheet);
  @override
  State<GetCommentBox> createState() {
    return (bottomsheet)
        ? _GetCommentBoxForBottomSheet(this.uid, this.postId, this.campaign)
        : _GetCommentBox(this.uid, this.postId, this.campaign);
  }
}

class _GetCommentBox extends State<GetCommentBox> {
  final String uid, postId;
  final bool campaign;
  _GetCommentBox(this.uid, this.postId, this.campaign);
  File _file = null;
  bool _visible = false;
  bool _send_clickable = false;

  Image getImage(var _file) {
    if (_file == null)
      return Image.asset(
        "Images/image_02.png",
      );
    else {
      return Image.file(
        _file,
      );
    }
  }

  Future<File> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  var controller;
  void UpLoadPost() async {
    if (_visible) {
      var uuid = new Uuid();

      ///File image = await testCompressAndGetFile(_file, "tempimg");
      String filename = uid + uuid.v1();
      final StorageReference storageRef =
          FirebaseStorage.instance.ref().child('Images').child(filename);
      StorageUploadTask uploadTask = storageRef.putFile(_file);
      StorageTaskSnapshot storageTaskSnapshot;
      uploadTask.onComplete.then((value) {
        if (value.error == null) {
          storageTaskSnapshot = value;
          storageTaskSnapshot.ref.getDownloadURL().then((url) {
            Firestore.instance.collection('Comment').document().setData({
              'content': controller.text,
              'image': url,
              'like': [],
              'owner': uid,
              'postId': postId,
              'timestamp': DateTime.now().toUtc().millisecondsSinceEpoch
            });
          });
        }
      });
      // image.delete();
    } else {
      Firestore.instance.collection('Comment').document().setData({
        'content': controller.text,
        'image': "",
        'like': [],
        'owner': uid,
        'postId': postId,
        'timestamp': DateTime.now().toUtc().millisecondsSinceEpoch
      });
    }
    controller.text = "";
    Navigator.pop(context);
  }

  void UpLoadPost2() async {
    if (_visible) {
      var uuid = new Uuid();

      ///File image = await testCompressAndGetFile(_file, "tempimg");
      String filename = uid + uuid.v1();
      final StorageReference storageRef =
          FirebaseStorage.instance.ref().child('Images').child(filename);
      StorageUploadTask uploadTask = storageRef.putFile(_file);
      StorageTaskSnapshot storageTaskSnapshot;
      uploadTask.onComplete.then((value) {
        if (value.error == null) {
          storageTaskSnapshot = value;
          storageTaskSnapshot.ref.getDownloadURL().then((url) {
            Firestore.instance.collection('Comment').document().setData({
              'content': controller.text,
              'image': url,
              'like': [],
              'owner': uid,
              'campaignId': postId,
              'timestamp': DateTime.now().toUtc().millisecondsSinceEpoch
            });
          });
        }
      });
      // image.delete();
    } else {
      Firestore.instance.collection('Comment').document().setData({
        'content': controller.text,
        'image': "",
        'like': [],
        'owner': uid,
        'campaignId': postId,
        'timestamp': DateTime.now().toUtc().millisecondsSinceEpoch
      });
    }
    controller.text = "";
    Navigator.pop(context);
  }

  @override
  void initState() {
    controller = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Flexible(
                    flex: 5,
                    child: new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextField(
                            controller: controller,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: captions[setLanguage]
                                    ['writeacomment...']),
                            keyboardType: TextInputType.multiline,
                            onChanged: (str) {
                              if (str.length > 0) {
                                setState(() {
                                  _send_clickable = true;
                                });
                              } else {
                                setState(() {
                                  _send_clickable = false;
                                });
                              }
                            },
                            maxLines: null,
                          ),
                          Visibility(
                              visible: _visible,
                              child: Container(
                                  child: Stack(
                                children: [
                                  getImage(_file),
                                  Positioned(
                                    right: 2,
                                    top: 2,
                                    child: IconButton(
                                      icon: Icon(Icons.close),
                                      tooltip: captions[setLanguage]
                                          ['removeimage'],
                                      onPressed: () {
                                        setState(() {
                                          _visible = false;
                                        });
                                      },
                                      iconSize: 32,
                                    ),
                                  ),
                                ],
                              ))),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              RawMaterialButton(
                                constraints: BoxConstraints.tight(Size(36, 36)),
                                child: Icon(
                                  Icons.image,
                                  size: 32,
                                ),
                                onPressed: () async {
                                  var image = await ImagePicker.pickImage(
                                      source: ImageSource.gallery,
                                      imageQuality: 10);
                                  if (image == null) return;
                                  setState(() {
                                    _file = image;
                                    _visible = true;
                                  });
                                },
                              ),
                              /*
                                        RawMaterialButton(
                                          constraints: BoxConstraints.tight(
                                              Size(36, 36)),
                                          child: Icon(
                                            Icons.insert_emoticon,
                                            size: 32,
                                          ),
                                          onPressed: () {},
                                        ),*/
                              Expanded(
                                child: Container(),
                              ),
                              FlatButton(
                                onPressed: _send_clickable
                                    ? ((campaign) ? UpLoadPost2 : UpLoadPost)
                                    : null,
                                padding: EdgeInsets.all(0.0),
                                child: Text(
                                  captions[setLanguage]["send"],
                                  style: TextStyle(
                                    fontFamily: 'Segoeu',
                                  ),
                                ),
                              )
                            ],
                          )
                        ]))
              ],
            )));
  }
}

class _GetCommentBoxForBottomSheet extends State<GetCommentBox> {
  final String uid, postId;
  final bool campaign;
  _GetCommentBoxForBottomSheet(this.uid, this.postId, this.campaign);
  File _file = null;
  bool _visible = false;
  bool _send_clickable = false;

  Image getImage(var _file) {
    if (_file == null)
      return Image.asset(
        "Images/image_02.png",
      );
    else {
      return Image.file(
        _file,
        scale: 0.2,
        fit: BoxFit.cover,
      );
    }
  }

  Future<File> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  TextEditingController controller;
  void UpLoadPost() async {
    Map<String, dynamic> temp;
    if (_visible) {
      var uuid = new Uuid();

      ///File image = await testCompressAndGetFile(_file, "tempimg");
      String filename = uid + uuid.v1();
      final StorageReference storageRef =
          FirebaseStorage.instance.ref().child('Images').child(filename);
      StorageUploadTask uploadTask = storageRef.putFile(_file);
      StorageTaskSnapshot storageTaskSnapshot;
      uploadTask.onComplete.then((value) {
        if (value.error == null) {
          storageTaskSnapshot = value;
          storageTaskSnapshot.ref.getDownloadURL().then((url) {
            temp = {
              'content': controller.text,
              'image': url,
              'like': [],
              'owner': uid,
              'postId': postId,
              'timestamp': DateTime.now().toUtc().millisecondsSinceEpoch
            };
            Firestore.instance.collection('Comment').document().setData(temp);
          });
        }
      });
      // image.delete();
    } else {
      temp = {
        'content': controller.text,
        'image': "",
        'like': [],
        'owner': uid,
        'postId': postId,
        'timestamp': DateTime.now().toUtc().millisecondsSinceEpoch
      };
      Firestore.instance.collection('Comment').document().setData(temp);
    }
    controller.text = "";
    Navigator.pop(context);
  }

  void UpLoadPost2() async {
    if (_visible) {
      var uuid = new Uuid();

      ///File image = await testCompressAndGetFile(_file, "tempimg");
      String filename = uid + uuid.v1();
      final StorageReference storageRef =
          FirebaseStorage.instance.ref().child('Images').child(filename);
      StorageUploadTask uploadTask = storageRef.putFile(_file);
      StorageTaskSnapshot storageTaskSnapshot;
      uploadTask.onComplete.then((value) {
        if (value.error == null) {
          storageTaskSnapshot = value;
          storageTaskSnapshot.ref.getDownloadURL().then((url) {
            Firestore.instance.collection('Comment').document().setData({
              'content': controller.text,
              'image': url,
              'like': [],
              'owner': uid,
              'campaignId': postId,
              'timestamp': DateTime.now().toUtc().millisecondsSinceEpoch
            });
          });
        }
      });
      // image.delete();
    } else {
      Firestore.instance.collection('Comment').document().setData({
        'content': controller.text,
        'image': "",
        'like': [],
        'owner': uid,
        'campaignId': postId,
        'timestamp': DateTime.now().toUtc().millisecondsSinceEpoch
      });
    }
    controller.text = "";
    Navigator.pop(context);
  }

  @override
  void initState() {
    controller = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Flexible(
                    flex: 5,
                    child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextField(
                            controller: controller,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: captions[setLanguage]
                                    ['writeacomment...']),
                            keyboardType: TextInputType.multiline,
                            onChanged: (str) {
                              if (str.length > 0) {
                                setState(() {
                                  _send_clickable = true;
                                });
                              } else {
                                setState(() {
                                  _send_clickable = false;
                                });
                              }
                            },
                            maxLines: 2,
                          ),
                          Visibility(
                              visible: _visible,
                              child: Container(
                                  height: 100,
                                  width: 100,
                                  child: Stack(
                                    children: [
                                      getImage(_file),
                                      Positioned(
                                        right: 2,
                                        top: 2,
                                        child: IconButton(
                                          icon: Icon(Icons.close),
                                          tooltip: captions[setLanguage]
                                              ['removeimage'],
                                          onPressed: () {
                                            setState(() {
                                              _visible = false;
                                            });
                                          },
                                          iconSize: 32,
                                        ),
                                      ),
                                    ],
                                  ))),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              RawMaterialButton(
                                constraints: BoxConstraints.tight(Size(36, 36)),
                                child: Icon(
                                  Icons.image,
                                  size: 32,
                                ),
                                onPressed: () async {
                                  var image = await ImagePicker.pickImage(
                                      source: ImageSource.gallery,
                                      imageQuality: 10);
                                  if (image == null) return;
                                  setState(() {
                                    _file = image;
                                    _visible = true;
                                  });
                                },
                              ),
                              /*
                                        RawMaterialButton(
                                          constraints: BoxConstraints.tight(
                                              Size(36, 36)),
                                          child: Icon(
                                            Icons.insert_emoticon,
                                            size: 32,
                                          ),
                                          onPressed: () {},
                                        ),*/
                              Expanded(
                                child: Container(),
                              ),
                              FlatButton(
                                onPressed: _send_clickable
                                    ? ((campaign) ? UpLoadPost2 : UpLoadPost)
                                    : null,
                                padding: EdgeInsets.all(0.0),
                                child: Text(
                                  captions[setLanguage]["send"],
                                  style: TextStyle(
                                    fontFamily: 'Segoeu',
                                  ),
                                ),
                              )
                            ],
                          )
                        ]))
              ],
            )));
  }
}
