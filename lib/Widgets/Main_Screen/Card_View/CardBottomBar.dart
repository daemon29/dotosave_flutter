import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardBottomBar extends StatefulWidget {
  final bool liked, commented, shared;
  final String postId;
  Map<String, dynamic> post;
  CardBottomBar(this.postId,this.post, this.liked, this.commented, this.shared);

  @override
  CardBottomBarState createState() =>
      CardBottomBarState(postId, post, liked, commented, shared);
}

class CardBottomBarState extends State<CardBottomBar> {
  bool liked, commented, shared;
  final String postId;
  Map<String, dynamic> post;
  CardBottomBarState(this.postId,this.post, this.liked, this.commented, this.shared);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        IconButton(
          onPressed: () {},
          splashColor: Colors.blue,
          color: commented ? Colors.blue : Colors.black,
          icon: Icon(Icons.comment),
        ),
        //Text(post['comment'].length.toString()),
        IconButton(
            onPressed: () {},
            splashColor: Colors.green,
            color: shared ? Colors.green : Colors.black,
            icon: Icon(
              Icons.share,
            )),
        //Text(post['share'].length.toString()),
        IconButton(
            onPressed: () {},
            splashColor: Colors.pink,
            color: liked ? Colors.pink : Colors.black,
            icon: liked ? Icon(Icons.favorite) : Icon(Icons.favorite_border)),
        //Text(post['like'].length.toString()),
      ],
    );
  }
}
