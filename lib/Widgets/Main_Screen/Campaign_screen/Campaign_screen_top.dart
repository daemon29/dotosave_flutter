import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//import 'package:intl/date_symbols.dart';
class CampainScreenTop extends StatelessWidget {
  final String campaignID;
  CampainScreenTop(this.campaignID);
  Future<DocumentSnapshot> getCampaign() async {
    DocumentSnapshot ds = await Firestore.instance
        .collection("Campaign")
        .document(campaignID)
        .get();
    return ds;
  }

  Future<DocumentSnapshot> getOrgName(String oid) async {
    DocumentSnapshot ds =
        await Firestore.instance.collection("Organization").document(oid).get();
    return ds;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getCampaign(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return CircularProgressIndicator();
          else if (snapshot.connectionState == ConnectionState.done)
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  child: CachedNetworkImage(
                    placeholder: (context, url) => CircularProgressIndicator(),
                    imageUrl: snapshot.data['imageurl'],
                    fit: BoxFit.contain,
                  ),
                ),
                Flexible(child: Text(snapshot.data["title"])),
                Flexible(child: Text(snapshot.data["address"])),
                Flexible(child: Text("Introduction")),
                Flexible(
                  child: Text(snapshot.data["introduction"]),
                ),
                Flexible(
                  child: Text("Organizers:"),
                ),
                Flexible(
                    child: ListView.builder(
                        itemCount: snapshot.data["organizer"].length ?? 0,
                        itemBuilder: (context, index) {
                          return FutureBuilder(
                              future:
                                  getOrgName(snapshot.data["organizer"][index]),
                              builder: (context, _snapshot) {
                                if (_snapshot.connectionState ==
                                    ConnectionState.waiting)
                                  return Container();
                                else if (_snapshot.connectionState ==
                                    ConnectionState.done)
                                  return Text(_snapshot.data['name']);
                                else
                                  return Container();
                              });
                        })),
                Row(
                  children: <Widget>[
                    Flexible(
                        child: RaisedButton(
                            onPressed: () {}, child: Text("Donate!"))),
                    Flexible(
                        child: RaisedButton(
                            onPressed: () {}, child: Text("Join us!")))
                  ],
                )
              ],
            );
        });
  }
}
