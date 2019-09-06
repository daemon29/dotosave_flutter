import 'package:LadyBug/Widgets/Main_Screen/Card_View/CardBottomBar.dart';
import 'package:LadyBug/Widgets/Main_Screen/Card_View/CardContent.dart';
import 'package:LadyBug/Widgets/Main_Screen/Card_View/CardTopBar.dart';
import 'package:flutter/material.dart';

class Card_View extends StatelessWidget {
  //String name, uid, content, image;
  Map<String, dynamic> post;
  Card_View(Map<String, dynamic> this.post);
  @override
  Widget build(BuildContext context) {
    return new Container(
        //width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        padding: EdgeInsets.fromLTRB(0, 1, 1, 10),
        child: Column(
          children: <Widget>[
            CardTopBar(post['owner']),
            CardContent(post['content'], post['image']),
            CardBottomBar(0, 0, 0, false, false, false),
          ],
        ));
  }
}
