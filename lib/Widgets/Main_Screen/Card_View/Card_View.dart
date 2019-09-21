import 'package:LadyBug/Widgets/Main_Screen/Card_View/CardBottomBar.dart';
import 'package:LadyBug/Widgets/Main_Screen/Card_View/CardContent.dart';
import 'package:LadyBug/Widgets/Main_Screen/Card_View/CardTopBar.dart';
import 'package:flutter/material.dart';

class Card_View extends StatelessWidget {
  //String name, uid, content, image;
  Map<String, dynamic> post;
  final currentUserId, postId;
  Card_View(this.postId, this.post, this.currentUserId);
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      (post['owner(oid)'] == "")
          ? new Card(
              child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CardTopBar(
                          post['owner'],
                          DateTime.fromMillisecondsSinceEpoch(
                              post['timestamp']),
                          currentUserId,false),
                      SizedBox(height: 10),
                      CardContent(
                          postId, post, false, post['owner'], currentUserId),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        height: 0,
                      ),
                      CardBottomBar(postId, post, false, false, false),
                    ],
                  )))
          : new Card(
              child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CardTopBar(
                          post['owner(oid)'],
                          DateTime.fromMillisecondsSinceEpoch(
                              post['timestamp']),
                          currentUserId,true),
                      SizedBox(height: 10),
                      CardContent(
                          postId, post, false, post['owner(oid)'], currentUserId),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        height: 0,
                      ),
                      CardBottomBar(postId, post, false, false, false),
                    ],
                  )))
    ]);
  }
}
