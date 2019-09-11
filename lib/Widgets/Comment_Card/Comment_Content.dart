import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CommentContent extends StatelessWidget {
  final String uid, currentUserId, content, image;
  bool imageVisible = false;
  bool clipText;
  CommentContent(
      this.content, this.image, this.clipText, this.uid, this.currentUserId);
  @override
  Widget build(BuildContext context) {
    if (image != "" && image != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    content,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 17),
                    overflow:
                        clipText ? TextOverflow.clip : TextOverflow.ellipsis,
                    maxLines: 9,
                  ))),
              Container(
                  /*child: Image(
                image: NetworkImage(post['image']),
                */
                  constraints: BoxConstraints(
                    maxHeight: 350,
                  ),
                  child: CachedNetworkImage(
                    placeholder: (context, url) => CircularProgressIndicator(),
                    imageUrl: image,
                    fit: BoxFit.scaleDown,
                  ))
        ],
      );
    } else {
      return Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Text(
            content,
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 17),
            maxLines: 7,
          ));
    }
  }
}
