import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardBottomBar extends StatefulWidget {
  final int like, comment, share;
  final bool liked, commented, shared;
  CardBottomBar(this.like, this.comment, this.share, this.liked,
      this.commented, this.shared);

  @override
  CardBottomBarState createState() => CardBottomBarState(like,comment,share,liked,commented,shared);
}

class CardBottomBarState extends State<CardBottomBar> {
  final int like, comment, share;
  bool liked, commented, shared;
  CardBottomBarState(this.like, this.comment, this.share, this.liked,
      this.commented, this.shared);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:  MainAxisAlignment.start,
      children: <Widget>[
        IconButton(
          onPressed: () {},
          splashColor: Colors.blue,
          color: commented ? Colors.blue : Colors.black,
          icon: Icon(Icons.comment),
        ),
        Text(comment.toString()),
        IconButton(
            onPressed: () {},
            splashColor: Colors.green,
            color: shared ? Colors.green : Colors.black,
            icon: Icon(
              Icons.share,
            )),
        Text(share.toString()),
        IconButton(
            onPressed: () {},
            splashColor: Colors.pink,
            color: liked ? Colors.pink : Colors.black,
            icon: liked ? Icon(Icons.favorite) : Icon(Icons.favorite_border)),
        Text(comment.toString()),
      ],
    );
  }
}
