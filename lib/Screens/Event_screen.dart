import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EventCampaignScreen extends StatefulWidget{
  Map<String,dynamic> post;
  EventCampaignScreen(this.post);
  @override
  _EventCampaignScreen createState() => _EventCampaignScreen(this.post);
}
class _EventCampaignScreen extends State<EventCampaignScreen>{
  Map<String,dynamic> post;
  _EventCampaignScreen(this.post);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event/Campaign')
      ),
      body:ListView(children: <Widget>[
        Image(image: NetworkImage("")),
        Text(""),
        
      ],),
    );
  }
} 