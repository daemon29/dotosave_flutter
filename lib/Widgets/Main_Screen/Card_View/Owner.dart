import 'package:LadyBug/Screens/Profile_screen.dart';
import 'package:LadyBug/Widgets/SlideRightRoute.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Post_Owner extends StatelessWidget {
  final String name, uid, currentUserID;
  Post_Owner(this.name, this.uid, this.currentUserID);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(context,
              SlideRightRoute(page: ProfileScreen(currentUserID, uid)));
        },
        child: Text(
          name,
          style: TextStyle(
              fontFamily: 'Segoeu',
              color: Colors.deepOrange[900],
              fontWeight: FontWeight.bold),
        ));
  }
}
