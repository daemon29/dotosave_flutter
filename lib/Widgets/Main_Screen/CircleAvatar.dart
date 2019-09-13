import 'package:LadyBug/Screens/Oraganization_screen.dart';
import 'package:LadyBug/Screens/Profile_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MyCircleAvatar extends StatelessWidget {
  final String id, url, currentUserId;
  final size;
  final bool cantap,isOrganization;
  MyCircleAvatar(this.id, this.url, this.size, this.currentUserId,this.cantap,this.isOrganization);
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: cantap?() {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                     (isOrganization)?OrganizationScreen(currentUserId,id) :ProfileScreen(currentUserId,id)));
        }:null,
        child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: size * 0.03),
                shape: BoxShape.circle,
                image: DecorationImage(
                    fit: BoxFit.cover, image: CachedNetworkImageProvider(url)))));
  }
}
