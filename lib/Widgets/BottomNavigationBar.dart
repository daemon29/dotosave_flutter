import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:LadyBug/Screens/donationmap_screen.dart';
import 'package:LadyBug/Screens/friend_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyBottomNavigationBar extends StatelessWidget {
  final String currentUser;
  MyBottomNavigationBar(context,@required this.currentUser);
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        switch (index) {
          case 0: //feed
            {
              break;
            }
          case 1: //profile
            {
              break;
            }
          case 2: //send
            {
              break;
            }
          case 3: //map
            {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return DonationMap();
                  },
                ),
              );

              break;
            }
          case 4: // message
            {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return FriendScreen(currentUserId: currentUser,);
                  },
                ),
              );
              break;
            }
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, color: Color.fromARGB(255, 0, 0, 0)),
          title: Text(
            "",
            style: TextStyle(fontSize: 0),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications, color: Color.fromARGB(255, 0, 0, 0)),
          title: Text(
            "",
            style: TextStyle(fontSize: 0),
          ),
        ),
        BottomNavigationBarItem(
          title: Text(
            "",
            style: TextStyle(fontSize: 0),
          ),
          icon: Icon(Icons.send, color: Color.fromARGB(255, 0, 0, 0)),
        ),
        BottomNavigationBarItem(
          title: Text(
            "",
            style: TextStyle(fontSize: 0),
          ),
          icon: Icon(Icons.map, color: Color.fromARGB(255, 0, 0, 0)),
        ),
        BottomNavigationBarItem(
          title: Text(
            "",
            style: TextStyle(fontSize: 0),
          ),
          icon: Icon(Icons.message, color: Color.fromARGB(255, 0, 0, 0)),
        ),
      ],
    );
  }
}
