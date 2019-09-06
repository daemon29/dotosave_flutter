import 'package:flutter/material.dart';

class CardContent extends StatelessWidget {
  final String content, url;
  bool imageVisible = false;
  CardContent(this.content, this.url);
  @override
  Widget build(BuildContext context) {
    if (url != null) {
      return Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: GestureDetector(
                  onTap: () {},
                  child: Text(
                    content,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 17),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 9,
                  ))),
          GestureDetector(
              
              onTap: () {},
              child: Container(child: Image(
                image: NetworkImage(url),)
              ))
        ],
      );
    } else {
      return Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: GestureDetector(
              onTap: () {},
              child: Text(
                content,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 17),
                maxLines: 7,
              )));
    }
  }
}
