import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreen createState() => new _MainScreen();
}

class _MainScreen extends State<MainScreen> {
  final TextEditingController _controller = new TextEditingController();
  PersistentBottomSheetController controller;
  File _image;
  Set<String> items = new Set();

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Donate"),
          backgroundColor: Color(0xfff5af19),
          leading: IconButton(
            icon: Icon(
              Icons.menu,
              semanticLabel: 'menu',
            ),
            onPressed: () {
              print("Menu button");
            },
          ),
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
                            onPressed: () {
                              getImage();
                            },
                            tooltip: "Pick Image",
                            child: Icon(Icons.add_a_photo),
                            backgroundColor: Color(0xfff12711),
                          )
                        ],
                      ),
                    ),
                    Stack(
                      children: <Widget>[
                        _image == null
                            ? Image.asset("assets/images/EmtyImage.png")
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black12,
                                            offset: Offset(3.0, 6.0),
                                            blurRadius: 10.0)
                                      ]),
                                  child: AspectRatio(
                                    aspectRatio: 12.0 / 16.0,
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: <Widget>[
                                        Image.file(_image, fit: BoxFit.cover),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 8.0),
                                                  child: IconButton(
                                                    icon: Icon(Icons.close),
                                                    iconSize: 50,
                                                    tooltip:
                                                        "Remove this photo",
                                                    onPressed: () {
                                                      setState(() {
                                                        _image = null;
                                                      });
                                                    },
                                                  )),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      width: double.infinity,
                      height: 500,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                offset: Offset(0.0, 15.0),
                                blurRadius: 15.0),
                            BoxShadow(
                                color: Colors.black12,
                                offset: Offset(0.0, -10.0),
                                blurRadius: 15.0)
                          ]),
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Submit",
                              style: TextStyle(
                                  fontFamily: "Poppins-Bold",
                                  fontSize: 45,
                                  letterSpacing: .6),
                            ),
                            TextField(
                              controller: _controller,
                              onSubmitted: (value) {
                                setState(() {
                                  items.add(value);
                                });
                                _controller.clear();
                              },
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  hintText: "Enter a missing item",
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 12.0)),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text("Enter your describe ",
                                style: TextStyle(
                                  fontSize: 26,
                                  fontFamily: "Poppins-Medium",
                                )),
                            TextField(
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              onSubmitted: (value) {
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                  hintText: "Describe this ...",
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 12.0)),
                            ),
                            SizedBox(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text("Forgot Password?",
                                    style: TextStyle(
                                      fontFamily: "Poppins-Medium",
                                      color: Colors.orange,
                                      fontSize: 28,
                                    ))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ));
  }
}
