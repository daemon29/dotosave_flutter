import 'package:LadyBug/Screens/EditProfile_screen.dart';
import 'package:LadyBug/Widgets/Main_Screen/CircleAvatar.dart';
import 'package:LadyBug/Widgets/SlideRightRoute.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Proflie_Top extends StatefulWidget {
  final String currentuid;
  final Map<String, dynamic> user;
  Proflie_Top(this.user, this.currentuid);
  @override
  _Proflie_Top createState() => _Proflie_Top(this.user, this.currentuid);
}

class _Proflie_Top extends State<Proflie_Top> {
  final String currentuid;
  final Map<String, dynamic> user;
  _Proflie_Top(this.user, this.currentuid);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        child: Column(children: <Widget>[
      SizedBox(
          height: 220,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              Positioned(
                  top: 0,
                  left: 0,
                  child: InkWell(
                    onTap: () {},
                    child: SizedBox(
                        height: 170.0,
                        width: MediaQuery.of(context).size.width,
                        child: (user['backgroundurl'] == "")
                            ? Container()
                            : CachedNetworkImage(
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                imageUrl: user['backgroundurl'],
                                fit: BoxFit.cover)),
                  )),
              Positioned(
                left: 10,
                top: 90,
                child: MyCircleAvatar(user['uid'], user['imageurl'], 120.0,
                    currentuid, false, false),
              ),
              (currentuid == user['uid'])
                  ? Positioned(
                      bottom: 4,
                      right: 5,
                      child: RaisedButton(
                        color: Colors.blue,
                        onPressed: () {
                          Navigator.push(
                              context,
                              SlideRightRoute(
                                  page: EditProfileScreen(currentuid)));
                        },
                        child: Text(
                          "Edit profile",
                          style: TextStyle( fontFamily: 'Segoeu',color: Colors.white, fontSize: 13),
                        ),
                      ),
                    )
                  : Container()
            ],
          )),
      SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                user["name"],
                style: TextStyle(
                    fontFamily: 'Segoeu',
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ))),
      SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: (user['nickname'] == '')
                  ? Container()
                  : Text(
                      '(' + user["nickname"] + ')',
                      style: TextStyle(
                          fontFamily: 'Segoeu', color: Colors.grey[700]),
                      overflow: TextOverflow.clip,
                    ))),
      SizedBox(
        height: 10,
      ),
      SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                user["bio"],
                style: TextStyle(fontFamily: 'Segoeu', color: Colors.black),
                maxLines: 6,
                overflow: TextOverflow.clip,
              ))),
      SizedBox(
        height: 10,
      ),
      Divider(
        color: Colors.blue,
      )
    ]));
  }
}
