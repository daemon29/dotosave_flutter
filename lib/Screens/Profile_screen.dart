import 'package:LadyBug/Screens/AddPost_screen.dart';
import 'package:LadyBug/Widgets/Main_Screen/Card_View/Card_View.dart';
import 'package:LadyBug/Widgets/Profile_Screen/Profile_Top.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProfileScreen extends StatefulWidget {
  final String currentUserID, uid;
  ProfileScreen(this.currentUserID, this.uid);
  @override
  _ProfileScreen createState() => _ProfileScreen(this.currentUserID, this.uid);
}

class _ProfileScreen extends State<ProfileScreen> {
  final String currentUserID, uid;
  //Map<String, dynamic> userProfile;
  _ProfileScreen(this.currentUserID, this.uid);
  @override
  void initState() {
    super.initState();
  }

  Future getUserInformation() async {
    DocumentSnapshot docs =
        await Firestore.instance.collection('User').document(uid).get();
    return docs.data;
  }

  Future getPosts() async {
    // print(uid + "fasjfkjawfkaewfke");
    QuerySnapshot qs = await Firestore.instance
        .collection('Post')
        .where("owner", isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .where('type', isEqualTo: 'status')
        .getDocuments();
    return qs.documents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile",
              style: const TextStyle(
                fontSize: 22,
                fontFamily: 'Manjari',
              )),
        ),
        body: FutureBuilder(
          future: (getPosts()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            else if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                  itemCount: (snapshot?.data?.length ?? 0) + 1,
                  itemBuilder: (context, index) {
                    if (index == 0)
                      return FutureBuilder(
                          future: getUserInformation(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              return Container(
                                child: Proflie_Top(
                                  snapshot.data,
                                  currentUserID,
                                ),
                              );
                            }
                          });
                    else
                      return Padding(
                          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: Card_View(snapshot.data[index - 1].documentID,
                              snapshot.data[index - 1].data, currentUserID));
                  });
            }
          },
        ),
        floatingActionButton: (uid == currentUserID)
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return AddPost(currentUserID);
                      },
                    ),
                  );
                },
                child: Icon(
                  Icons.create,
                  color: Colors.white,
                ))
            : null);
  }
}
