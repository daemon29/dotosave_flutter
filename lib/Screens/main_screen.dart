import 'package:LadyBug/Customize/MultiLanguage.dart';
import 'package:LadyBug/Screens/AddPost_screen.dart';
import 'package:LadyBug/Screens/donationmap_screen.dart';
import 'package:LadyBug/Screens/friend_screen.dart';
import 'package:LadyBug/Widgets/HomeDrawer.dart';
import 'package:LadyBug/Widgets/Main_Screen/CampaignCard/CampaignCard.dart';
import 'package:LadyBug/Widgets/Main_Screen/Card_View/Card_View.dart';
import 'package:LadyBug/Screens/donate_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Main_Screen extends StatefulWidget {
  final String currentUserId;
  Main_Screen({Key key, @required this.currentUserId}) : super(key: key);
  @override
  _Main_Screen createState() => new _Main_Screen(currentUserId: currentUserId);
}

GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

class _Main_Screen extends State<Main_Screen> {
  final String currentUserId;
  Firestore _firestore = Firestore.instance;

  _Main_Screen({Key key, @required this.currentUserId});

  Future getPosts() async {
    QuerySnapshot qs = await _firestore
        .collection('Post')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    return qs.documents;
  }

  Future getCampaigns() async {
    QuerySnapshot qs = await _firestore
        .collection('Campaign')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    return qs.documents;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: DefaultTabController(
            length: 2,
            child: Scaffold(
              key: _scaffoldKey,
              drawer: HomeDrawer(currentUserId),
              appBar: AppBar(
                title: Text(captions[setLanguage]['home']),
                bottom: TabBar(tabs: [
                  Tab(icon: Icon(Icons.flag)),
                  Tab(icon: Icon(Icons.forum)),
                ]),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.map,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return DonationMap(currentUserId);
                          },
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.card_giftcard,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return DonateScreen(
                              currentUserId: currentUserId,
                            );
                          },
                        ),
                      );
                    },
                  ),
                  IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return FriendScreen(
                                currentUserId: currentUserId,
                              );
                            },
                          ),
                        );
                      })
                ],
                leading: IconButton(
                  icon: const Icon(
                    Icons.menu,
                  ),
                  onPressed: () {
                    _scaffoldKey.currentState.openDrawer();
                  },
                ),
              ),
              body:
                  /*Column(children: [
        Flexible(
            child: ,*/
                  TabBarView(children: [
                FutureBuilder(
                    future: (getCampaigns()),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return SizedBox();
                      else {
                        return ListView.builder(
                            itemCount: snapshot?.data?.length ?? 0,
                            itemBuilder: (context, index) {
                              return Padding(
                                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                  child: CampaignCard(
                                      snapshot.data[index].data,
                                      snapshot.data[index].documentID,
                                      currentUserId));
                            });
                      }
                    }),
                FutureBuilder(
                  future: (getPosts()),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return SizedBox();
                    else {
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return Padding(
                                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                child: Card_View(
                                    snapshot.data[index].documentID,
                                    snapshot.data[index].data,
                                    currentUserId));
                          });
                    }
                  },
                )
              ]),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return AddPost(
                          currentUserId,
                        );
                      },
                    ),
                  );
                },
                child: Icon(
                  Icons.create,
                ),
              ),
              // bottomNavigationBar: MyBottomNavigationBar(context, currentUserId, 0),
            )));
  }
}
