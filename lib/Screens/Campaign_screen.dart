import 'dart:core';

import 'package:LadyBug/Screens/Item_infomation_screen.dart';
import 'package:LadyBug/Screens/donate_screen_for_a_campagin.dart';
import 'package:LadyBug/Widgets/CommentBox.dart';
import 'package:LadyBug/Widgets/Comment_Card/Comment_Card.dart';
import 'package:LadyBug/Widgets/Main_Screen/Campaign_screen/Campaign_screen_top.dart';
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

  Future<bool> isMember() async {
    DocumentSnapshot qs = await Firestore.instance
        .collection('UserOrganization')
        .document(currentUserId)
        .get();
    return qs.data['member'].contains(campaign['organizer'][0]);
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
                    length: (snapshot.data == true) ? 3 : 2,
                    child: Scaffold(
                      appBar: AppBar(
                          bottom: TabBar(tabs: [
                            Tab(
                              icon: Icon(Icons.flag),
                              text: "Campaign",
                            ),
                            Tab(
                                icon: Icon(
                                  Icons.comment,
                                ),
                                text: "Comment"),
                            (snapshot.data == true)
                                ? Tab(
                                    icon: Icon(Icons.card_giftcard),
                                    text: "Donation",
                                  )
                                : null
                          ]),
                          actions: <Widget>[
                            (!campaign['needdonor'])
                                ? Container()
                                : RaisedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          SlideRightRoute(
                                              page: DonateCampaignScreen(
                                                  currentUserId: currentUserId,
                                                  cid: postID)));
                                    },
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.card_giftcard),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text("Donate!")
                                        ])),
                            (snapshot.data == false)
                                ? ((!campaign['needvol'])
                                    ? Container()
                                    : RaisedButton(
                                        onPressed: () {},
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.assistant),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text("Join us!")
                                            ])))
                                : Container()
                          ],
                          title: Text(
                            "",
                          )),
                      body: TabBarView(children: [
                        CampainScreenTop(campaign, currentUserId),
                        FutureBuilder(
                            future: getComment(),
                            builder: (context, _snapshot) {
                              if (_snapshot.connectionState ==
                                  ConnectionState.waiting)
                                return LinearProgressIndicator();
                              else if (_snapshot.connectionState ==
                                  ConnectionState.done)
                                return ListView.builder(
                                  itemCount: _snapshot?.data?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    return CommentCard(
                                        _snapshot.data[index].data,
                                        currentUserId);
                                  },
                                );
                            }),
                        (snapshot.data == true)
                            ? FutureBuilder(
                                future: getDonation(),
                                builder: (context, _snapshot) {
                                  if (_snapshot.connectionState ==
                                      ConnectionState.waiting)
                                    return LinearProgressIndicator();
                                  else if (_snapshot.connectionState ==
                                      ConnectionState.done)
                                    return ListView.builder(
                                      itemCount: _snapshot?.data?.length ?? 0,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Card(
                                              child: ListTile(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      SlideRightRoute(
                                                          page: ItemInformationScreen(
                                                              _snapshot
                                                                  .data[index]
                                                                  .data,
                                                              currentUserId)));
                                                },
                                                leading: SizedBox(
                                                  height: 80,
                                                  width: 80,
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        _snapshot.data[index]
                                                            ["imageurl"],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                title: Text(
                                                  _snapshot.data[index]
                                                      ['title'],
                                                  maxLines: null,
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                      color: Colors
                                                          .deepOrange[900]),
                                                ),
                                                subtitle: Text(
                                                  _snapshot.data[index]
                                                      ['describe'],
                                                  overflow: TextOverflow.clip,
                                                  maxLines: null,
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                isThreeLine: true,
                                              ),
                                            ));
                                      },
                                    );
                                })
                            : null
                      ]),
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
}
