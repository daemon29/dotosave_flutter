import 'package:LadyBug/Screens/Profile_screen.dart';
import 'package:LadyBug/Screens/donationmap_screen.dart';
import 'package:LadyBug/Screens/friend_screen.dart';
import 'package:LadyBug/Screens/loading_screen.dart';
import 'package:LadyBug/Screens/login_screen.dart';
import 'package:LadyBug/Widgets/Main_Screen/CircleAvatar.dart';
import 'package:LadyBug/Screens/donate_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeDrawer extends StatelessWidget {
  final currentUserId;
  HomeDrawer(this.currentUserId);
  Future getUserInformation() async {
    DocumentSnapshot docs = await Firestore.instance
        .collection('User')
        .document(currentUserId)
        .get();
    return docs.data;
  }

  Future signOutGoogleAcount() async {
    await GoogleSignIn().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUserInformation(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else if (snapshot.connectionState == ConnectionState.done) {
            return Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    child: Row(children: [
                      MyCircleAvatar(currentUserId, snapshot.data['imageurl'],
                          50.0, currentUserId, true, false),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        snapshot.data['name'],
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ]),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.notifications,
                      color: Colors.black,
                    ),
                    title: Text('Notifications'),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.map,
                      color: Colors.black,
                    ),
                    title: Text('Donation map'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return DonationMap(currentUserId);
                          },
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.assistant,
                      color: Colors.black,
                    ),
                    title: Text('Donate goods'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return DonateScreen(
                              currentUserId: currentUserId,
                            );
                          },
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.message,
                      color: Colors.black,
                    ),
                    title: Text('Messages'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return FriendScreen(
                              currentUserId: currentUserId,
                            );
                          },
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.group,
                      color: Colors.black,
                    ),
                    title: Text('Friends'),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.group_work,
                      color: Colors.black,
                    ),
                    title: Text('Oganizations'),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.account_circle,
                      color: Colors.black,
                    ),
                    title: Text('Profile'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return ProfileScreen(currentUserId, currentUserId);
                          },
                        ),
                      );
                    },
                  ),
                  ListTile(
                      leading: Icon(
                        Icons.keyboard_return,
                        color: Colors.black,
                      ),
                      title: Text('Log out'),
                      onTap: () async {
                        await FirebaseAuth.instance.signOut().then((value) {
                          print("***** log out");
                          signOutGoogleAcount();

                          Navigator.pushReplacement(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new Loading()));
                        });
                      }),
                ],
              ),
            );
          }
        });
  }
}
