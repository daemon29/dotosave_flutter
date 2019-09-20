import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//import 'package:intl/date_symbols.dart';
class CampainScreenTop extends StatelessWidget {
  final Map<String, dynamic> campaign;
  CampainScreenTop(this.campaign);

  Future<DocumentSnapshot> getOrgName(String oid) async {
    DocumentSnapshot ds =
        await Firestore.instance.collection("Organization").document(oid).get();
    return ds;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        Stack(children: [
          CachedNetworkImage(
            placeholder: (context, url) => CircularProgressIndicator(),
            imageUrl: campaign['imageurl'],
            fit: BoxFit.contain,
          ),
          Positioned(
              left: 0,
              bottom: 0,
              child: SizedBox(
                child: Container(
                  padding: EdgeInsets.all(5),
                  width: MediaQuery.of(context).size.width,
                  color: Colors.blue.withOpacity(0.8),
                  child: Text(campaign["title"],
                      overflow: TextOverflow.clip,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                ),
              )),
        ]),
        (campaign['startDate'] == null)
            ? Container()
            : SizedBox(
                child: Text("From: " +
                    DateFormat("dd MMMM yyyy").format(
                        DateTime.fromMillisecondsSinceEpoch(
                            campaign['startDate'])))),
        (campaign['endDate'] == null)
            ? Container()
            : SizedBox(
                child: Text("To: " +
                    DateFormat("dd MMMM yyyy").format(
                        DateTime.fromMillisecondsSinceEpoch(
                            campaign['endDate'])))),
        SizedBox(
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Icon(
            Icons.location_on,
            size: 17,
            color: Colors.black,
          ),
          Flexible(child: Text(campaign["address"]))
        ])),
        Divider(
          color: Colors.blue,
        ),
        SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Container(
                //color: Colors.blue[400],
                padding: EdgeInsets.all(3),
                child: Text(
                  "Introduction",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black),
                ))),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Text(campaign["detail"])),
        ),
        Divider(
          color: Colors.blue,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Container(
              //color: Colors.blue[400],
              padding: EdgeInsets.all(3),
              child: Text("Organizers",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black))),
        ),
        SizedBox(
            child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: campaign["organizer"].length ?? 0,
                    itemBuilder: (context, index) {
                      return FutureBuilder(
                          future: getOrgName(campaign["organizer"][index]),
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
                    }))),
        Divider(
          color: Colors.blue,
        ),
      ],
    ));
  }
}
