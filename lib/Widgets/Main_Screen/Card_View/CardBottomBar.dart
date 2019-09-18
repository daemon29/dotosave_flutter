import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardBottomBar extends StatefulWidget {
  final bool liked, commented, shared;
  String docId;
  Map<String, dynamic> post;
  CardBottomBar(this.post, this.liked, this.commented, this.shared, this.docId);

  @override
  CardBottomBarState createState() =>
      CardBottomBarState(post, liked, commented, shared, docId);
}

class CardBottomBarState extends State<CardBottomBar> {
  bool liked, commented, shared;
  String docId, uid;
  Map<String, dynamic> post;
  CardBottomBarState(
      this.post, this.liked, this.commented, this.shared, this.docId);

  Future<Null> react_post() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String uid = pref.getString("uid");
    print(uid);
    DocumentReference postref =
        Firestore.instance.collection("Post").document(docId);
    DocumentSnapshot postsnap =
        await postref.collection("Like").document(uid).get();
    if (postsnap == null || !postsnap.exists) {
      postref.collection("Like").document(uid).setData({'uid': uid});
    } else {
      await postref.collection("Like").document(uid).delete();
    }

    // Firestore.instance.runTransaction((Transaction tx) async {
    //   DocumentReference uidRef =
    //       postRef.collection("like").document(preferences.getString("uid"));
    //   DocumentSnapshot postSnapshot = await tx.get(postRef);
    //   if (postSnapshot.exists) {
    //     await tx.update(
    //         postRef, <String, dynamic>{'like': postSnapshot.data['like'] + 1});
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: () {},
                splashColor: Colors.blue,
                color: commented ? Colors.blue : Colors.black,
                icon: Icon(Icons.comment),
              ),
              Text(post['comment'].toString()),
            ],
          ),
        ),
        Container(
          child: Row(
            children: <Widget>[
              IconButton(
                  onPressed: () {},
                  splashColor: Colors.green,
                  color: shared ? Colors.green : Colors.black,
                  icon: Icon(
                    Icons.share,
                  )),
              Text(post['share'].toString()),
            ],
          ),
        ),
        Container(
          child: Row(
            children: <Widget>[
              IconButton(
                  onPressed: react_post,
                  splashColor: Colors.pink,
                  color: liked ? Colors.pink : Colors.black,
                  icon: liked
                      ? Icon(Icons.favorite)
                      : Icon(Icons.favorite_border)),
              Text(post['like'].toString()),
            ],
          ),
        ),
      ],
    );
  }
}
