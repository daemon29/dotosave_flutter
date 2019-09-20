import 'package:LadyBug/Screens/Profile_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
    //.document('OsNbsAILhdnhAKRNOziE');
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
                appBar: AppBar(title: Text("Item")),
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
                      child: Text(
                        snapshot.data["title"],
                        overflow: TextOverflow.clip,
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
                              return Row(children: [
                                Text("Owner: "),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return ProfileScreen(currentUserId,
                                              snapshot.data['owner']);
                                        },
                                      ),
                                    );
                                  },
                                  child: Text(_snapshot.data[0].data['name']),
                                )
                              ]);
                          }),
                    ),
                    Flexible(child: Text("Description")),
                    Flexible(
                        child: Text(
                      snapshot.data["describe"],
                      overflow: TextOverflow.clip,
                    )),
                    Flexible(child: Text("Tags")),
                    Flexible(
                        child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data["tag"].length,
                      itemBuilder: (context, index) {
                        return Chip(
                          label: Text(snapshot.data["tag"][index]),
                        );
                      },
                    )),
                    Flexible(
                        child: RaisedButton(
                      onPressed: () {},
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.contact_mail),
                        SizedBox(
                          width: 5,
                        ),
                        Text("Contact")
                      ]),
                    ))
                  ],
                ));
          }
        });
  }
}
