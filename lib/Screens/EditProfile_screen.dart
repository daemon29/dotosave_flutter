import 'package:LadyBug/Widgets/Main_Screen/CircleAvatar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditProfileScreen extends StatelessWidget {
  final String uid;
  EditProfileScreen(this.uid);
  Future getUserInformation() async {
    DocumentSnapshot docs =
        await Firestore.instance.collection('User').document(uid).get();
    return docs.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text("Edit Profile"),
        ),
        body: FutureBuilder(
            future: getUserInformation(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Container();
              if (snapshot.connectionState == ConnectionState.done)
                return Edit_Profile_Top(snapshot.data, uid);
            }));
  }
}

class Edit_Profile_Top extends StatelessWidget {
  final String currentuid;
  final Map<String, dynamic> user;
  Edit_Profile_Top(this.user, this.currentuid);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: ListView(children: <Widget>[
          SizedBox(
              height: 210,
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
                            child: Stack(children: [
                              (user['backgroundurl'] == "")
                                  ? Container()
                                  : Positioned(
                                      top: 0,
                                      left: 0,
                                      right: 0,
                                      child: CachedNetworkImage(
                                          placeholder: (context, url) =>
                                              CircularProgressIndicator(),
                                          imageUrl: user['backgroundurl'],
                                          fit: BoxFit.cover)),
                              Positioned(
                                top: 5,
                                right: 5,
                                child: Container(
                                    padding: EdgeInsets.all(5),
                                    color: Colors.grey[300],
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.grey[700],
                                    )),
                              )
                            ])),
                      )),
                  Positioned(
                      left: 10,
                      top: 90,
                      child: GestureDetector(
                        onTap: () {},
                        child: Stack(children: [
                          MyCircleAvatar(user['uid'], user['imageurl'], 120.0,
                              currentuid, false, false),
                          Positioned(
                            bottom: 5,
                            right: 5,
                            child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  border: Border.all(color: Colors.white),
                                  shape: BoxShape.circle,
                                ),
                                //color: Colors.grey[400],
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.grey[700],
                                )),
                          )
                        ]),
                      )),
                ],
              )),
          Padding(
              padding: EdgeInsets.only(left: 10),
              child: TextFormField(
                  //maxLength: 35,
                  enableInteractiveSelection: false,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(30),
                  ],
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                  initialValue: user["name"],
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: "Name here!"))),
          Divider(
            color: Colors.grey,
          ),
          Padding(
              padding: EdgeInsets.only(left: 10),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.edit,
                    color: Colors.grey[700],
                  ),
                  Text("Nickname",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold))
                ],
              )),
          Padding(
              padding: EdgeInsets.only(left: 10),
              child: TextFormField(
                  maxLength: 20,
                  enableInteractiveSelection: false,
                  initialValue: user["nickname"],
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Add your nickname."))),
          Divider(
            color: Colors.grey,
          ),
          Padding(
              padding: EdgeInsets.only(left: 10),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.edit,
                    color: Colors.grey[700],
                  ),
                  Text("Bio",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold))
                ],
              )),
          Padding(
              padding: EdgeInsets.only(left: 10),
              child: TextFormField(
                  maxLength: 160,
                  enableInteractiveSelection: false,
                  maxLines: 5,
                  initialValue: user["bio"],
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: "Add your bio."))),
          Divider(
            color: Colors.grey,
          ),
          RaisedButton(
            color: Colors.blue,
            onPressed: () {},
            child: Text("Save",style: TextStyle(color: Colors.white),),
          )
        ]));
  }
}
