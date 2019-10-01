import 'package:LadyBug/Screens/Profile_screen.dart';
import 'package:LadyBug/Widgets/Comment_Card/Comment_Top.dart';
import 'package:LadyBug/Widgets/Main_Screen/Card_View/Owner.dart';
import 'package:LadyBug/Widgets/Main_Screen/CircleAvatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class JoinCard extends StatelessWidget {
  final uid, currentUserId, request;
  Future getUser() async {
    DocumentSnapshot ds =
        await Firestore.instance.collection("User").document(uid).get();
    return ds;
  }

  JoinCard(this.uid, this.currentUserId, this.request);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: FutureBuilder(
          future: getUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Container();
            else if (snapshot.connectionState == ConnectionState.done) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MyCircleAvatar(uid, snapshot.data['imageurl'], 40.0,
                      currentUserId, true, false),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Post_Owner(snapshot.data['name'], uid, currentUserId,false),
                      Text(request),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ))
                ],
              );
            }
          },
        ));
  }
}
