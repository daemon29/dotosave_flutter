import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:LadyBug/Screens/Post_screen.dart';

class CardContent extends StatelessWidget {
  Map<String, dynamic> post;
  final String id, currentUserId, postId;
  bool imageVisible = false;
  bool clipText;
  CardContent(
      this.postId, this.post, this.clipText, this.id, this.currentUserId);
  @override
  Widget build(BuildContext context) {
    if (post['image'] != "" && post['image'] != null) {
      return Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: GestureDetector(
                  onTap: clipText
                      ? null
                      : () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return PostSreen(
                                    postId, id, post, currentUserId);
                              },
                            ),
                          );
                        },
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        post['content'],
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 17),
                        overflow: clipText
                            ? TextOverflow.clip
                            : TextOverflow.ellipsis,
                        maxLines: 9,
                      )))),
          GestureDetector(
              onTap: clipText
                  ? null
                  : () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return PostSreen(postId, id, post, currentUserId);
                          },
                        ),
                      );
                    },
              child: Container(
                  /*child: Image(
                image: NetworkImage(post['image']),
                */
                  constraints: BoxConstraints(minHeight: 40),
                  child: Center(
                    child: CachedNetworkImage(
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      imageUrl: post['image'],
                    ),
                  )))
        ],
      );
    } else {
      return Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: GestureDetector(
              onTap: clipText
                  ? null
                  : () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return PostSreen(postId, id, post, currentUserId);
                          },
                        ),
                      );
                    },
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    post['content'],
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 17),
                    maxLines: 7,
                  ))));
    }
  }
}
