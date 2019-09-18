import 'package:LadyBug/Widgets/BottomNavigationBar.dart';
import 'package:LadyBug/Widgets/Main_Screen/Card_View/CardBottomBar.dart';
import 'package:LadyBug/Widgets/Main_Screen/Card_View/CardContent.dart';
import 'package:LadyBug/Widgets/Main_Screen/Card_View/CardTopBar.dart';
import 'package:flutter/material.dart';

class PostSreen extends StatefulWidget {
  final String uid;
  String docId;
  Map<String, dynamic> post;
  PostSreen(this.uid, this.post, this.docId);
  @override
  PostSreenState createState() => PostSreenState(uid, post, docId);
}

class PostSreenState extends State<PostSreen> {
  final String uid;
  String docId;
  Map<String, dynamic> post;
  PostSreenState(this.uid, this.post, this.docId);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('View Post')),
        body: ListView(children: [
          Card(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                CardTopBar(post['owner'],
                    DateTime.fromMillisecondsSinceEpoch(post['timestamp'])),
                SizedBox(
                  height: 10,
                ),
                CardContent(post, true, uid, docId),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  height: 0,
                ),
                CardBottomBar(post, false, false, false, docId),
              ])),
        ]),
        bottomNavigationBar: MyBottomNavigationBar(context, uid, 0));
  }
}
