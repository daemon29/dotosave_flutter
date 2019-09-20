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
                    Positioned(
                        bottom: 0,
                        left: 0,
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Container(
                              color: Colors.blue.withOpacity(0.7),
                              child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(campaign['title'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ))),
                            ))),
                  ])),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Text(campaign["introduction"])),
              ),
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
            SizedBox(height: 10,)
            ],
          ),
        ));
  }
}
