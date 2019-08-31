import 'package:LadyBug/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'Widgets/SocialIcons.dart';
import 'Customize/CustomeIcon.dart';
import 'signup.dart';
import 'sign_in.dart';
import 'main_screen.dart';
import 'package:flutter/services.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String email = "", password = "";
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

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
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: false,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Positioned(
                  top: 0,
                  child: Image.asset("assets/images/main_background.jpg"),
                ),
                Positioned(
                    bottom: 0, child: Image.asset("assets/images/image_02.png"))
              ],
            ),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 40),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Row(
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
                    ),
                    /*
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(40),//70
                    ),*/
                    Container(
                      width: double.infinity,
                      //height: MainAxisSize.max,
                      //height: ScreenUtil.getInstance().setHeight(500),
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
                              "Login",
                              style: TextStyle(
                                  fontFamily: "Poppins-Bold",
                                  fontSize: ScreenUtil.getInstance().setSp(40),
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
                            Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      "Forgot Password?",
                                      style: TextStyle(
                                          fontFamily: "Poppins-Medium",
                                          color: Colors.orange,
                                          fontSize: ScreenUtil.getInstance()
                                              .setSp(28)),
                                    )
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                    /*
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(40),
                    ),*/
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              InkWell(
                                child: Container(
                                  width: ScreenUtil.getInstance().setWidth(330),
                                  height:
                                      ScreenUtil.getInstance().setHeight(100),
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                        Color(0xfff12711),
                                        Color(0xfff5af19)
                                      ]),
                                      borderRadius: BorderRadius.circular(6.0),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color(0xfff5af19)
                                                .withOpacity(.3),
                                            offset: Offset(0.0, 8.0),
                                            blurRadius: 8.0)
                                      ]),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        signInWithEmail(
                                            this.email, this.password);
                                      },
                                      child: Center(
                                        child: Text(
                                          "SIGN IN",
                                          style: TextStyle(
                                              fontFamily: "Poppins-Bold",
                                              color: Colors.white,
                                              fontSize: 15,
                                              letterSpacing: 1.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ])),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          horizontalLine(),
                          Text(
                            "Social Login",
                            style: TextStyle(
                                fontSize: 16.0, fontFamily: "Poppins-Medium"),
                          ),
                          horizontalLine()
                        ],
                      ),
                    ),
                    //child: Stack(children: <Widget>[
                    /*Image.asset(
                        "assets/images/image_02.png",
                        // height: double.infinity,
                        width: double.infinity,
                      ),*/
                    Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SocialIcon(
                                  colors: Color(0xfff5af19),
                                  iconData: CustomIcons.facebook,
                                  onPressed: () {},
                                ),
                                SocialIcon(
                                  colors: Color(0xfff5af19),
                                  iconData: CustomIcons.googlePlus,
                                  onPressed: () {
                                    signInWithGoogle().whenComplete(() {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return MainScreen();
                                          },
                                        ),
                                      );
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("New User?",
                                  style: TextStyle(
                                      fontFamily: "Poppins-Medium",
                                      fontSize:
                                          ScreenUtil.getInstance().setSp(26))),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return SignUp();
                                  }));
                                },
                                child: Text("Sign Up",
                                    style: TextStyle(
                                        color: Color(0xfff5af19),
                                        fontFamily: "Poppins-Bold")),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "You are organisation?",
                                style: TextStyle(
                                    fontFamily: "Poppins-Medium",
                                    fontSize:
                                        ScreenUtil.getInstance().setSp(26)),
                              ),
                              InkWell(
                                onTap: () {
                                  organisationSignup();
                                },
                                child: Text("Click Here",
                                    style: TextStyle(
                                        color: Color(0xfff5af19),
                                        fontFamily: "Poppins-Bold")),
                              )
                            ],
                          )
                        ])
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
