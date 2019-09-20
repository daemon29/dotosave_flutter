import 'package:LadyBug/Widgets/Main_Screen/Card_View/CardBottomBar.dart';
import 'package:LadyBug/Widgets/Main_Screen/Card_View/CardContent.dart';
import 'package:LadyBug/Widgets/Main_Screen/Card_View/CardTopBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PostTop extends StatelessWidget {
  final String postId, currentUserId;
  final Map<String, dynamic> post;
  final DateTime time;
  PostTop(this.postId, this.currentUserId, this.time, this.post);
  @override
  Widget build(BuildContext context) {
    return (post['owner(oid)'] == "")
        ? Card(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                CardTopBar(post['owner'], time, currentUserId, false),
                SizedBox(
                  height: 10,
                ),
                CardContent(postId, post, true, post['owner'], currentUserId),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  height: 0,
                ),
                CardBottomBar(postId, post, false, false, false),
              ]))
        : Card(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                CardTopBar(post['owner(oid)'], time, currentUserId, true),
                SizedBox(
                  height: 10,
                ),
                CardContent(postId, post, true, post['owner(oid)'], currentUserId),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  height: 0,
                ),
                CardBottomBar(postId, post, false, false, false),
              ]));
  }
}
