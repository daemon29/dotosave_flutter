import 'package:LadyBug/Customize/MultiLanguage.dart';
import 'package:LadyBug/Widgets/CommentBox.dart';
import 'package:LadyBug/Widgets/Comment_Card/Comment_Card.dart';
import 'package:LadyBug/Widgets/Main_Screen/Card_View/CardContent.dart';
import 'package:LadyBug/Widgets/Main_Screen/Card_View/CardTopBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Card_View extends StatefulWidget {
  //String name, uid, content, image;
  Map<String, dynamic> post;
  final currentUserId, postId;
  Card_View(this.postId, this.post, this.currentUserId);
  @override
  Card_View_State createState() {
    // TODO: implement createState
    return Card_View_State(this.postId, this.post, this.currentUserId);
  }
}

class Card_View_State extends State<Card_View> {
  //String name, uid, content, image;
  Map<String, dynamic> post;
  final currentUserId, postId;
  Card_View_State(this.postId, this.post, this.currentUserId);
  Stream getComments() {
    return Firestore.instance
        .collection('Comment')
        .where('postId', isEqualTo: postId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      (post['owner(oid)'] == "")
          ? new Card(
              color: Colors.grey[50],
              child: Padding(
                  padding: EdgeInsets.only(top: 5, left: 5, right: 5),
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

                      FlatButton(
                        color: Colors.white,
                        onPressed: () {
                          showBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                      child: StreamBuilder(
                                    stream: (getComments()),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData)
                                        return Container();
                                      else
                                        return Card(
                                            color: Colors.grey[100],
                                            child: Column(children: [
                                              ListTile(
                                                  leading: IconButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      icon: Icon(
                                                          Icons.expand_more)),
                                                  title: Text(
                                                    captions[setLanguage]
                                                        ["comment"],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.black),
                                                  )),
                                              Expanded(
                                                  child: ListView.builder(
                                                    reverse: true,
                                                    itemCount: (snapshot
                                                            ?.data
                                                            ?.documents
                                                            ?.length ??
                                                        0),
                                                    itemBuilder:
                                                        (context, index) {
                                                      return CommentCard(
                                                          snapshot
                                                              .data
                                                              .documents[index]
                                                              .data,
                                                          currentUserId);
                                                    },
                                                  )),
                                              GetCommentBox(currentUserId,
                                                  postId, false, true)
                                            ]));
                                    },
                                  )));
                        },
                        child: Text(captions[setLanguage]["comment"]),
                      )
                      //  CardBottomBar(postId, post, false, false, false),
                    ],
                  )))
          : new Card(
              color: Colors.grey[50],
              child: Padding(
                  padding: EdgeInsets.only(top: 5, left: 5, right: 5),
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

                      // CardBottomBar(postId, post, false, false, false),
                      FlatButton(
                        color: Colors.white,
                        onPressed: () {
                          showBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                  child: StreamBuilder(
                                      stream: (getComments()),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData)
                                          return Container();
                                        else
                                          return Card(
                                              color: Colors.grey[100],
                                              child: Column(children: [
                                                ListTile(
                                                    leading: IconButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        icon: Icon(
                                                            Icons.expand_more)),
                                                    title: Text(
                                                      captions[setLanguage]
                                                          ["comment"],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors.black),
                                                    )),
                                                Expanded(
                                                    child: ListView.builder(
                                                  reverse: true,
                                                  itemCount: (snapshot?.data
                                                          ?.documents?.length ??
                                                      0),
                                                  itemBuilder:
                                                      (context, index) {
                                                    return CommentCard(
                                                        snapshot
                                                            .data
                                                            .documents[index]
                                                            .data,
                                                        currentUserId);
                                                  },
                                                )),
                                                GetCommentBox(currentUserId,
                                                    postId, false, true)

                                                /*
                                              RaisedButton(
                                                  padding: EdgeInsets.only(
                                                      left: 10, right: 10),
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        SlideRightRoute(
                                                            page: CommentBox(
                                                                currentUserId,
                                                                postId,
                                                                false)));
                                                  },
                                                  child: SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: SizedBox(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          child: Text(captions[
                                                                  setLanguage][
                                                              "writeacomment"]))))*/
                                              ]));
                                      })));
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
                    ],
                  )))
    ]);
  }
}
