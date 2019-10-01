import 'package:LadyBug/Customize/MultiLanguage.dart';
import 'package:LadyBug/Widgets/Main_Screen/Card_View/Owner.dart';
import 'package:LadyBug/const.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class CommentTop extends StatelessWidget {
  final String uid, currentUserID, name;
  final DateTime time;
  CommentTop(this.uid, this.name, this.time, this.currentUserID);
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Post_Owner(name, uid, currentUserID,false),
        Text(
          GetDuration(),
          style: TextStyle(
            color: greyColor,
            fontFamily: 'Segoeu',
          ),
        )
      ],
    );
  }
}
