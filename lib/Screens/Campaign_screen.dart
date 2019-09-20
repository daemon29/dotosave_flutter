import 'package:LadyBug/Widgets/CommentBox.dart';
import 'package:LadyBug/Widgets/Comment_Card/Comment_Card.dart';
import 'package:LadyBug/Widgets/Main_Screen/Campaign_screen/Campaign_screen_top.dart';
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getComment(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Container();
        else if (snapshot.connectionState == ConnectionState.done)
          return Scaffold(
            appBar: AppBar(
              actions: <Widget>[
                (!campaign['needdonor'])
                    ? Container()
                    : RaisedButton(
                        onPressed: () {},
                        textColor: Colors.white,
                        color: Colors.blue[400],
                        child: Text(
                          "Donate!", //style: TextStyle(fontSize: 11)
                        )),
                (!campaign['needvol'])
                    ? Container()
                    : RaisedButton(
                        textColor: Colors.white,
                        onPressed: () {},
                        color: Colors.blue[400],
                        child: Text(
                          "Join us!",
                          //style: TextStyle(fontSize: 11),
                        ))
              ],
              title: Text("",
                  style: const TextStyle(
                    fontSize: 22,
                    fontFamily: 'Manjari',
                  )),
            ),
            body: ListView.builder(
              itemCount: snapshot?.data?.length + 1 ?? 1,
              itemBuilder: (context, index) {
                if (index == 0)
                  return CampainScreenTop(campaign);
                else {
                  return CommentCard(
                      snapshot.data[index - 1].data, currentUserId);
                }
              },
            ),
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
              backgroundColor: Colors.blue,
            ),
          );
      },
    );
  }
}
