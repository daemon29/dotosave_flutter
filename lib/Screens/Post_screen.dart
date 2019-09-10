import 'package:LadyBug/Widgets/BottomNavigationBar.dart';
import 'package:LadyBug/Widgets/CommentBox.dart';
import 'package:LadyBug/Widgets/Comment_Card/Comment_Card.dart';
import 'package:LadyBug/Widgets/Main_Screen/Card_View/CardBottomBar.dart';
import 'package:LadyBug/Widgets/Main_Screen/Card_View/CardContent.dart';
import 'package:LadyBug/Widgets/Main_Screen/Card_View/CardTopBar.dart';
import 'package:LadyBug/Widgets/Main_Screen/Post_screen/Post_Top.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostSreen extends StatefulWidget {
  final String uid, currentUserId, postId;
  Map<String, dynamic> post;
  PostSreen(this.postId, this.uid, this.post, this.currentUserId);
  @override
  PostSreenState createState() =>
      PostSreenState(this.postId, uid, post, currentUserId);
}

class PostSreenState extends State<PostSreen> {
  final String uid, currentUserId, postId;
  Map<String, dynamic> post;
  PostSreenState(this.postId, this.uid, this.post, this.currentUserId);

  Future getComments() async {
    QuerySnapshot qs = await Firestore.instance
        .collection('Comment')
        .where('postId', isEqualTo: postId)
        .getDocuments();
    return qs.documents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('View Post')),
        body: FutureBuilder(
          future: (getComments()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            else if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                itemCount: snapshot?.data?.length + 1 ?? 1,
                itemBuilder: (context, index) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());
                  else if (index == 0) {
                    return PostTop(
                        postId,
                        currentUserId,
                        DateTime.fromMicrosecondsSinceEpoch(post['timestamp']),
                        post);
                  } else {
                    return CommentCard(
                        snapshot.data[index - 1].data, currentUserId);
                  }
                },
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return CommentBox(currentUserId, postId);
                },
              ),
            );
          },
          child: Icon(
            Icons.add_comment,
            color: Colors.white,
          ),
          backgroundColor: Colors.blue,
        ),
        bottomNavigationBar: MyBottomNavigationBar(context, uid, 0));
  }
}
