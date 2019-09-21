import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return null;
  }
}

class NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}

class NotificationCard extends StatelessWidget {
  final String currentUserId;
  final Map<String, dynamic> notification;
  NotificationCard(this.currentUserId, this.notification);
  final String notification1 = "New comment on your post!";
  final String notification2 = "We found a campaign for you!";
  final String notification3 = "We found an item you need";
  final String notification4 = "You are accepted!";
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(onTap: () {}, child: Card(child: ListTile()));
  }
}
