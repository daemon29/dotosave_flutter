import 'package:flutter/material.dart';

class MyCircleAvatar extends StatelessWidget {
  final String url;
  MyCircleAvatar(this.url);
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 50.0,
        height: 50.0,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(url))));
  }
}
