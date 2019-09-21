import 'package:LadyBug/Widgets/Main_Screen/CircleAvatar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class OrganizationTop extends StatefulWidget {
  final String currentuid;
  final Map<String, dynamic> organization;
  OrganizationTop(this.organization, this.currentuid);
  @override
  _OrganizationTop createState() =>
      _OrganizationTop(this.organization, this.currentuid);
}

class _OrganizationTop extends State<OrganizationTop> {
  final String currentuid;
  final Map<String, dynamic> organization;
  _OrganizationTop(this.organization, this.currentuid);
  @override
  void initState() {
    print(organization);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: <Widget>[
      SizedBox(
          height: 220,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              Positioned(
                  top: 0,
                  left: 0,
                  child: InkWell(
                    onTap: () {},
                    child: SizedBox(
                        height: 170.0,
                        width: MediaQuery.of(context).size.width,
                        child: (organization['backgroundurl'] == "")
                            ? Container()
                            : CachedNetworkImage(
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                imageUrl: organization['backgroundurl'],
                                fit: BoxFit.cover)),
                  )),
              Positioned(
                left: 10,
                top: 90,
                child: MyCircleAvatar(organization['oid'],
                    organization['imageurl'], 120.0, currentuid, false, true),
              ),
            ],
          )),
      SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                organization["name"],
                style: TextStyle(
                    fontFamily: 'Segoeu',
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ))),
      SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Row(children: [
                Icon(
                  Icons.location_on,
                  size: 17,
                ),
                Text(
                  organization["address"],
                  style:
                      TextStyle(fontFamily: 'Segoeu', color: Colors.grey[700]),
                  overflow: TextOverflow.clip,
                )
              ]))),
      SizedBox(
        height: 10,
      ),
      SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                organization["describe"],
                style: TextStyle(fontFamily: 'Segoeu', color: Colors.black),
                maxLines: 10,
                overflow: TextOverflow.ellipsis,
              ))),
      SizedBox(
        height: 10,
      )
    ]));
  }
}
