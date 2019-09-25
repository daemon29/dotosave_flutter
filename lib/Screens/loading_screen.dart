import 'dart:io';

import 'package:LadyBug/Customize/MultiLanguage.dart';
import 'package:LadyBug/Screens/login_screen.dart';
import 'package:LadyBug/Screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Loading extends StatefulWidget {
  @override
  LoadingState createState() => new LoadingState();
}

class LoadingState extends State<Loading> {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/lang.txt');
  }

  Future<String> readLanguage() async {
    try {
      final file = await _localFile;

      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      return 'en';
    }
  }

  @override
  void initState() {
    getLang();
    isSignIn();
    super.initState();
  }

  void getLang() async {
    setLanguage = await readLanguage();
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
