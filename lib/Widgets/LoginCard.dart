import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginForms extends StatefulWidget {
  String email, password;
  Function(String, String) callback;
  LoginForms(this.email, this.password, this.callback);

  @override
  LoginFormsState createState() => new LoginFormsState();
}

class LoginFormsState extends State<LoginForms> {
  String email, password;
  @override
  Widget build(BuildContext context) {
    return new Container(
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
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Login",
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
                email = value.trim();
                widget.callback(email, password);
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  hintText: "Type your email here",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
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
                password = value.trim();
                widget.callback(email, password);
              },
              obscureText: true,
              decoration: InputDecoration(
                  hintText: "Password . . .",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
            ),
            SizedBox(
              height: ScreenUtil.getInstance().setHeight(35),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  "Forgot Password?",
                  style: TextStyle(
                      fontFamily: "Poppins-Medium",
                      color: Colors.orange,
                      fontSize: ScreenUtil.getInstance().setSp(28)),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
