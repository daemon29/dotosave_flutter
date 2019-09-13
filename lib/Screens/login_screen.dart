import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:LadyBug/Widgets/SocialIcons.dart';
import 'package:LadyBug/Customize/CustomeIcon.dart';
import 'package:LadyBug/Screens/signup_screen.dart';
import 'donate_screen.dart';
import 'package:flutter/services.dart';
import 'main_screen.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String email = "", password = "";
  FirebaseUser currentUser;
  SharedPreferences prefs;
  bool isLoading = false;
  bool isLoogedIn = false;
  @override
  void initState() {
    super.initState();
    isSignIn();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  Future signOutGoogleAcount() async {
    await googleSignIn.signOut();
  }

  void isSignIn() async {
    this.setState(() {
      isLoading = true;
    });
    prefs = await SharedPreferences.getInstance();
    isLoogedIn = await googleSignIn.isSignedIn();
    if (isLoogedIn) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Main_Screen(currentUserId: prefs.getString('uid'))));
    }
    this.setState(() {
      isLoading = false;
    });
  }

  Future<Null> signinWithEmail() async {
    this.setState(() {
      isLoading = true;
    });
    if (email == "" || password == "") {
      this.setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "Email or Password is invalid");
      return;
    }
    final FirebaseUser firebaseUser = await firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .catchError((onError) {
      this.setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "Login fail" + onError.toString());
      return;
    });
    if (firebaseUser != null) {
      Fluttertoast.showToast(msg: "Sign in Success");
      this.setState(() {
        isLoading = false;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DonateScreen(
                    currentUserId: firebaseUser.uid,
                  )));
    } else {
      Fluttertoast.showToast(msg: "Sign in fail");
      this.setState(() {
        isLoading = false;
      });
    }
  }

  // Future<Null> startFacebookSignIn() async {
  //   final FacebookLoginResult result =
  //       await facebookLogin.logInWithReadPermissions(['email']);
  //   FirebaseUser firebaseUser = await firebaseAuth.sign;

  // }

  Future<Null> startGoogleSignIn() async {
    prefs = await SharedPreferences.getInstance();
    this.setState(() {
      isLoading = true;
    });
    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    FirebaseUser firebaseUser =
        await firebaseAuth.signInWithCredential(credential);
    if (firebaseUser != null) {
      final QuerySnapshot result = await Firestore.instance
          .collection('User')
          .where('uid', isEqualTo: firebaseUser.uid)
          .getDocuments();
      print("here the length" + result.documents.length.toString());
      if (result.documents.length == 0) {
        // Update data to server if new user
        Firestore.instance
            .collection('User')
            .document(firebaseUser.uid)
            .setData({
          'name': firebaseUser.displayName,
          'imageurl': firebaseUser.photoUrl,
          'uid': firebaseUser.uid,
          'nickname': "",
          'bio': "",
          'backgroundurl': "",
          'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
        });
        currentUser = firebaseUser;
        await prefs.setString('uid', currentUser.uid);
        await prefs.setString('name', currentUser.displayName);
        await prefs.setString('imageurl', currentUser.photoUrl);
      } else {
        await prefs.setString('uid', (result.documents[0]['uid']));
        await prefs.setString('name', (result.documents[0]['nickname']));
        await prefs.setString('imageurl', (result.documents[0]['imageurl']));
      }
      Fluttertoast.showToast(msg: "Sign in Success");
      this.setState(() {
        isLoading = false;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Main_Screen(currentUserId: firebaseUser.uid)));
    } else {
      Fluttertoast.showToast(msg: "Sign in fail");
      this.setState(() {
        isLoading = false;
      });
    }
  }

  Future organisationSignup() async {
    const url = 'https://www.facebook.com/';
    if (await canLaunch(url)) {
      await launch(url);
    } else
      return;
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
                                      onTap: signinWithEmail,
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
                                  onPressed: startGoogleSignIn,
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
                                onTap: organisationSignup,
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
            ),
            Positioned(
              child: isLoading
                  ? Container(
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xfff5a623)),
                        ),
                      ),
                      color: Colors.white.withOpacity(0.8),
                    )
                  : Container(),
            ),
          ],
        ));
  }
}
