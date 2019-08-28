import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'sign_in.dart';
import 'main_screen.dart';

class SignUp extends StatefulWidget {
  @override
  _Signup createState() => new _Signup();
}

class _Signup extends State<SignUp> {
  String email = "", password = "";
  Widget horizontalLine() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          width: ScreenUtil.getInstance().setWidth(120),
          height: 1.0,
          color: Colors.black26.withOpacity(.2),
        ),
      );
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    return new Scaffold(
        appBar: AppBar(
          title: Text("SIGNUP"),
          backgroundColor: Color(0xfff5af19),
        ),
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: false,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Image.asset("assets/images/main_background.jpg"),
                ),
                Expanded(
                  child: Container(),
                ),
                Image.asset("assets/images/image_02.png")
              ],
            ),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 60),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Image.asset(
                          "assets/images/logo.png",
                          width: ScreenUtil.getInstance().setWidth(110),
                          height: ScreenUtil.getInstance().setHeight(110),
                        ),
                        Text("LADYBUG",
                            style: TextStyle(
                                fontSize: ScreenUtil.getInstance().setSp(46),
                                letterSpacing: .6,
                                fontWeight: FontWeight.bold))
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(180),
                    ),
                    Container(
                      width: double.infinity,
                      height: ScreenUtil.getInstance().setHeight(500),
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
                              "Signup",
                              style: TextStyle(
                                  fontFamily: "Poppins-Bold",
                                  fontSize: ScreenUtil.getInstance().setSp(45),
                                  letterSpacing: .6),
                            ),
                            SizedBox(
                              height: ScreenUtil.getInstance().setHeight(30),
                            ),
                            Text(
                              "Email",
                              style: TextStyle(
                                fontFamily: "Poppins-Medium",
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
                                  hintText: "Type your email here",
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 12.0)),
                            ),
                            SizedBox(
                              height: ScreenUtil.getInstance().setHeight(30),
                            ),
                            Text("Password",
                                style: TextStyle(
                                  fontSize: ScreenUtil.getInstance().setSp(26),
                                  fontFamily: "Poppins-Medium",
                                )),
                            TextField(
                              onSubmitted: (value) {
                                setState(() {
                                  password = value.trim();
                                });
                              },
                              obscureText: true,
                              decoration: InputDecoration(
                                  hintText: "Password . . .",
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 12.0)),
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
                    Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          InkWell(
                            child: Container(
                              width: ScreenUtil.getInstance().setWidth(330),
                              height: ScreenUtil.getInstance().setHeight(100),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    Color(0xfff12711),
                                    Color(0xfff5af19)
                                  ]),
                                  borderRadius: BorderRadius.circular(6.0),
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            Color(0xfff5af19).withOpacity(.3),
                                        offset: Offset(0.0, 8.0),
                                        blurRadius: 8.0)
                                  ]),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    signUpWithEmail(this.email, this.password)
                                        .then((uid) {
                                      if (uid != null)
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return MainScreen();
                                        }));
                                      else
                                        return;
                                    }).catchError((onError) {
                                      print(onError.toString());
                                    });
                                  },
                                  child: Center(
                                    child: Text(
                                      "SIGNUP",
                                      style: TextStyle(
                                          fontFamily: "Poppins-Bold",
                                          color: Colors.white,
                                          fontSize: 18,
                                          letterSpacing: 1.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]),
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(40),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
