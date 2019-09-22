import 'package:LadyBug/Screens/AddCampaign_screen.dart';
import 'package:LadyBug/Screens/AddPostForOganization_screen.dart';
import 'package:LadyBug/Widgets/Main_Screen/CampaignCard/CampaignCard.dart';
import 'package:LadyBug/Widgets/Main_Screen/Card_View/Card_View.dart';
import 'package:LadyBug/Widgets/Main_Screen/Organization_screen/Oraganization_Top.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;

class OrganizationScreen extends StatefulWidget {
  final String currentUserID, oid;
  bool canEdit;
  OrganizationScreen(this.currentUserID, this.oid);
  @override
  _OrganizationScreen createState() => _OrganizationScreen(currentUserID, oid);
}

class _OrganizationScreen extends State<OrganizationScreen> {
  final String oid, currentUserID;

  _OrganizationScreen(this.currentUserID, this.oid);
  Future getOrganizationInfomation() async {
    // print("id here"+oid);
    DocumentSnapshot docs =
        await Firestore.instance.collection('Organization').document(oid).get();
    return docs.data;
  }

  Future<bool> isMember() async {
    DocumentSnapshot qs = await Firestore.instance
        .collection('UserOrganization')
        .document(currentUserID)
        .get();
    return qs.data['member'].contains(oid);
  }

  Future<bool> following() async {
    DocumentSnapshot qs = await Firestore.instance
        .collection('UserOrganization')
        .document(currentUserID)
        .get();
    return qs.data['follower'].contains(oid);
  }

  Future getPosts() async {
    QuerySnapshot qs = await Firestore.instance
        .collection('Post')
        .where('owner(oid)', isEqualTo: oid)
        .where('type', isEqualTo: 'post')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    return qs.documents;
  }

  Future getCampaigns() async {
    QuerySnapshot qs = await Firestore.instance
        .collection('Campaign')
        .where("organizer", arrayContains: oid)
        .orderBy('timestamp', descending: true)
        .getDocuments();
    return qs.documents;
  }

  @override
  void initState() {
    print(getOrganizationInfomation());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              actions: <Widget>[FollowButton(currentUserID, oid)],
              bottom: TabBar(tabs: [
                Tab(icon: Icon(Icons.home)),
                Tab(icon: Icon(Icons.flag)),
              ]),
              title: Text(
                "Organization",
              ),
            ),
            floatingActionButton: FutureBuilder(
              future: isMember(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Container();
                if (snapshot.connectionState == ConnectionState.done)
                  return (snapshot.data == true)
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                              FloatingActionButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return AddCampaign(oid);
                                        },
                                      ),
                                    );
                                  },
                                  child: Icon(
                                    Icons.flag,
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              FloatingActionButton(
                                  heroTag: "btn2",
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return AddPostOrganization(
                                              currentUserID, oid);
                                        },
                                      ),
                                    );
                                  },
                                  child: Icon(
                                    Icons.create,
                                  ))
                            ])
                      : FloatingActionButton(
                          heroTag: "btn1",
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return AddCampaign(oid);
                                },
                              ),
                            );
                          },
                          child: Icon(
                            Icons.message,
                          ));
              },
            ),
            body: TabBarView(children: [
              FutureBuilder(
                future: (getPosts()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: LinearProgressIndicator());
                  else if (snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                        itemCount: (snapshot?.data?.length ?? 0) + 1,
                        itemBuilder: (context, index) {
                          if (index == 0)
                            return FutureBuilder(
                                future: getOrganizationInfomation(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: LinearProgressIndicator());
                                  } else {
                                    return Container(
                                      child: OrganizationTop(
                                          snapshot.data, currentUserID, oid),
                                    );
                                  }
                                });
                          else
                            return Padding(
                                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                child: Card_View(
                                    snapshot.data[index - 1].documentID,
                                    snapshot.data[index - 1].data,
                                    currentUserID));
                        });
                  }
                },
              ),
              FutureBuilder(
                  future: (getCampaigns()),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Center(child: LinearProgressIndicator());
                    else {
                      return ListView.builder(
                          itemCount: snapshot?.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            return Padding(
                                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                child: CampaignCard(
                                    snapshot.data[index].data,
                                    snapshot.data[index].documentID,
                                    currentUserID));
                          });
                    }
                  })
            ])));
  }
}

class FollowButton extends StatefulWidget {
  final String currentUserID, oid;
  FollowButton(this.currentUserID, this.oid);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FollowButtonState(currentUserID, oid);
  }
}

class FollowButtonState extends State<FollowButton> {
  final String currentUserID, oid;
  FollowButtonState(this.currentUserID, this.oid);
  Future<bool> isMember() async {
    DocumentSnapshot qs = await Firestore.instance
        .collection('UserOrganization')
        .document(currentUserID)
        .get();
    return qs.data['member'].contains(oid);
  }

  Future<bool> following() async {
    DocumentSnapshot qs = await Firestore.instance
        .collection('UserOrganization')
        .document(currentUserID)
        .get();
    return qs.data['follower'].contains(oid);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
        future: isMember(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Container();
          if (snapshot.connectionState == ConnectionState.done)
            return (snapshot.data == false)
                ? FutureBuilder(
                    future: following(),
                    builder: (context, _snapshot) {
                      if (_snapshot.connectionState == ConnectionState.waiting)
                        return Container();
                      if (_snapshot.connectionState == ConnectionState.done)
                        return (_snapshot.data == false)
                            ? RaisedButton(
                                onPressed: () async {
                                  DocumentSnapshot qs = await Firestore.instance
                                      .collection('UserOrganization')
                                      .document(currentUserID)
                                      .get();
                                  List<dynamic> list = List.from(
                                      qs.data['follower'],
                                      growable: true);

                                  list.add(oid);
                                  print(list.toString());
                                  Firestore.instance
                                      .collection("UserOrganization")
                                      .document(currentUserID)
                                      .updateData({'follower': list});
                                  setState(() {});
                                },
                                child: Text("Follow!"),
                              )
                            : RaisedButton(
                                onPressed: () async {
                                  DocumentSnapshot qs = await Firestore.instance
                                      .collection('UserOrganization')
                                      .document(currentUserID)
                                      .get();
                                  List<dynamic> list = List.from(
                                      qs.data['follower'],
                                      growable: true);
                                  list.remove(oid);
                                  Firestore.instance
                                      .collection("UserOrganization")
                                      .document(currentUserID)
                                      .updateData({'follower': list});
                                  setState(() {});
                                },
                                child: Text("Followed"),
                              );
                    })
                : Container();
        });
  }
}
