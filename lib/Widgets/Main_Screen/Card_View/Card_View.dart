import 'package:LadyBug/Widgets/Main_Screen/Card_View/CardBottomBar.dart';
import 'package:LadyBug/Widgets/Main_Screen/Card_View/CardContent.dart';
import 'package:LadyBug/Widgets/Main_Screen/Card_View/CardTopBar.dart';
import 'package:flutter/material.dart';

class Card_View extends StatefulWidget {
  Map<String, dynamic> post;
  String docid;
  int index;
  final String uid;
  Card_View(this.post, this.index, this.uid, this.docid);

  @override
  State createState() {
    Card_View_State(post, index, uid, docid);
  }
}

class Card_View_State extends State<Card_View> {
  //String name, uid, content, image;
  Map<String, dynamic> post;
  String docid;
  int index;
  final String uid;

  Card_View_State(this.post, this.index, this.uid, this.docid);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      new Card(
          //width: MediaQuery.of(context).size.width,
          /*  decoration: BoxDecoration(
                //color: Colors.white,
                color: Colors.white,
                border: Border.all(
                  color: Colors.blueGrey[200],
                  width: 1,
                )),*/
          //padding: EdgeInsets.fromLTRB(0, 1, 1, 10),

          //padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
          child: Padding(
              padding: EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CardTopBar(post['owner'],
                      DateTime.fromMillisecondsSinceEpoch(post['timestamp'])),
                  SizedBox(height: 10),
                  CardContent(post, false, uid, docid),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    height: 0,
                  ),
                  CardBottomBar(post, false, false, false, docid),
                ],
              ))),
    ]);
  }
}
