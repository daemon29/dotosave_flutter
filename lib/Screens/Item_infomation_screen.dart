import 'package:LadyBug/Screens/Profile_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemInformationScreen extends StatefulWidget {
  final String itemId;
  final String currentUserId;
  ItemInformationScreen(this.itemId, this.currentUserId);
  @override
  ItemInformationSCreenState createState() {
    // TODO: implement createState
    return ItemInformationSCreenState(itemId, this.currentUserId);
  }
}

class ItemInformationSCreenState extends State<ItemInformationScreen> {
  final String itemId;
  final String currentUserId;
  ItemInformationSCreenState(this.itemId, this.currentUserId);

  Future<DocumentSnapshot> getItem() async {
    DocumentSnapshot ds =
        await Firestore.instance.collection("Item").document(itemId).get();
    return ds;
  }

  Future getOwner(String owner) async {
    QuerySnapshot qs = await Firestore.instance
        .collection("User")
        .where('uid', isEqualTo: owner)
        .getDocuments();
    return qs.documents;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getItem(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }
          if (snapshot.connectionState == ConnectionState.done) {
            // print(snapshot);
            return Scaffold(
                appBar: AppBar(
                    actions: <Widget>[
                      RaisedButton(
                          color: Colors.blue[400],
                          textColor: Colors.white,
                          onPressed: () {},
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            Icon(Icons.contact_mail),
                            SizedBox(
                              width: 5,
                            ),
                            Text("Contact")
                          ])),
                    ],
                    title: Text("Item",
                        style: const TextStyle(
                          fontSize: 22,
                          fontFamily: 'Manjari',
                        ))),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CachedNetworkImage(
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      imageUrl: snapshot.data['imageurl'],
                      fit: BoxFit.contain,
                    ),
                    Flexible(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.blue,
                        child: Text(snapshot.data["title"],
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                      ),
                    ),
                    Flexible(
                      child: FutureBuilder(
                          future: getOwner(snapshot.data['owner']),
                          builder: (context, _snapshot) {
                            if (_snapshot.connectionState ==
                                ConnectionState.waiting) return Container();
                            if (_snapshot.connectionState ==
                                ConnectionState.done)
                              return Padding(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: Row(children: [
                                    Text("Owner: ",
                                        style: TextStyle(color: Colors.black)),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return ProfileScreen(
                                                  currentUserId,
                                                  snapshot.data['owner']);
                                            },
                                          ),
                                        );
                                      },
                                      child: Text(
                                          _snapshot.data[0].data['name'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.blue)),
                                    )
                                  ]));
                          }),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Flexible(
                        child: Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                              'Exp: ' +
                                  DateFormat('dd MMMM yyyy').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          snapshot.data["exp"])),
                              overflow: TextOverflow.clip,
                            ))),
                    Flexible(
                        child: Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Row(children: [
                              Icon(
                                Icons.location_on,
                                size: 14,
                              ),
                              Flexible(
                                  child: Text(
                                snapshot.data["address"],
                                overflow: TextOverflow.clip,
                              ))
                            ]))),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: Colors.blue,
                    ),
                    Flexible(
                        child: Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                              snapshot.data["describe"],
                              overflow: TextOverflow.clip,
                            ))),
                    Divider(
                      color: Colors.blue,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Flexible(
                        child: Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                              "Tags",
                            ))),
                    Flexible(
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
                            ))),
                  ],
                ));
          }
        });
  }
}
