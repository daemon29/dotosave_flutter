import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreen createState() => new _MainScreen();
}

class _MainScreen extends State<MainScreen> {
  final TextEditingController _controller = new TextEditingController();
  PersistentBottomSheetController controller;
  File _image;
  Set<String> items = new Set();
  List _recognitions;
  double _imageHeight;
  double _imageWidth;
  bool _busy = false;
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() {
      _busy = true;
      _image = image;
    });
    predictImage(_image);
  }

  Future predictImage(File image) async {
    if (image == null) return;
    ssdMobileNet(image);
    new FileImage(image)
        .resolve(new ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      setState(() {
        _imageHeight = info.image.height.toDouble();
        _imageWidth = info.image.width.toDouble();
      });
    }));
    setState(() {
      _image = image;
      _busy = false;
    });
  }

  Future ssdMobileNet(File image) async {
    var recognitions = await Tflite.detectObjectOnImage(
        path: image.path, numResultsPerClass: 1);
    setState(() {
      _recognitions = recognitions;
    });
  }

  Future recognizeImage(File image) async {
    var regconitions = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 6,
        threshold: 0.05,
        imageMean: 127.5,
        imageStd: 127.5);
    setState(() {
      _recognitions = regconitions;
    });
  }

  Future loadModel() async {
    Tflite.close();
    try {
      String res;
      res = await Tflite.loadModel(
          model: "assets/models/ssd_mobilenet.tflite",
          labels: "assets/models/ssd_mobilenet.txt");
    } on PlatformException {
      print('Fail to load model');
    }
  }

  List<Widget> renderBoxes(Size screen) {
    if (_recognitions == null) return [];
    if (_imageHeight == null || _imageWidth == null) return [];

    double factorX = screen.width;
    double factorY = _imageHeight / _imageWidth * screen.width;
    Color blue = Color.fromRGBO(37, 213, 253, 1.0);
    return _recognitions.map((re) {
      return Positioned(
        left: re["rect"]["x"] * factorX,
        top: re["rect"]["y"] * factorY,
        width: re["rect"]["w"] * factorX,
        height: re["rect"]["h"] * factorY,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            border: Border.all(
              color: blue,
              width: 2,
            ),
          ),
          child: Text(
            "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              background: Paint()..color = blue,
              color: Colors.white,
              fontSize: 12.0,
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _busy = true;
    loadModel().then((val) {
      setState(() {
        _busy = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Widget> stackChildren = [];

    if (_recognitions != null) {
      stackChildren.add(Positioned(
        top: 0.0,
        left: 0.0,
        width: size.width,
        child: _image == null
            ? Text('No image selected.')
            : Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        alignment: Alignment.topCenter,
                        image: MemoryImage(_recognitions),
                        fit: BoxFit.fill)),
                child: Opacity(opacity: 0.3, child: Image.file(_image))),
      ));
    } else {
      stackChildren.add(Positioned(
        top: 0.0,
        left: 0.0,
        width: size.width,
        child: _image == null ? Text('No image selected.') : Image.file(_image),
      ));
    }
    stackChildren.addAll(renderBoxes(size));
    if (_busy) {
      stackChildren.add(const Opacity(
        child: ModalBarrier(dismissible: false, color: Colors.grey),
        opacity: 0.3,
      ));
      stackChildren.add(const Center(child: CircularProgressIndicator()));
    }
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
                      // children: <Widget>[
                      //   _image == null
                      //       ? Image.asset("assets/images/EmtyImage.png")
                      //       : ClipRRect(
                      //           borderRadius: BorderRadius.circular(16.0),
                      //           child: Container(
                      //             decoration: BoxDecoration(
                      //                 color: Colors.white,
                      //                 boxShadow: [
                      //                   BoxShadow(
                      //                       color: Colors.black12,
                      //                       offset: Offset(3.0, 6.0),
                      //                       blurRadius: 10.0)
                      //                 ]),
                      //             child: AspectRatio(
                      //               aspectRatio: 12.0 / 16.0,
                      //               child: Stack(
                      //                 fit: StackFit.expand,
                      //                 children: <Widget>[
                      //                   Image.file(_image, fit: BoxFit.cover),
                      //                   Align(
                      //                     alignment: Alignment.topRight,
                      //                     child: Column(
                      //                       mainAxisSize: MainAxisSize.min,
                      //                       crossAxisAlignment:
                      //                           CrossAxisAlignment.start,
                      //                       children: <Widget>[
                      //                         Padding(
                      //                             padding: EdgeInsets.symmetric(
                      //                                 horizontal: 8.0,
                      //                                 vertical: 8.0),
                      //                             child: IconButton(
                      //                               icon: Icon(Icons.close),
                      //                               iconSize: 50,
                      //                               tooltip:
                      //                                   "Remove this photo",
                      //                               onPressed: () {
                      //                                 setState(() {
                      //                                   _image = null;
                      //                                 });
                      //                               },
                      //                             )),
                      //                       ],
                      //                     ),
                      //                   )
                      //                 ],
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      // ],
                      children: stackChildren,
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
