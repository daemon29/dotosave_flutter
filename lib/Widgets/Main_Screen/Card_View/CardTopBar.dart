import 'package:LadyBug/Customize/MultiLanguage.dart';
import 'package:LadyBug/Widgets/Main_Screen/Card_View/Owner.dart';
import 'package:LadyBug/Widgets/Main_Screen/CircleAvatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class CardTopBar extends StatelessWidget {
  final String id, currentUserID;
  final DateTime time;
  final isOid;
  CardTopBar(this.id, this.time, this.currentUserID, this.isOid);
  String GetDuration() {
    Duration temp = DateTime.now().difference(time);
    if (temp > Duration(days: 365)) {
      return DateFormat('dd/MM/yyyy').format(time);
    }
    if (temp > Duration(days: 7)) {
      return DateFormat('dd mm').format(time);
    }
    if (temp >= Duration(days: 1)) {
      return (temp.inDays == 1)
          ? captions[setLanguage]['yesterday']
          : temp.inDays.toString() + ' ' + captions[setLanguage]['days'];
    }
    if (temp >= Duration(hours: 1)) {
      return (temp.inHours == 1)
          ? '1 ' + captions[setLanguage]['hour']
          : temp.inHours.toString() + ' ' + captions[setLanguage]['hours'];
    }
    if (temp >= Duration(minutes: 1)) {
      return (temp.inMinutes == 1)
          ? '1 ' + captions[setLanguage]['min']
          : temp.inMinutes.toString() + ' ' + captions[setLanguage]['mins'];
    }
    return captions[setLanguage]['now'];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firestore.instance
            .collection((isOid) ? 'Organization' : 'User')
            .document(id)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Container();
          else
            return new Row(
              children: <Widget>[
                MyCircleAvatar(id, snapshot.data['imageurl'], 50.0,
                    currentUserID, true, isOid),
                SizedBox(
                  width: 5,
                ),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      (isOid)
                          ? Post_Owner(
                              snapshot.data['name'], id, currentUserID, true)
                          : Post_Owner(
                              snapshot.data['name'], id, currentUserID, false),
                     
                      Text(
                        GetDuration(),
                        style:
                            TextStyle(fontFamily: 'Segoeu', color: Colors.grey),
                      )
                    ])
              ],
            );
        });
  }
}
