import 'package:LadyBug/Customize/MultiLanguage.dart';
import 'package:LadyBug/Screens/Profile_screen.dart';
import 'package:LadyBug/Screens/chat_screen.dart';
import 'package:LadyBug/Widgets/ItemtypeList.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemInformationScreen extends StatefulWidget {
  final Map<String, dynamic> item;
  final String currentUserId;
  ItemInformationScreen(this.item, this.currentUserId);
  @override
  ItemInformationSCreenState createState() {
    // TODO: implement createState
    return ItemInformationSCreenState(item, this.currentUserId);
  }
}

class ItemInformationSCreenState extends State<ItemInformationScreen> {
  final Map<String, dynamic> item;
  final String currentUserId;
  ItemInformationSCreenState(this.item, this.currentUserId);
  String owner;
  Map<String, dynamic> ownerProfile;
  /*
  Future<DocumentSnapshot> getItem() async {
    DocumentSnapshot ds =
        await Firestore.instance.collection("Item").document(itemId).get();
    return ds;
  }
 Future<DocumentSnapshot> getIDonatedtem() async {
    DocumentSnapshot ds =
        await Firestore.instance.collection("Donate").document(itemId).get();
    return ds;
  }
  */
  Future getOwner(String owner) async {
    QuerySnapshot qs = await Firestore.instance
        .collection("User")
        .where('uid', isEqualTo: owner)
        .getDocuments();
    return qs.documents;
  }

  List<Widget> _getChip(List<dynamic> tags) {
    List listings = new List<Widget>();
    for (int i = 0; i < tags.length; ++i) {
      listings
          .add(new Chip(label: Text(itemTypeListMap[setLanguage][tags[i]])));
    }
    return listings;
  }

  @override
  void setState(fn) {
    _getChip;
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            actions: <Widget>[
              RaisedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Chat(
                                  peerId: owner,
                                  peerAvatar: ownerProfile['imageurl'],
                                )));
                  },
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.contact_mail),
                    SizedBox(
                      width: 5,
                    ),
                    Text(captions[setLanguage]["contact"])
                  ])),
            ],
            title: Text(
              captions[setLanguage]["item"],
            )),
        body: ListView(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CachedNetworkImage(
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              imageUrl: item['imageurl'],
              fit: BoxFit.contain,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Text(item["title"],
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  )),
            ),
            FutureBuilder(
                future: getOwner(item['owner']),
                builder: (context, _snapshot) {
                  if (_snapshot.connectionState == ConnectionState.waiting)
                    return Container();
                  if (_snapshot.connectionState == ConnectionState.done) {
                    owner = item['owner'];
                    ownerProfile = Map.from(_snapshot.data[0].data);
                    return Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Container(
                            child: Row(children: [
                          Text(captions[setLanguage]['owner'] + ": ",
                              style: TextStyle(color: Colors.black)),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ProfileScreen(
                                        currentUserId, item['owner']);
                                  },
                                ),
                              );
                            },
                            child: Text(_snapshot.data[0].data['name'],
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                )),
                          )
                        ])));
                  }
                }),
            SizedBox(
              height: 10,
            ),
            (item["exp"] == null)
                ? Container()
                : Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Text(
                      captions[setLanguage]['exp'] +
                          ': ' +
                          DateFormat('dd/MM/yyyy').format(
                              DateTime.fromMillisecondsSinceEpoch(item["exp"])),
                      maxLines: null,
                      overflow: TextOverflow.clip,
                    )),
            Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Row(children: [
                  Icon(
                    Icons.location_on,
                    size: 14,
                  ),
                  Text(
                    item["address"],
                    overflow: TextOverflow.clip,
                  )
                ])),
            SizedBox(
              height: 10,
            ),
            Divider(
              indent: 10,
              endIndent: 10,
            ),
            Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  item["describe"],
                  overflow: TextOverflow.clip,
                )),
            Divider(
              indent: 10,
              endIndent: 10,
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  "Tags",
                )),
            Wrap(
              children: _getChip(item["tag"]),
            )

            /*   Flexible(
                        child: Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data["tag"].length,
                              itemBuilder: (context, index) {
                                return Chip(
                                  label: Text(snapshot.data["tag"][index]),
                                );
                              },
                            ))),*/
          ],
        ));
  }
}
