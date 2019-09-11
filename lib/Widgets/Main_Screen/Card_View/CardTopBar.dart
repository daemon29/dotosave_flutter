import 'package:LadyBug/Widgets/Main_Screen/Card_View/Owner.dart';
import 'package:LadyBug/Widgets/Main_Screen/CircleAvatar.dart';
import 'package:LadyBug/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class CardTopBar extends StatelessWidget {
  final String uid, currentUserID;
  final DateTime time;
  CardTopBar(this.uid, this.time, this.currentUserID);
  String GetDuration() {
    Duration temp = DateTime.now().difference(time);
    if (temp > Duration(days: 365)) {
      return DateFormat('dd-MMMM-yyyy').format(time);
    }
    if (temp > Duration(days: 7)) {
      return DateFormat('dd-').format(time);
    }
    if (temp >= Duration(days: 1)) {
      return (temp.inDays == 1)
          ? 'Yesterday'
          : temp.inDays.toString() + ' days';
    }
    if (temp >= Duration(hours: 1)) {
      return (temp.inHours == 1)
          ? '1 hour'
          : temp.inHours.toString() + ' hours';
    }
    if (temp >= Duration(minutes: 1)) {
      return (temp.inMinutes == 1)
          ? '1 min'
          : temp.inMinutes.toString() + ' mins';
    }
    return 'Now';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firestore.instance.collection('User').document(uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Container();
          else
            return new Row(
              children: <Widget>[
                MyCircleAvatar(snapshot.data['uid'], snapshot.data['imageurl'],50.0, currentUserID,true),
                SizedBox(
                  width: 5,
                ),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Post_Owner(snapshot.data['name'], uid),
                      Text(
                        GetDuration(),
                        style: TextStyle(color: greyColor),
                      )
                    ])
              ],
            );
        });
  }
}
