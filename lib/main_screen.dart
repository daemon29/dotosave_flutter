import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:parallax_image/parallax_image.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter_tagging/flutter_tagging.dart';

var padding = 20.0;
var verticalInset = 20.0;
var widgetAspectRatio = cardAspectRatio * 1.2;

class MainScreen extends StatefulWidget {
  @override
  _MainScreen createState() => new _MainScreen();
}

var cardAspectRatio = 12.0 / 16.0;
List<File> image = List<File>();
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

  Widget imageCard() => AspectRatio(
        aspectRatio: widgetAspectRatio,
        child: LayoutBuilder(builder: (context, contraints) {
          var primaryCardLeft = contraints.maxWidth -
              2 * padding -
              ((contraints.maxHeight - 2 * padding) * cardAspectRatio);
          var horizontalInset = primaryCardLeft / 2;
          List<Widget> cardList = new List();
          for (var i = 0; i < images.length; i++) {
            var delta = i - currentPage;
            bool isOnRight = delta > 0;
            var start = padding +
                max(
                    primaryCardLeft -
                        horizontalInset * -delta * (isOnRight ? 15 : 1),
                    0.0);
            var cardItem = Positioned.directional(
              top: padding + verticalInset * max(-delta, 0.0),
              bottom: padding + verticalInset * max(-delta, 0.0),
              start: start,
              textDirection: TextDirection.rtl,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Container(
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        offset: Offset(3.0, 6.0),
                        blurRadius: 10.0)
                  ]),
                  child: AspectRatio(
                    aspectRatio: cardAspectRatio,
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Image.asset(images[i], fit: BoxFit.cover),
                        Align(
                          alignment: Alignment.topRight,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 8.0),
                                  child: IconButton(
                                    icon: Icon(Icons.close),
                                    iconSize: 50,
                                    tooltip: "Remove this photo",
                                    onPressed: () {
                                      setState(() {
                                        cardList.removeAt(i);
                                        images.removeAt(i);
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
            );
            cardList.add(cardItem);
          }
          return Stack(
            children: cardList,
          );
        }),
      );
  String text = "Nothing to show";
  var currentPage = images.length - 1.0;
  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(initialPage: images.length - 1);
    controller.addListener(() {
      setState(() {
        currentPage = controller.page;
      });
    });

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
                            onPressed: () {
                              setState(() {
                                images = imageSelectionGallery();
                              });
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
                        imageCard(),
                        Positioned.fill(
                          child: PageView.builder(
                            itemCount: images.length,
                            controller: controller,
                            reverse: true,
                            itemBuilder: (context, index) {
                              return Container();
                            },
                          ),
                        )
                      ],
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
  return galleryFile;
}
