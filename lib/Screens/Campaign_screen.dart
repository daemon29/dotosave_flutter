import 'package:LadyBug/Widgets/Main_Screen/Campaign_screen/Campaign_screen_top.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class CampaignScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return null;
  }
}

class CampaignScreenState extends State<CampaignScreen> {
  final String postID;
  CampaignScreenState(this.postID);
  Future getComment() async {
    QuerySnapshot qs = await Firestore.instance
        .collection("Comment")
        .where('postId', isEqualTo: postID)
        .getDocuments();
    return qs.documents;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
      future: getComment(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return null;
        else if (snapshot.connectionState == ConnectionState.done)
          return Scaffold(
              appBar: AppBar(
                title: Text("Campaign"),
              ),
              body: ListView.builder(
                itemCount: snapshot.data.length ?? 1,
                itemBuilder: (context, index) {
                  if (index == 0) return CampainScreenTop(postID);
                },
              ));
      },
    );
  }
}
