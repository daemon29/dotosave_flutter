import 'package:LadyBug/Customize/MultiLanguage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class JoinUsScreen extends StatelessWidget {
  final currentUserId, cid;
  JoinUsScreen(this.cid, this.currentUserId);
  var controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(captions[setLanguage]["joinus!"]),
          actions: <Widget>[
            RaisedButton(
              onPressed: () {
                Firestore.instance
                    .collection("RequestJoin")
                    .document()
                    .setData({
                  'cid': cid,
                  'uid': currentUserId,
                  'introduction': controller.text
                });
                Navigator.pop(context);
              },
              child: Text(captions[setLanguage]["done"]),
            )
          ],
        ),
        body: Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: TextFormField(
              decoration: InputDecoration(
                  labelText: captions[setLanguage]['introduceyourself'],
                  border: InputBorder.none,
                  hintText: captions[setLanguage]['writesomethinghere...']),
              controller: controller,
              maxLength: 300,
              maxLines: null,
            )));
  }
}
