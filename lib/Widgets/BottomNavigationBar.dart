import 'package:LadyBug/Screens/donate_screen.dart';
import 'package:LadyBug/Screens/main_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:LadyBug/Screens/donationmap_screen.dart';
import 'package:LadyBug/Screens/friend_screen.dart';

class MyBottomNavigationBar extends StatelessWidget {
  final String currentUser;
  int _selectedIndex;

  MyBottomNavigationBar(context, @required this.currentUser,this._selectedIndex);
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.blue,
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        if(index == _selectedIndex) return;
        switch (index) {
          case 0: //feed
            {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return Main_Screen(
                      currentUserId: currentUser,
                    );
                  },
                ),
              );
              break;
            }
          case 1: //profile
            {
              break;
            }
          case 2: //send
            {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return DonateScreen(
                      currentUserId: currentUser,
                    );
                  },
                ),
              );
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
                    return FriendScreen(
                      currentUserId: currentUser,
                    );
                  },
                ),
              );
              break;
            }
        }
        _selectedIndex = index;
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text(
            "",
            style: TextStyle(fontSize: 0),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
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
          icon: Icon(Icons.send),
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
          icon: Icon(Icons.message),
        ),
      ],
    );
  }
}
