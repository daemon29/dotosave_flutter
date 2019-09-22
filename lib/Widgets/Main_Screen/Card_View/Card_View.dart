import 'package:LadyBug/Widgets/CommentBox.dart';
import 'package:LadyBug/Widgets/Comment_Card/Comment_Card.dart';
import 'package:LadyBug/Widgets/Main_Screen/Card_View/CardBottomBar.dart';
import 'package:LadyBug/Widgets/Main_Screen/Card_View/CardContent.dart';
import 'package:LadyBug/Widgets/Main_Screen/Card_View/CardTopBar.dart';
import 'package:LadyBug/Widgets/SlideRightRoute.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Card_View extends StatelessWidget {
  //String name, uid, content, image;
  Map<String, dynamic> post;
  final currentUserId, postId;
  Card_View(this.postId, this.post, this.currentUserId);
  Future getComments() async {
    QuerySnapshot qs = await Firestore.instance
        .collection('Comment')
        .where('postId', isEqualTo: postId)
        .getDocuments();
    return qs.documents;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      (post['owner(oid)'] == "")
          ? new Card(
              color: Colors.grey[50],
              child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CardTopBar(
                          post['owner'],
                          DateTime.fromMillisecondsSinceEpoch(
                              post['timestamp']),
                          currentUserId,
                          false),
                      SizedBox(height: 10),
                      CardContent(
                          postId, post, false, post['owner'], currentUserId),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        height: 0,
                      ),
                      RaisedButton(
                        color: Colors.white,
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => FutureBuilder(
                                    future: (getComments()),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting)
                                        return Center(
                                            child: LinearProgressIndicator());
                                      else if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        return ListView.builder(
                                          itemCount:
                                              snapshot?.data?.length ?? 0,
                                          itemBuilder: (context, index) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting)
                                              return Center(
                                                  child:
                                                      LinearProgressIndicator());
                                            else
                                              return CommentCard(
                                                  snapshot.data[index].data,
                                                  currentUserId);
                                          },
                                        );
                                      }
                                    },
                                  ));
                          /*
                          Navigator.push(
                              context,
                              SlideRightRoute(
                                  page: CommentBox(
                                      currentUserId, postId, false)));
                        */
                        },
                        child: Text("Comment"),
                      )
                      //  CardBottomBar(postId, post, false, false, false),
                    ],
                  )))
          : new Card(
              color: Colors.grey[50],
              child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CardTopBar(
                          post['owner(oid)'],
                          DateTime.fromMillisecondsSinceEpoch(
                              post['timestamp']),
                          currentUserId,
                          true),
                      SizedBox(height: 10),
                      CardContent(postId, post, false, post['owner(oid)'],
                          currentUserId),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        height: 0,
                      ),
                      // CardBottomBar(postId, post, false, false, false),
                      RaisedButton(
                        color: Colors.white,
                        onPressed: () {},
                        child: Text("Comment"),
                      )
                    ],
                  )))
    ]);
  }
}
