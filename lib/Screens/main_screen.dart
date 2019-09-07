import 'dart:convert';
import 'package:LadyBug/Screens/AddPost_screen.dart';
import 'package:LadyBug/Widgets/BottomNavigationBar.dart';
import 'package:LadyBug/Widgets/Main_Screen/Card_View/Card_View.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:LadyBug/Widgets/Main_Screen/CircleAvatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Main_Screen extends StatefulWidget {
  final String currentUserId;
  Main_Screen({Key key, @required this.currentUserId}) : super(key: key);
  @override
  _Main_Screen createState() => new _Main_Screen(currentUserId: currentUserId);
}

class _Main_Screen extends State<Main_Screen> {
  final String currentUserId;
  Firestore _firestore = Firestore.instance;

  _Main_Screen({Key key, @required this.currentUserId});

  Future getPosts() async {
    QuerySnapshot qs = await _firestore.collection('Post').orderBy('timestamp',descending: true).getDocuments();
    return qs.documents;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Home"),
            leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: null,
            ),
          ),
          body:
              /*Column(children: [
        Flexible(
            child: ,*/
              FutureBuilder(
            future: (getPosts()),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(child: Text('Loading data... Please wait'));
              else {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return
                          Card_View(snapshot.data[index].data,index,currentUserId);
                    });
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return AddPost(
                      currentUserId,
                    );
                  },
                ),
              );
            },
            child: Icon(
              Icons.create,
              color: Colors.white,
            ),
            backgroundColor: Colors.blue,
          ),
          bottomNavigationBar: MyBottomNavigationBar(context, currentUserId, 0),
        ));
  }
}
