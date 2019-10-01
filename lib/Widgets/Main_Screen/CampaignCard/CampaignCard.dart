import 'package:LadyBug/Customize/MultiLanguage.dart';
import 'package:LadyBug/Screens/Campaign_screen.dart';
import 'package:LadyBug/Widgets/SlideRightRoute.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CampaignCard extends StatelessWidget {
  final Map<String, dynamic> campaign;
  final currentUserId, postId;
  CampaignCard(this.campaign, this.postId, this.currentUserId);
  @override
  Widget build(BuildContext context) {
    // TODOs: implement build
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              SlideRightRoute(
                  page: CampaignScreen(campaign, postId, currentUserId)));
        },
        child: Card(
          //padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              SizedBox(
                  height: 230,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(children: [
                    Positioned(
                        top: 0,
                        bottom: 0,
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 230,
                            child: CachedNetworkImage(
                              imageUrl: campaign['imageurl'],
                              fit: BoxFit.cover,
                            ))),
                    /*Positioned(
                        bottom: 0,
                        left: 0,
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Container(
                              color: Colors.deepOrange[700].withOpacity(0.7),
                              child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(campaign['title'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ))),
                            ))),*/
                  ])),
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Text(campaign['title'],
                          style: TextStyle(
                            //color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          )))),
              Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Row(children: <Widget>[
                    (campaign['startDate'] != null &&
                            campaign['endDate'] != null)
                        ? Icon(
                            Icons.access_time,
                            size: 13,
                          )
                        : Container(),
                    (campaign['startDate'] == null)
                        ? Container()
                        : SizedBox(
                            child: Text(
                            DateFormat(" dd/MM/yyyy").format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    campaign['startDate'])),
                            style: TextStyle(fontSize: 12),
                          )),
                    (campaign['endDate'] == null)
                        ? Container()
                        : SizedBox(
                            child: Text(
                                (campaign['startDate'] == null)
                                    ? " " + captions[setLanguage]["until"]
                                    : " - " +
                                        DateFormat("dd/MM/yyyy").format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                campaign['endDate'])),
                                style: TextStyle(fontSize: 12))),
                  ])),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Text(campaign["introduction"])),
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ));
  }
}
