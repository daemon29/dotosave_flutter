import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:uuid/uuid.dart';
class AddPost extends StatefulWidget {
  final String uid;
  AddPost(this.uid);
  @override
  AddPostState createState() => AddPostState(uid);
}

class AddPostState extends State<AddPost> {
  final String uid;
  File _file = null;
  bool _visible = false;
  bool _send_clickable = false;
 

  Image getImage(var _file) {
    if (_file == null)
      return Image.asset(
        "Images/image_02.png",
      );
    else {
      return Image.file(_file,);
    }
  }

  AddPostState(this.uid);
  Future<File> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  String content = "";
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
            Firestore.instance.collection('Post').document().setData({
              'content': content,
              'comment': [],
              'image': url,
              'like': [],
              'share': [],
              'owner': uid,
              'timestamp': DateTime.now().toUtc().millisecondsSinceEpoch
            });
          });
        }
      });
      // image.delete();
    } else {
      Firestore.instance.collection('Post').document().setData({
        'content': content,
        'comment': [],
        'image': "",
        'like': [],
        'share': [],
        'owner': uid,
        'timestamp': DateTime.now().toUtc().millisecondsSinceEpoch
      });
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Create Post"),
        ),
        body: ListView(children: [
          Padding(
              padding: EdgeInsets.fromLTRB(1, 1, 1, 10),
              child: Card(
                  child: Padding(
                      padding: EdgeInsets.all(2),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Flexible(
                              flex: 5,
                              child: new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    TextField(
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'What\'s on your mind?'),
                                      keyboardType: TextInputType.multiline,
                                      onChanged: (str) {
                                        if (str.length > 0) {
                                          content = str;
                                          setState(() {
                                            _send_clickable = true;
                                          });
                                        } else {
                                          content = str;
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
                                                tooltip: 'Remove image',
                                                onPressed: () {
                                                  setState(() {
                                                    _visible = false;
                                                  });
                                                },
                                                iconSize: 32,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ],
                                        ))),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        RawMaterialButton(
                                          constraints: BoxConstraints.tight(
                                              Size(36, 36)),
                                          child: Icon(
                                            Icons.image,
                                            color: Colors.blue,
                                            size: 32,
                                          ),
                                          onPressed: () async {
                                            var image =
                                                await ImagePicker.pickImage(
                                                    source: ImageSource.gallery,
                                                    imageQuality: 10);
                                            if (image == null) return;
                                            setState(() {
                                              _file = image;
                                              _visible = true;
                                            });
                                          },
                                        ),
                                        RawMaterialButton(
                                          constraints: BoxConstraints.tight(
                                              Size(36, 36)),
                                          child: Icon(
                                            Icons.insert_emoticon,
                                            color: Colors.blue,
                                            size: 32,
                                          ),
                                          onPressed: () {},
                                        ),
                                        Expanded(
                                          child: Container(),
                                        ),
                                        FlatButton(
                                          onPressed: _send_clickable
                                              ? UpLoadPost
                                              : null,
                                          padding: EdgeInsets.all(0.0),
                                          color: Colors.blue,
                                          disabledColor: Colors.blue[100],
                                          splashColor: Colors.blueAccent,
                                          child: Text(
                                            "Send",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )
                                      ],
                                    )
                                  ]))
                        ],
                      ))))
        ]));
  }
}
