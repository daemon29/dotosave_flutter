import 'dart:core';

import 'package:LadyBug/Customize/MultiLanguage.dart';
import 'package:LadyBug/Screens/AddCampaign_Notification.dart';
import 'package:LadyBug/Screens/Item_infomation_screen.dart';
import 'package:LadyBug/Screens/JoinUs_screen.dart';
import 'package:LadyBug/Screens/RequestJoinCard.dart';
import 'package:LadyBug/Screens/donate_screen_for_a_campagin.dart';
import 'package:LadyBug/Widgets/CommentBox.dart';
import 'package:LadyBug/Widgets/Comment_Card/Comment_Card.dart';
import 'package:LadyBug/Widgets/Main_Screen/Campaign_screen/Campaign_screen_top.dart';
import 'package:LadyBug/Widgets/Main_Screen/Card_View/Card_View.dart';
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
  Stream<QuerySnapshot> getComment() {
    return Firestore.instance
        .collection("Comment")
        .where('campaignId', isEqualTo: postID)
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  Stream getUser() {
    return Firestore.instance
        .collection("Join")
        .where('cid', isEqualTo: postID)
        .snapshots();
  }

  Stream getDonation() {
    return Firestore.instance
        .collection("Donation")
        .where('cid', isEqualTo: postID)
        .snapshots();
  }

  Stream getNotification() {
    return Firestore.instance
        .collection("CampaignNotification")
        .where('campaign', isEqualTo: postID)
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getRequest() {
    return Firestore.instance
        .collection("RequestJoin")
        .where('cid', isEqualTo: postID)
        .snapshots();
  }

  Future<bool> isMember() async {
    DocumentSnapshot qs = await Firestore.instance
        .collection('UserOrganization')
        .document(currentUserId)
        .get();
    return qs.data['member'].contains(campaign['organizer'][0]);
  }

  int getLength(bool ismenber, bool donate, bool vol) {
    if (ismenber && donate && vol) return 6;
    if (ismenber && vol) return 5;
    if (ismenber && donate) return 4;
    if (vol) return 4;
    return 3;
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
            Icons.notifications,
          ),
          //text: "Comment"
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
            Icons.notifications,
          ),
          //text: "Comment"
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
            Icons.notifications,
          ),
          //text: "Comment"
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
            Icons.notifications,
          ),
          //text: "Comment"
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
          Icons.notifications,
        ),
        //text: "Comment"
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
          notificationTab(),
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
          notificationTab(),
          commentTab(),
          getPeopleTab(),
          getRequestTab()
        ],
      );
    if (ismenber && donate)
      return TabBarView(
        children: <Widget>[
          CampainScreenTop(campaign, currentUserId),
          notificationTab(),
          commentTab(),
          getDonationTab(),
        ],
      );
    if (vol)
      return TabBarView(
        children: <Widget>[
          CampainScreenTop(campaign, currentUserId),
          notificationTab(),
          commentTab(),
          getPeopleTab(),
        ],
      );
    return TabBarView(
      children: <Widget>[
        CampainScreenTop(campaign, currentUserId),
        notificationTab(),
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
                                tabs: getTabbarItems(
                                    snapshot.data,
                                    campaign['needdonor'],
                                    campaign['needvol'])),
                            actions: <Widget>[
                              (!campaign['needdonor'])
                                  ? Container()
                                  : IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            SlideRightRoute(
                                                page: DonateCampaignScreen(
                                                    currentUserId:
                                                        currentUserId,
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
                                                    page: JoinUsScreen(postID,
                                                        currentUserId)));
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
                        body: getTabBarView(snapshot.data,
                            campaign['needdonor'], campaign['needvol']),
                        floatingActionButton: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              (snapshot.data == true)
                                  ? FloatingActionButton(
                                      heroTag: "btn4",
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            SlideRightRoute(
                                                page: AddCampaign_Notification(
                                                    currentUserId,
                                                    campaign['organizer'][0],
                                                    postID)));
                                      },
                                      child: Icon(
                                        Icons.notifications_active,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Container(),
                              SizedBox(
                                height: 10,
                              ),
                              FloatingActionButton(
                                heroTag: "btn3",
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return CommentBox(
                                            currentUserId, postID, true);
                                      },
                                    ),
                                  );
                                },
                                child: Icon(
                                  Icons.add_comment,
                                  color: Colors.white,
                                ),
                              ),
                            ])));
            }));
  }

  Widget notificationTab() {
    return Column(children: [
      Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10),
        color: Colors.white,
        child: Text(
          captions[setLanguage]['notification'],
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 19),
        ),
      ),
      Expanded(
          child: StreamBuilder(
        stream: (getNotification()),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Container();
          else
            return ListView.builder(
                itemCount: snapshot?.data?.documents?.length ?? 0,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: EdgeInsets.only(top: 5, left: 5, right: 5),
                      child: Card_View(
                          snapshot.data.documents[index].documentID,
                          snapshot.data.documents[index].data,
                          currentUserId));
                });
        },
      ))
    ]);
  }

  Widget commentTab() {
    return Column(children: [
      Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10),
        color: Colors.white,
        child: Text(
          captions[setLanguage]['comment'],
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 19),
        ),
      ),
      Expanded(
          child: StreamBuilder(
              stream: getComment(),
              builder: (context, _snapshot) {
                if (!_snapshot.hasData)
                  return Container();
                else
                  /*
                if (_snapshot.connectionState == ConnectionState.waiting)
                  return Container();
                else if (_snapshot.connectionState == ConnectionState.done)*/
                  return ListView.builder(
                    itemCount: _snapshot?.data?.documents?.length ?? 0,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                          child: CommentCard(
                              _snapshot.data.documents[index].data,
                              currentUserId));
                    },
                  );
              }))
    ]);
  }

  Widget getDonationTab() {
    return Column(children: [
      Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10),
        color: Colors.white,
        child: Text(
          captions[setLanguage]['donate'],
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 19),
        ),
      ),
      Expanded(
          child: StreamBuilder(
              stream: getDonation(),
              builder: (context, _snapshot) {
                if (!_snapshot.hasData)
                  return Container();
                else
                  return ListView.builder(
                    itemCount: _snapshot?.data?.documents?.length ?? 0,
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
                                            _snapshot
                                                .data.documents[index].data,
                                            currentUserId)));
                              },
                              leading: SizedBox(
                                height: 80,
                                width: 80,
                                child: CachedNetworkImage(
                                  imageUrl: _snapshot.data.documents[index]
                                      ["imageurl"],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(
                                _snapshot.data.documents[index]['title'],
                                maxLines: null,
                                overflow: TextOverflow.clip,
                                style: TextStyle(color: Colors.deepOrange[900]),
                              ),
                              subtitle: Text(
                                _snapshot.data.documents[index]['describe'],
                                overflow: TextOverflow.clip,
                                maxLines: null,
                                style: TextStyle(color: Colors.black),
                              ),
                              isThreeLine: true,
                            ),
                          ));
                    },
                  );
              }))
    ]);
  }

  Widget getPeopleTab() {
    return Column(children: [
      Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10),
        color: Colors.white,
        child: Text(
          captions[setLanguage]['participants'],
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 19),
        ),
      ),
      Expanded(
          child: StreamBuilder(
              stream: getUser(),
              builder: (context, _snapshot) {
                if (!_snapshot.hasData)
                  return Container();
                else
                  return Padding(
                      padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                      child: ListView.builder(
                          itemCount: _snapshot?.data?.documents?.length ?? 0,
                          itemBuilder: (context, index) {
                            return FutureBuilder(
                              future: Firestore.instance
                                  .collection("User")
                                  .document(
                                      _snapshot.data.documents[index]['uid'])
                                  .get(),
                              builder: (context, user) {
                                if (user.connectionState ==
                                    ConnectionState.waiting)
                                  return Container();
                                else if (user.connectionState ==
                                    ConnectionState.done)
                                  return GestureDetector(
                                      child: Card(
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
                                                  Post_Owner(
                                                      user.data['name'],
                                                      user.data['uid'],
                                                      currentUserId,
                                                      false)
                                                ],
                                              ))));
                              },
                            );
                          }));
              }))
    ]);
  }

  Widget getRequestTab() {
    return Column(children: [
      Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10),
        color: Colors.white,
        child: Text(
          captions[setLanguage]['joinrequest'],
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 19),
        ),
      ),
      Expanded(
          child: StreamBuilder(
        stream: getRequest(),
        builder: (context, _snapshot) {
          if (!_snapshot.hasData)
            return Container();
          else
            return Padding(
                padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                child: ListView.builder(
                    itemCount: _snapshot?.data?.documents?.length ?? 0,
                    itemBuilder: (context, index) {
                      return Card(
                          child: Dismissible(
                              key: Key(index.toString()),
                              onDismissed: (direction) {
                                Firestore.instance
                                    .collection("RequestJoin")
                                    .document(_snapshot
                                        .data.documents[index].documentID)
                                    .delete();
                                if (direction == DismissDirection.endToStart) {
                                  Firestore.instance
                                      .collection("Join")
                                      .document()
                                      .setData({
                                    'uid': _snapshot.data.documents[index]
                                        ['uid'],
                                    'cid': postID
                                  });
                                }
                                setState(() {
                                  _snapshot.data.documents.removeAt(index);
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
                                  _snapshot.data.documents[index]['uid'],
                                  currentUserId,
                                  _snapshot.data.documents[index]
                                      ['introduction'])));
                    }));
        },
      ))
    ]);
  }
}
