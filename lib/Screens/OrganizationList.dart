import 'package:LadyBug/Customize/MultiLanguage.dart';
import 'package:LadyBug/Screens/Oraganization_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(tabs: [
              Tab(text: captions[setLanguage]["following"]),
              Tab(
                text: captions[setLanguage]["yours"],
              ),
            ]),
            title: Text(
              captions[setLanguage]["organizations"],
            ),
          ),
          body: FutureBuilder(
              future: getYourOrganizationList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Container();
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data.toString() != "") {
                    int length1 = snapshot?.data['member']?.length ?? 0;
                    int length2 = snapshot?.data['follower']?.length ?? 0;
                    return TabBarView(children: [
                      ListView.builder(
                          itemCount: length2,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return OrganizationScreen(currentUserID,
                                          snapshot.data['follower'][index]);
                                    },
                                  ),
                                );
                              },
                              child: FutureBuilder(
                                  future: getOrgName(
                                      snapshot.data['follower'][index]),
                                  builder: (context, _snapshot) {
                                    if (_snapshot.connectionState ==
                                        ConnectionState.waiting)
                                      return Container();
                                    else if (_snapshot.connectionState ==
                                        ConnectionState.done)
                                      return Container(
                                          padding: EdgeInsets.all(10),
                                          color: ((index) % 2 == 0)
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
                          }),
                      ListView.builder(
                          itemCount: length1,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return OrganizationScreen(currentUserID,
                                          snapshot.data['member'][index]);
                                    },
                                  ),
                                );
                              },
                              child: FutureBuilder(
                                  future: getOrgName(
                                      snapshot.data['member'][index]),
                                  builder: (context, _snapshot) {
                                    if (_snapshot.connectionState ==
                                        ConnectionState.waiting)
                                      return Container();
                                    else if (_snapshot.connectionState ==
                                        ConnectionState.done)
                                      return Container(
                                          padding: EdgeInsets.all(10),
                                          color: ((index) % 2 == 0)
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
                          }),
                    ]);
                  }
                }
              }),
        ));
  }
}
