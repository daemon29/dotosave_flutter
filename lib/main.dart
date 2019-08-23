import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'Widgets/LoginCard.dart';
import 'Widgets/SocialIcons.dart';
import 'CustomeIcon/CustomeIcon.dart';
import 'sign_in.dart';
import 'main_screen.dart';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _email, _password;
  callback(email, password) {
    setState(() {
      _email = email;
      _password = password;
    });
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
        resizeToAvoidBottomPadding: true,
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
                    LoginCard(_email, _password, callback),
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
                                  onTap: () {},
                                  child: Center(
                                    child: Text(
                                      "SIGNIN",
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
                    Row(
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
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(40),
                    ),
                    Row(
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
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(30),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "New User? ",
                          style: TextStyle(fontFamily: "Poppins-Medium"),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Text("SignUp",
                              style: TextStyle(
                                  color: Color(0xfff5af19),
                                  fontFamily: "Poppins-Bold")),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
