import 'package:LadyBug/Widgets/Comment_Card/Comment_Content.dart';
import 'package:LadyBug/Widgets/Comment_Card/Comment_Top.dart';
import 'package:LadyBug/Widgets/Main_Screen/Card_View/CardContent.dart';
import 'package:LadyBug/Widgets/Main_Screen/CircleAvatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommentCard extends StatefulWidget {
  final String currentUserId;
  final Map<String, dynamic> comment;
  bool liked;
  CommentCard(this.comment, this.currentUserId);
  @override
  _CommentCard createState() => _CommentCard(this.comment, this.currentUserId);
}

class _CommentCard extends State<CommentCard> {
  final Map<String, dynamic> comment;
  final String currentUserId;
  bool liked = false;
  _CommentCard(this.comment, this.currentUserId);
  Future getPostOwner() async {
    DocumentSnapshot ds = await Firestore.instance
        .collection("User")
        .document(comment['owner'])
        .get();
    return ds;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: FutureBuilder(
      future: getPostOwner(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());
        else if (snapshot.connectionState == ConnectionState.done) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              MyCircleAvatar(comment['owner'], snapshot.data['imageurl'], 40.0,
                  currentUserId, true),
                SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CommentTop(
                      comment['owner'],
                      snapshot.data['name'],
                      DateTime.fromMillisecondsSinceEpoch(comment['timestamp']),
                      currentUserId),
                  CommentContent(comment['content'], comment['image'], true,
                      comment['owner'], currentUserId),
                  Divider(
                    height: 0,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {},
                          splashColor: Colors.pink,
                          color: liked ? Colors.pink : Colors.black,
                          icon: liked
                              ? Icon(Icons.favorite)
                              : Icon(Icons.favorite_border),
                        ),
                        Text(comment['like'].length.toString()),
                      ])
                ],
              )
            ],
          );
        }
      },
    ));
  }
}
