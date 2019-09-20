import 'package:LadyBug/Screens/Oraganization_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix1;
import 'package:flutter/widgets.dart';
import 'package:flutter/widgets.dart' as prefix0;

class OrganizationList extends StatelessWidget {
  final String currentUserID;
  OrganizationList(this.currentUserID);
  Future getYourOrganizationList() async {
    DocumentSnapshot ds = await Firestore.instance
        .collection("UserOrganization")
        .document(currentUserID)
        .get();
    if (ds == null) return null;
    return ds;
  }

  Future<DocumentSnapshot> getOrgName(String oid) async {
    DocumentSnapshot ds =
        await Firestore.instance.collection("Organization").document(oid).get();
    return ds;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Organizations",
            style: const TextStyle(
              fontSize: 22,
              fontFamily: 'Manjari',
            )),
      ),
      body: FutureBuilder(
        future: getYourOrganizationList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Container();
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data.toString() != "") {
              int length1 = snapshot?.data['member']?.length;
              int length2 = snapshot?.data['follower']?.length;
              return ListView.builder(
                  itemCount: length1 + length2 + 2,
                  itemBuilder: (context, index) {
                    if (index == 0)
                      return Container(
                          padding: EdgeInsets.all(10),
                          color: Colors.blue,
                          child: Text(
                            "Your organizations",
                            style: const TextStyle(
                                fontFamily: 'Segoeu',
                                color: Colors.white,
                                fontSize: 18),
                          ));
                    else if (index == length1 + 1)
                      return Container(
                          padding: EdgeInsets.all(10),
                          color: Colors.blue,
                          child: Text("Followed",
                              style: const TextStyle(
                                  fontFamily: 'Segoeu',
                                  color: Colors.white,
                                  fontSize: 18)));
                    else if (index <= length1)
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return OrganizationScreen(currentUserID,
                                    snapshot.data['member'][index - 1]);
                              },
                            ),
                          );
                        },
                        child: FutureBuilder(
                            future:
                                getOrgName(snapshot.data['member'][index - 1]),
                            builder: (context, _snapshot) {
                              if (_snapshot.connectionState ==
                                  ConnectionState.waiting)
                                return Container();
                              else if (_snapshot.connectionState ==
                                  ConnectionState.done)
                                return Container(
                                    padding: EdgeInsets.all(10),
                                    color: ((index - 1) % 2 == 0)
                                        ? Colors.white
                                        : Colors.grey[100],
                                    child: Text(
                                      _snapshot.data['name'],
                                      style: const TextStyle(
                                          fontFamily: 'Segoeu',
                                          color: Colors.black,
                                          fontSize: 17),
                                    ));
                              else
                                return Container();
                            }),
                      );
                    else
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return OrganizationScreen(
                                    currentUserID,
                                    snapshot.data['follower']
                                        [index - length1 - 2]);
                              },
                            ),
                          );
                        },
                        child: FutureBuilder(
                            future: getOrgName(
                                snapshot.data['follower'][index - length1 - 2]),
                            builder: (context, _snapshot) {
                              if (_snapshot.connectionState ==
                                  ConnectionState.waiting)
                                return Container();
                              else if (_snapshot.connectionState ==
                                  ConnectionState.done)
                                return Container(
                                    padding: EdgeInsets.all(10),
                                    color: ((index - length1 - 2) % 2 == 0)
                                        ? Colors.white
                                        : Colors.grey[100],
                                    child: Text(_snapshot.data['name'],
                                        style: const TextStyle(
                                            fontFamily: 'Segoeu',
                                            color: Colors.black,
                                            fontSize: 17)));
                              else
                                return Container();
                            }),
                      );
                  });
            } else
              return Text("Nothing to show here");
          }
        },
      ),
    );
  }
}
