import 'package:LadyBug/Widgets/Main_Screen/Card_View/CardBottomBar.dart';
import 'package:LadyBug/Widgets/Main_Screen/Card_View/CardContent.dart';
import 'package:LadyBug/Widgets/Main_Screen/Card_View/CardTopBar.dart';
import 'package:flutter/material.dart';

class Card_View extends StatelessWidget {
  //String name, uid, content, image;
  Map<String, dynamic> post;
  int index;
  final String uid;
  Card_View(this.post, this.index, this.uid);
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      new Container(
          //width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.blue[50],
          ),
          //padding: EdgeInsets.fromLTRB(0, 1, 1, 10),

          padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CardTopBar(post['owner'],
                  DateTime.fromMillisecondsSinceEpoch(post['timestamp'])),
              Divider(),
              CardContent(post, false, uid),
              SizedBox(
                height: 10,
              ),
            ],
          )),
      Divider(
        height: 0,
      ),
      CardBottomBar(post, false, false, false),
      Divider(
        height: 16,
      ),
    ]);
  }
}
