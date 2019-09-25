import 'package:LadyBug/Customize/MultiLanguage.dart';
import 'package:LadyBug/Screens/EditProfileOrganization%20_screen.dart';
import 'package:LadyBug/Widgets/Main_Screen/CircleAvatar.dart';
import 'package:LadyBug/Widgets/SlideRightRoute.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrganizationTop extends StatefulWidget {
  final String currentuid, oid;
  final Map<String, dynamic> organization;
  OrganizationTop(this.organization, this.currentuid, this.oid);
  @override
  _OrganizationTop createState() =>
      _OrganizationTop(this.organization, this.currentuid, this.oid);
}

class _OrganizationTop extends State<OrganizationTop> {
  final String currentuid, oid;
  final Map<String, dynamic> organization;
  _OrganizationTop(this.organization, this.currentuid, this.oid);
  @override
  void initState() {
    print(organization);
    super.initState();
  }

  Future<bool> isMember() async {
    DocumentSnapshot qs = await Firestore.instance
        .collection('UserOrganization')
        .document(currentuid)
        .get();
    return qs.data['member'].contains(oid);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
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
                        child: (organization['backgroundurl'] == "")
                            ? Container()
                            : CachedNetworkImage(
                                placeholder: (context, url) =>
                                    Center(child: LinearProgressIndicator()),
                                imageUrl: organization['backgroundurl'],
                                fit: BoxFit.cover)),
                  )),
              Positioned(
                left: 10,
                top: 90,
                child: MyCircleAvatar(organization['oid'],
                    organization['imageurl'], 120.0, currentuid, false, true),
              ),
              FutureBuilder(
                  future: isMember(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Container();
                    if (snapshot.connectionState == ConnectionState.done)
                      return (snapshot.data == true)
                          ? Positioned(
                              bottom: 4,
                              right: 5,
                              child: RaisedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      SlideRightRoute(
                                          page: EditProfileOrganizaationScreen(
                                              oid)));
                                },
                                child: Text(
                                  captions[setLanguage]["editprofile"],
                                  style: TextStyle(
                                      fontFamily: 'Segoeu', fontSize: 13),
                                ),
                              ),
                            )
                          : Container();
                  })
            ],
          )),
      SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                organization["name"],
                style: TextStyle(
                    fontFamily: 'Segoeu',
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ))),
      SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                captions[setLanguage]['address'] + ": " + organization["address"],
                style: TextStyle(fontFamily: 'Segoeu'),
                maxLines: null,
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
                organization["describe"],
                style: TextStyle(fontFamily: 'Segoeu', color: Colors.black),
                maxLines: null,
                overflow: TextOverflow.clip,
              ))),
      SizedBox(
        height: 10,
      ),
    ]));
  }
}
