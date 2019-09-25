import 'package:LadyBug/Customize/MultiLanguage.dart';
import 'package:LadyBug/Widgets/CommentBox.dart';
import 'package:LadyBug/Widgets/Comment_Card/Comment_Card.dart';

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
        .where('postId', isEqualTo: postId).orderBy('timestamp',descending: true)
        .getDocuments();
    return qs.documents;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              captions[setLanguage]['viewpost'],
            ),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(icon: Icon(Icons.book)),
                Tab(icon: Icon(Icons.comment)),
              ],
            ),
          ),
          body: TabBarView(children: [
            PostTop(postId, currentUserId,
                DateTime.fromMillisecondsSinceEpoch(post['timestamp']), post),
            FutureBuilder(
              future: (getComments()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());
                else if (snapshot.connectionState == ConnectionState.done) {
                  return ListView.builder(
                    itemCount: (snapshot?.data?.length ?? 0),
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: EdgeInsets.only(left: 5, right: 5,bottom: 5),
                          child: CommentCard(
                              snapshot.data[index].data, currentUserId));
                    },
                  );
                }
              },
            )
          ]),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return CommentBox(currentUserId, postId, false);
                  },
                ),
              );
            },
            child: Icon(
              Icons.add_comment,
            ),
          ),
          //bottomNavigationBar: MyBottomNavigationBar(context, uid, 0)
        ));
  }
}
