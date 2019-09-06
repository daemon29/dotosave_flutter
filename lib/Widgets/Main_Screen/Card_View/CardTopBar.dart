import 'package:LadyBug/Widgets/Main_Screen/Card_View/Owner.dart';
import 'package:LadyBug/Widgets/Main_Screen/CircleAvatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class CardTopBar extends StatelessWidget {
  final String uid;
  CardTopBar(this.uid);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firestore.instance.collection('User').document(uid).get(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting)
          return Container();
          else
          return new Row(
            children: <Widget>[
              MyCircleAvatar(snapshot.data['imageurl']),
              SizedBox(width: 5,),
              Post_Owner(snapshot.data['name'],uid),
            ],
          );
        });
  }
}
