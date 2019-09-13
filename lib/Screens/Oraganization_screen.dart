import 'package:LadyBug/Widgets/Main_Screen/Card_View/Card_View.dart';
import 'package:LadyBug/Widgets/Main_Screen/Organization_screen/Oraganization_Top.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrganizationScreen extends StatefulWidget {
  final String  currentUserID, oid;
  OrganizationScreen(this.currentUserID, this.oid);
  @override
  _OrganizationScreen createState() => _OrganizationScreen(currentUserID,oid);
}

class _OrganizationScreen extends State<OrganizationScreen> {
  final String oid, currentUserID;
  _OrganizationScreen(this.currentUserID, this.oid);

  Future getOrganizationInfomation() async {
    print("id here"+oid);
    DocumentSnapshot docs =
        await Firestore.instance.collection('Organization').document(oid).get();
    return docs.data;
  }

  Future getPosts() async {
    QuerySnapshot qs = await Firestore.instance
        .collection('Post')
        .where('owner(oid)', isEqualTo: oid)
        .orderBy('timestamp', descending: true)
        .getDocuments();
    return qs.documents;
  }
@override
  void initState() {
    
print(getOrganizationInfomation());    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Organization"),
      ),
      body: FutureBuilder(
        future: (getPosts()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          else if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
                itemCount: snapshot?.data?.length + 1 ?? 1,
                itemBuilder: (context, index) {
                  if (index == 0)
                    return FutureBuilder(
                        future: getOrganizationInfomation(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            return Container(
                              child: OrganizationTop(
                                snapshot.data,
                                currentUserID,
                              ),
                            );
                          }
                        });
                  else
                    return Padding(
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child:
                            Card_View(snapshot.data[index - 1].documentID,
                   snapshot.data[index - 1].data, currentUserID));
                });
          }
        },
      ),
      /* floatingActionButton: (uid == currentUserID)
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
            : null);*/ //
    );
  }
}
