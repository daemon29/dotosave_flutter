import 'package:LadyBug/Customize/MultiLanguage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:LadyBug/Widgets/SocialIcons.dart';
import 'package:LadyBug/Customize/CustomeIcon.dart';
import 'package:LadyBug/Screens/signup_screen.dart';
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

  void isSignIn() async {
    this.setState(() {
      isLoading = true;
    });
    prefs = await SharedPreferences.getInstance();
    isLoogedIn = await googleSignIn.isSignedIn();
    if (isLoogedIn) {
      prefix0.Navigator.pop(context);
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
      prefix0.Navigator.pop(context);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Main_Screen(
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
          'tag': []
        });
        Firestore.instance
            .collection("UserOrganization")
            .document(firebaseUser.uid)
            .setData({'member': [], 'follower': []});
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
      prefix0.Navigator.pop(context);

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
    return new WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomPadding: false,
          body: Padding(
            padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 40),
            child: ListView(
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
                      Text("dotosave",
                          style: TextStyle(
                              fontFamily: 'Manjari',
                              fontSize: ScreenUtil.getInstance().setSp(46),
                              letterSpacing: .6,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
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
                          captions[setLanguage]['login'],
                          style: TextStyle(
                              fontFamily: 'Segoeu',
                              fontSize: ScreenUtil.getInstance().setSp(40),
                              letterSpacing: .6),
                        ),
                        SizedBox(
                          height: ScreenUtil.getInstance().setHeight(30),
                        ),
                        Text(
                          "Email",
                          style: TextStyle(
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
                              hintText: captions[setLanguage]['emailhere'],
                              hintStyle: TextStyle(
                                  fontFamily: 'Segoeu', fontSize: 12.0)),
                        ),
                        SizedBox(
                          height: ScreenUtil.getInstance().setHeight(30),
                        ),
                        Text(captions[setLanguage]['password'],
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
                              hintText: captions[setLanguage]["passwordhere"],
                              hintStyle: TextStyle(fontSize: 12.0)),
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
                                  captions[setLanguage]["forgotpassword?"],
                                  style: TextStyle(
                                      color: Colors.deepOrange[700],
                                      fontSize:
                                          ScreenUtil.getInstance().setSp(28)),
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
                          RaisedButton(
                            onPressed: signinWithEmail,
                            child: Text(
                              captions[setLanguage]['signin'],
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
                        captions[setLanguage]['sociallogin'],
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'Segoeu',
                        ),
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
                              colors: Colors.black,
                              iconData: CustomIcons.facebook,
                              onPressed: () {},
                            ),
                            SocialIcon(
                              colors: Colors.black,
                              iconData: CustomIcons.googlePlus,
                              onPressed: startGoogleSignIn,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(captions[setLanguage]['newuser?'],
                              style: TextStyle(
                                  fontFamily: 'Segoeu',
                                  fontSize:
                                      ScreenUtil.getInstance().setSp(26))),
                          InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return SignUp();
                              }));
                            },
                            child: Text(captions[setLanguage]['signup'],
                                style: TextStyle(
                                  color: Colors.deepOrange[700],
                                )),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            captions[setLanguage]['youareorganization?'],
                            style: TextStyle(
                                fontSize: ScreenUtil.getInstance().setSp(26)),
                          ),
                          InkWell(
                            onTap: organisationSignup,
                            child: Text(captions[setLanguage]['clickhere'],
                                style: TextStyle(
                                  color: Colors.deepOrange[700],
                                  fontFamily: 'Segoeu',
                                )),
                          )
                        ],
                      )
                    ])
              ],
            ),
          ),
        ));
  }
}
