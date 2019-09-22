import 'package:LadyBug/Screens/Profile_screen.dart';
import 'package:LadyBug/Screens/login_screen.dart';
import 'package:LadyBug/Screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  @override
  LoadingState createState() => new LoadingState();
}

class LoadingState extends State<Loading> {
  @override
  void initState() {
    isSignIn();
    super.initState();
  }

  void isSignIn() async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    if (currentUser == null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Main_Screen(currentUserId: currentUser.uid)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            child: Image.asset("assets/images/main_background.jpg"),
          ),
          Positioned(
            bottom: 0,
            child: Image.asset("assets/images/image_02.png"),
          ),
          Center(
            child: LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xfff5a623)),
            ),
          )
        ],
      ),
    );
  }
}
