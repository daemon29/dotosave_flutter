import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Post_Owner extends StatelessWidget {
  final String name, uid;
  Post_Owner(this.name, this.uid);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {},
        child: Text(
          name,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold
          ),
        ));
  }
}
