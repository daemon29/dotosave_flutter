import 'package:LadyBug/Customize/MultiLanguage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'donate_screen.dart';

class SignUp extends StatefulWidget {
  @override
  _Signup createState() => new _Signup();
}

class _Signup extends State<SignUp> {
  bool isLoading = false;
  String email, password;
  Widget horizontalLine() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          width: ScreenUtil.getInstance().setWidth(120),
          height: 1.0,
          color: Colors.black26.withOpacity(.2),
        ),
      );
  Future<Null> signinWithEmail() async {
    this.setState(() {
      isLoading = true;
    });
    if (email == null || password == null) {
      this.setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "Email or password cannot be empty");
      return;
    } else {
      FirebaseUser user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (user != null) {
        this.setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: "Signup success!");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DonateScreen(currentUserId: user.uid)));
      } else {
        Fluttertoast.showToast(msg: "Sign in fail");
        this.setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    return new Scaffold(
        appBar: AppBar(
          title: Text(
            captions[setLanguage]["signup"],
          ),
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 20),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Image.asset(
                        "assets/images/logo.png",
                        width: ScreenUtil.getInstance().setWidth(110),
                        height: ScreenUtil.getInstance().setHeight(110),
                      ),
                      Text("dotosave",
                          style: TextStyle(
                              fontFamily: 'Manjari',
                              fontSize: ScreenUtil.getInstance().setSp(46),
                              letterSpacing: .6,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0.0, 15.0),
                              blurRadius: 15.0),
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0.0, -10.0),
                              blurRadius: 15.0)
                        ]),
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            captions[setLanguage]["signup"],
                            style: TextStyle(
                                fontFamily: 'Segoeu',
                                fontSize: ScreenUtil.getInstance().setSp(45),
                                letterSpacing: .6),
                          ),
                          SizedBox(
                            height: ScreenUtil.getInstance().setHeight(30),
                          ),
                          Text(
                            "Email",
                            style: TextStyle(
                              fontFamily: 'Segoeu',
                              fontSize: ScreenUtil.getInstance().setSp(26),
                            ),
                          ),
                          TextField(
                            onSubmitted: (value) {
                              setState(() {
                                email = value.trim();
                              });
                            },
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                hintText: captions[setLanguage]["emailhere!"],
                                hintStyle: TextStyle(
                                    fontFamily: 'Segoeu',
                                    color: Colors.grey,
                                    fontSize: 12.0)),
                          ),
                          SizedBox(
                            height: ScreenUtil.getInstance().setHeight(30),
                          ),
                          Text(captions[setLanguage]["password"],
                              style: TextStyle(
                                fontSize: ScreenUtil.getInstance().setSp(26),
                                fontFamily: 'Segoeu',
                              )),
                          TextField(
                            onSubmitted: (value) {
                              setState(() {
                                password = value.trim();
                              });
                            },
                            obscureText: true,
                            decoration: InputDecoration(
                                hintText: captions[setLanguage]["passwordhere!"],
                                hintStyle: TextStyle(
                                    fontFamily: 'Segoeu',
                                    color: Colors.grey,
                                    fontSize: 12.0)),
                          ),
                          SizedBox(
                            height: ScreenUtil.getInstance().setHeight(35),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(40),
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    RaisedButton(
                      onPressed: signinWithEmail,
                      child: Text(
                        captions[setLanguage]["signup"],
                      ),
                    )
                  ]),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(40),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
