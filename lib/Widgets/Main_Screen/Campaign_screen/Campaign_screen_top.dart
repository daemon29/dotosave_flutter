import 'package:LadyBug/Screens/Oraganization_screen.dart';
import 'package:LadyBug/Widgets/SlideRightRoute.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//import 'package:intl/date_symbols.dart';
class CampainScreenTop extends StatelessWidget {
  final uid;
  final Map<String, dynamic> campaign;

  CampainScreenTop(this.campaign, this.uid);

  Future<DocumentSnapshot> getOrgName(String oid) async {
    DocumentSnapshot ds =
        await Firestore.instance.collection("Organization").document(oid).get();
    return ds;
  }

  List<Widget> _getChip(List<dynamic> tags) {
    List listings = new List<Widget>();
    for (int i = 0; i < tags.length; ++i) {
      listings.add(new Chip(label: Text(tags[i])));
    }
    return listings;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView(
      children: <Widget>[
        Stack(children: [
          CachedNetworkImage(
            placeholder: (context, url) => LinearProgressIndicator(),
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
                  color: Colors.deepOrange[700].withOpacity(0.8),
                  child: Text(campaign["title"],
                      overflow: TextOverflow.clip,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      )),
                ),
              )),
        ]),
        Padding(
            padding: EdgeInsets.only(left: 10),
            child: Row(children: <Widget>[
              (campaign['startDate'] != null && campaign['endDate'] != null)
                  ? Icon(
                      Icons.access_time,
                      size: 17,
                    )
                  : Container(),
              (campaign['startDate'] == null)
                  ? Container()
                  : SizedBox(
                      child: Text(
                      DateFormat(" dd/MMM/yyyy").format(
                          DateTime.fromMillisecondsSinceEpoch(
                              campaign['startDate'])),
                    )),
              (campaign['endDate'] == null)
                  ? Container()
                  : SizedBox(
                      child: Text(
                      (campaign['startDate'] == null)
                          ? " Until"
                          : " - " +
                              DateFormat("dd/MMM/yyyy").format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      campaign['endDate'])),
                    )),
            ])),
        Padding(
            padding: EdgeInsets.only(left: 10),
            child: SizedBox(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Icon(
                Icons.location_on,
                size: 17,
                color: Colors.black,
              ),
              Flexible(child: Text(campaign["address"]))
            ]))),
        Divider(
          indent: 10,
          endIndent: 10,
        ),
        SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Container(
                padding: EdgeInsets.only(left: 10, bottom: 5),
                child: Text(
                  "Introduction",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w700),
                ))),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Text(campaign["detail"])),
        ),
        Divider(
          indent: 10,
          endIndent: 10,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 5),
              child: Text("Organizers",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w700))),
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
                              return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        SlideRightRoute(
                                            page: OrganizationScreen(uid,
                                                campaign["organizer"][index])));
                                  },
                                  child: Text(
                                    _snapshot.data['name'],
                                    maxLines: null,
                                    overflow: TextOverflow.clip,
                                  ));
                            else
                              return Container();
                          });
                    }))),
        Divider(
          indent: 10,
          endIndent: 10,
        ),
        (campaign['tag'] != null)
            ? Padding(
                padding: EdgeInsets.all(10),
                child: Wrap(
                  children: _getChip(campaign['tag']),
                ) /*Text(
            'Tags ' + campaign['tag'].toString(),
            maxLines: null,
            overflow: TextOverflow.clip,
          ),*/
                )
            : Container()
      ],
    ));
  }
}
