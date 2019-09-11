import 'package:LadyBug/Widgets/Main_Screen/Card_View/Owner.dart';
import 'package:LadyBug/Widgets/Main_Screen/CircleAvatar.dart';
import 'package:LadyBug/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class CommentTop extends StatelessWidget {
  final String uid, currentUserID, name;
  final DateTime time;
  CommentTop(this.uid, this.name, this.time, this.currentUserID);
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Post_Owner(name, uid),
        Text(
          GetDuration(),
          style: TextStyle(color: greyColor),
        )
      ],
    );
  }
}
