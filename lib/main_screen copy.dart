import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:parallax_image/parallax_image.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter_tagging/flutter_tagging.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreen createState() => new _MainScreen();
}

List<String> images = [
  "assets/image_04.jpg",
  "assets/image_03.jpg",
  "assets/image_02.jpg",
  "assets/image_01.png",
];
Set<String> items;

class _MainScreen extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
  }

  String text = "Nothing to show";
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Donate"),
          backgroundColor: Color(0xfff5af19),
        ),
        body: new Container(
          child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Donate",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 46.0,
                                letterSpacing: 1.0,
                                fontFamily: "Poppins-Bold"),
                          ),
                          FloatingActionButton(
                            onPressed: () {},
                            tooltip: "Pick Image",
                            child: Icon(Icons.add_a_photo),
                            backgroundColor: Color(0xfff12711),
                          )
                        ],
                      ),
                    ),
                    AnimatedList(
                      initialItemCount: images.length - 1,
                    ),
                    Stack(
                      children: <Widget>[],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Center(
                      child: Text(
                        text,
                        style: TextStyle(color: Colors.pink),
                      ),
                    )
                  ],
                ),
              )),
        ));
  }
}

imageSelectionGallery() async {
  File galleryFile = await ImagePicker.pickImage(source: ImageSource.gallery);
}
