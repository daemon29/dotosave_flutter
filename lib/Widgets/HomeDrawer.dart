import 'package:LadyBug/Screens/AddCampaign_screen.dart';
import 'package:LadyBug/Screens/EditProfile_screen.dart';
import 'package:LadyBug/Screens/Item_infomation_screen.dart';
import 'package:LadyBug/Screens/OrganizationList.dart';
import 'package:LadyBug/Screens/Profile_screen.dart';
import 'package:LadyBug/Screens/donationmap_screen.dart';
import 'package:LadyBug/Screens/friend_screen.dart';
import 'package:LadyBug/Screens/loading_screen.dart';
import 'package:LadyBug/Screens/login_screen.dart';
import 'package:LadyBug/Widgets/Main_Screen/Campaign_screen/Campaign_screen_top.dart';
import 'package:LadyBug/Widgets/Main_Screen/CircleAvatar.dart';
import 'package:LadyBug/Screens/donate_screen.dart';
import 'package:LadyBug/Widgets/SlideRightRoute.dart';
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
                      Flexible(
                        child: Text(
                          snapshot.data['name'],
                          overflow: TextOverflow.clip,
                          maxLines: 2,
                          style: TextStyle(
                            fontFamily: 'Segoeu',
                            color: Colors.deepOrange[700],
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ]),
                    decoration: BoxDecoration(color: Colors.deepOrange[50]),
                  ),
                  /*
                  ListTile(
                    leading: Icon(
                      Icons.notifications,
                                            color: Colors.deepOrange[700]

                    ),
                    title: Text('Notifications'),
                    onTap: () {},
                  ),
                  
                  */
                  ListTile(
                    leading: Icon(
                      Icons.group_work,
                      color: Colors.deepOrange[700],
                    ),
                    title: Text('Organizations'),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                      Navigator.push(
                          context,
                          SlideRightRoute(
                              page: OrganizationList(currentUserId)));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.map, color: Colors.deepOrange[700]),
                    title: Text('Donation map'),
                    onTap: () {
                      Navigator.push(context,
                          SlideRightRoute(page: DonationMap(currentUserId)));
                    },
                  ),
                  ListTile(
                    leading:
                        Icon(Icons.card_giftcard, color: Colors.deepOrange[700]),
                    title: Text('Donate'),
                    onTap: () {
                      Navigator.push(
                          context,
                          SlideRightRoute(
                              page: DonateScreen(
                            currentUserId: currentUserId,
                          )));
                    },
                  ),
                  ListTile(
                      leading:
                          Icon(Icons.message, color: Colors.deepOrange[700]),
                      title: Text('Messages'),
                      onTap: () {
                        Navigator.push(
                            context,
                            SlideRightRoute(
                                page: FriendScreen(
                              currentUserId: currentUserId,
                            )));
                      }),
                  /*
                  ListTile(
                    leading: Icon(
                      Icons.group,
                      color: Colors.deepOrange[700]
                    ),
                    title: Text('Friends'),
                    onTap: () {
                      /*
                         Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:(context) =>
                          AddCampaign()
                        ),
                      );*/
                    },
                  ),
*/
                  /*
                  ListTile(
                    leading: Icon(
                      Icons.account_circle,
                      color: Colors.deepOrange[700]
                    ),
                    title: Text('Profile'),
                    onTap: () {
                      Navigator.push(
                          context,
                          SlideRightRoute(
                              page:
                                  ProfileScreen(currentUserId, currentUserId)));
                    },
                  ),
                  */
                  ListTile(
                      leading: Icon(Icons.keyboard_return,
                          color: Colors.deepOrange[700]),
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
