import 'dart:core';

import 'package:LadyBug/Customize/MultiLanguage.dart';
import 'package:LadyBug/Screens/Item_infomation_screen.dart';
import 'package:LadyBug/Screens/JoinUs_screen.dart';
import 'package:LadyBug/Screens/RequestJoinCard.dart';
import 'package:LadyBug/Screens/donate_screen_for_a_campagin.dart';
import 'package:LadyBug/Widgets/CommentBox.dart';
import 'package:LadyBug/Widgets/Comment_Card/Comment_Card.dart';
import 'package:LadyBug/Widgets/Main_Screen/Campaign_screen/Campaign_screen_top.dart';
import 'package:LadyBug/Widgets/Main_Screen/Card_View/Owner.dart';
import 'package:LadyBug/Widgets/Main_Screen/CircleAvatar.dart';
import 'package:LadyBug/Widgets/SlideRightRoute.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CampaignScreen extends StatefulWidget {
  final String postID, currentUserId;
  final Map<String, dynamic> campaign;

  CampaignScreen(this.campaign, this.postID, this.currentUserId);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CampaignScreenState(this.campaign, this.postID, currentUserId);
  }
}

class CampaignScreenState extends State<CampaignScreen> {
  final String postID, currentUserId;
  final Map<String, dynamic> campaign;
  CampaignScreenState(this.campaign, this.postID, this.currentUserId);
  Future getComment() async {
    QuerySnapshot qs = await Firestore.instance
        .collection("Comment")
        .where('campaignId', isEqualTo: postID)
        .orderBy("timestamp", descending: true)
        .getDocuments();
    return qs.documents;
  }

  Future getUser() async {
    QuerySnapshot qs = await Firestore.instance
        .collection("Join")
        .where('cid', isEqualTo: postID)
        .getDocuments();
    return qs.documents;
  }

  Future getDonation() async {
    QuerySnapshot qs = await Firestore.instance
        .collection("Donation")
        .where('cid', isEqualTo: postID)
        .getDocuments();
    return qs.documents;
  }

  Future getRequest() async {
    QuerySnapshot qs = await Firestore.instance
        .collection("RequestJoin")
        .where('cid', isEqualTo: postID)
        .getDocuments();
    return qs.documents;
  }

  Future<bool> isMember() async {
    DocumentSnapshot qs = await Firestore.instance
        .collection('UserOrganization')
        .document(currentUserId)
        .get();
    return qs.data['member'].contains(campaign['organizer'][0]);
  }

  int getLength(bool ismenber, bool donate, bool vol) {
    if (ismenber && donate && vol) return 5;
    if (ismenber && vol) return 4;
    if (ismenber && donate) return 3;
    if (vol) return 3;
    return 2;
  }

  List<Widget> getTabbarItems(bool ismenber, bool donate, bool vol) {
    if (ismenber && donate && vol)
      return [
        Tab(
          icon: Icon(Icons.flag),
//text: "Campaign",
        ),
        Tab(
          icon: Icon(
            Icons.comment,
          ),
          //text: "Comment"
        ),
        Tab(
          icon: Icon(Icons.card_giftcard),
          //  text: "Donation",
        ),
        Tab(
          icon: Icon(Icons.people),
          //text: "Join",
        ),
        Tab(
          icon: Icon(Icons.assistant),
          //text: "Join request",
        )
      ];
    if (ismenber && vol)
      return [
        Tab(
          icon: Icon(Icons.flag),
//text: "Campaign",
        ),
        Tab(
          icon: Icon(
            Icons.comment,
          ),
          //text: "Comment"
        ),
        Tab(
          icon: Icon(Icons.people),
          //text: "Join",
        ),
        Tab(
          icon: Icon(Icons.assistant),
          //text: "Join request",
        )
      ];
    if (ismenber && donate)
      return [
        Tab(
          icon: Icon(Icons.flag),
//text: "Campaign",
        ),
        Tab(
          icon: Icon(
            Icons.comment,
          ),
          //text: "Comment"
        ),
        Tab(
          icon: Icon(Icons.card_giftcard),
          //  text: "Donation",
        )
      ];
    if (vol)
      return [
        Tab(
          icon: Icon(Icons.flag),
//text: "Campaign",
        ),
        Tab(
          icon: Icon(
            Icons.comment,
          ),
          //text: "Comment"
        ),
        Tab(
          icon: Icon(Icons.people),
          //text: "Join",
        ),
      ];
    return [
      Tab(
        icon: Icon(Icons.flag),
        //text: "Campaign",
      ),
      Tab(
        icon: Icon(
          Icons.comment,
        ),
        //text: "Comment"
      ),
    ];
  }

  TabBarView getTabBarView(bool ismenber, bool donate, bool vol) {
    if (ismenber && donate && vol)
      return TabBarView(
        children: <Widget>[
          CampainScreenTop(campaign, currentUserId),
          commentTab(),
          getDonationTab(),
          getPeopleTab(),
          getRequestTab()
        ],
      );
    if (ismenber && vol)
      return TabBarView(
        children: <Widget>[
          CampainScreenTop(campaign, currentUserId),
          commentTab(),
          getPeopleTab(),
          getRequestTab()
        ],
      );
    if (ismenber && donate)
      return TabBarView(
        children: <Widget>[
          CampainScreenTop(campaign, currentUserId),
          commentTab(),
          getDonationTab(),
        ],
      );
    if (vol)
      return TabBarView(
        children: <Widget>[
          CampainScreenTop(campaign, currentUserId),
          commentTab(),
          getPeopleTab(),
        ],
      );
    return TabBarView(
      children: <Widget>[
        CampainScreenTop(campaign, currentUserId),
        commentTab()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: isMember(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Container();
              if (snapshot.connectionState == ConnectionState.done)
                return DefaultTabController(
                    length: getLength(snapshot.data, campaign['needdonor'],
                        campaign['needvol']),
                    child: Scaffold(
                      appBar: AppBar(
                          bottom: TabBar(
                              tabs: getTabbarItems(snapshot.data,
                                  campaign['needdonor'], campaign['needvol'])),
                          actions: <Widget>[
                            (!campaign['needdonor'])
                                ? Container()
                                : IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          SlideRightRoute(
                                              page: DonateCampaignScreen(
                                                  currentUserId: currentUserId,
                                                  cid: postID)));
                                    },
                                    splashColor: Colors.deepOrangeAccent[500],
                                    icon: Icon(Icons.card_giftcard,
                                        color: Colors.deepOrange[700]),
                                    tooltip: captions[setLanguage]["donate!"],
                                  ),
                            (snapshot.data == false)
                                ? ((!campaign['needvol'])
                                    ? Container()
                                    : IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              SlideRightRoute(
                                                  page: JoinUsScreen(
                                                      postID, currentUserId)));
                                        },
                                        splashColor:
                                            Colors.deepOrangeAccent[500],
                                        icon: Icon(
                                          Icons.assistant,
                                          color: Colors.deepOrange[700],
                                        ),
                                        tooltip: captions[setLanguage]
                                            ["joinus!"]))
                                : Container()
                          ],
                          title: Text(
                            captions[setLanguage]["campaign"],
                          )),
                      body: getTabBarView(snapshot.data, campaign['needdonor'],
                          campaign['needvol']),
                      floatingActionButton: FloatingActionButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return CommentBox(currentUserId, postID, true);
                              },
                            ),
                          );
                        },
                        child: Icon(
                          Icons.add_comment,
                          color: Colors.white,
                        ),
                      ),
                    ));
            }));
  }

  Widget commentTab() {
    return FutureBuilder(
        future: getComment(),
        builder: (context, _snapshot) {
          if (_snapshot.connectionState == ConnectionState.waiting)
            return Container();
          else if (_snapshot.connectionState == ConnectionState.done)
            return ListView.builder(
              itemCount: _snapshot?.data?.length ?? 0,
              itemBuilder: (context, index) {
                return Padding(
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                    child:
                        CommentCard(_snapshot.data[index].data, currentUserId));
              },
            );
        });
  }

  Widget getDonationTab() {
    return FutureBuilder(
        future: getDonation(),
        builder: (context, _snapshot) {
          if (_snapshot.connectionState == ConnectionState.waiting)
            return LinearProgressIndicator();
          else if (_snapshot.connectionState == ConnectionState.done)
            return ListView.builder(
              itemCount: _snapshot?.data?.length ?? 0,
              itemBuilder: (context, index) {
                return Padding(
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                    child: Card(
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              SlideRightRoute(
                                  page: ItemInformationScreen(
                                      _snapshot.data[index].data,
                                      currentUserId)));
                        },
                        leading: SizedBox(
                          height: 80,
                          width: 80,
                          child: CachedNetworkImage(
                            imageUrl: _snapshot.data[index]["imageurl"],
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          _snapshot.data[index]['title'],
                          maxLines: null,
                          overflow: TextOverflow.clip,
                          style: TextStyle(color: Colors.deepOrange[900]),
                        ),
                        subtitle: Text(
                          _snapshot.data[index]['describe'],
                          overflow: TextOverflow.clip,
                          maxLines: null,
                          style: TextStyle(color: Colors.black),
                        ),
                        isThreeLine: true,
                      ),
                    ));
              },
            );
        });
  }

  Widget getPeopleTab() {
    return FutureBuilder(
      future: getUser(),
      builder: (context, _snapshot) {
        if (_snapshot.connectionState == ConnectionState.waiting)
          return Container();
        else if (_snapshot.connectionState == ConnectionState.done)
          return Padding(
              padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
              child: ListView.builder(
                  itemCount: _snapshot?.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    return FutureBuilder(
                      future: Firestore.instance
                          .collection("User")
                          .document(_snapshot.data[index]['uid'])
                          .get(),
                      builder: (context, user) {
                        if (user.connectionState == ConnectionState.waiting)
                          return Container();
                        else if (user.connectionState == ConnectionState.done)
                          return Card(
                              child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    children: <Widget>[
                                      MyCircleAvatar(
                                          user.data['uid'],
                                          user.data['imageurl'],
                                          60.0,
                                          currentUserId,
                                          true,
                                          false),
                                      Post_Owner(user.data['name'],
                                          user.data['uid'], currentUserId)
                                    ],
                                  )));
                      },
                    );
                  }));
      },
    );
  }

  Widget getRequestTab() {
    return FutureBuilder(
      future: getRequest(),
      builder: (context, _snapshot) {
        if (_snapshot.connectionState == ConnectionState.waiting)
          return Container();
        else if (_snapshot.connectionState == ConnectionState.done)
          return Padding(
              padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
              child: ListView.builder(
                  itemCount: _snapshot?.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    return Card(
                        child: Dismissible(
                            key: Key(index.toString()),
                            onDismissed: (direction) {
                              Firestore.instance
                                  .collection("RequestJoin")
                                  .document(_snapshot.data[index].documentID)
                                  .delete();
                              if (direction == DismissDirection.endToStart) {
                                Firestore.instance
                                    .collection("Join")
                                    .document()
                                    .setData({
                                  'uid': _snapshot.data[index]['uid'],
                                  'cid': postID
                                });
                              }
                              setState(() {
                                _snapshot.data.removeAt(index);
                              });
                            },
                            background: Container(
                                color: Colors.red,
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.clear),
                                  ],
                                )),
                            secondaryBackground: Container(
                                color: Colors.green,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Icon(Icons.check),
                                  ],
                                )),
                            child: JoinCard(
                                _snapshot.data[index]['uid'],
                                currentUserId,
                                _snapshot.data[index]['introduction'])));
                  }));
      },
    );
  }
}
