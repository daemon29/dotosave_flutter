import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const String ssd = "SSD MobileNet";
const place_api = 'AIzaSyApNZMEtoLsnu0ANWqepMBZUbCHbMMkP38';

class DonateScreen extends StatefulWidget {
  final String currentUserId;
  DonateScreen({Key key, @required this.currentUserId}) : super(key: key);
  @override
  _DonateScreen createState() =>
      new _DonateScreen(currentUserId: currentUserId);
}

class _DonateScreen extends State<DonateScreen> {
  _DonateScreen({Key key, @required this.currentUserId});
  final String currentUserId;
  final TextEditingController _controller = new TextEditingController();
  PersistentBottomSheetController controller;
  File _image;
  TextStyle style_state = TextStyle(
    fontStyle: FontStyle.italic,
  );
  bool _pickaplacevisibility = true;
  Set<String> items = new Set();
  String _model = ssd;
  String _address = "Your address will show up here!";
  List _recognitions;
  double _imageHeight;
  GeoPoint geoPoint;
  double _imageWidth;
  bool _busy = false;
  String body;
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: place_api);
  Future submit() async {
    this.setState(() {
      _busy = true;
    });
    if (_image == null || body == null) {
      this.setState(() {
        _busy = false;
      });
      return;
    } else {
      var uuid = new Uuid();
      String filename = currentUserId + uuid.v1();
      StorageReference reference =
          FirebaseStorage.instance.ref().child('Item/$filename');
      StorageUploadTask uploadTask = reference.putFile(_image);
      StorageTaskSnapshot storageTaskSnapshot;
      uploadTask.onComplete.then((value) {
        if (value.error == null) {
          storageTaskSnapshot = value;
          storageTaskSnapshot.ref.getDownloadURL().then((url) {
            GeoPoint geoPoint = GeoPoint(90, -90);
            Firestore.instance
                .collection("User")
                .document(currentUserId)
                .collection("Item")
                .document()
                .setData({
              "body": body,
              "url": url,
              "items": null,
              "geo": geoPoint
            }).then((onValue) {
              this.setState(() {
                _busy = false;
              });
              Fluttertoast.showToast(msg: "Upload success");
            }).catchError((error) {
              this.setState(() {
                _busy = false;
              });
              Fluttertoast.showToast(msg: error.toString());
            });
          }).catchError((error) {
            this.setState(() {
              _busy = false;
            });
            Fluttertoast.showToast(msg: error.toString());
          });
        } else {
          setState(() {
            _busy = false;
          });
          Fluttertoast.showToast(msg: "This file is not an image");
        }
      }, onError: (err) {
        setState(() {
          _busy = false;
        });
        Fluttertoast.showToast(msg: err.toString());
      });
    }
  }

  Future<void> onSeachBarButtonClick() async {
    try {
      // show input autocomplete with selected mode
      // then get the Prediction selected
      Prediction p = await PlacesAutocomplete.show(
        context: context,
        apiKey: place_api,
        onError: (onError) {},
        mode: Mode.overlay,
        language: "vn",
        components: [Component(Component.country, "vn")],
      );
      getPrediction(p);
    } catch (e) {
      return;
    }
  }

  Future<void> getPrediction(Prediction p) async {
    if (p != null) {
      setState(() {
        _pickaplacevisibility = true;
      });
      // get detail (lat/lng)
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;

      setState(() {
        _address = detail.result.formattedAddress;
      });
      geoPoint = new GeoPoint(lat, lng);
    }
  }

  Future<void> onGetCurrentLocationClick() async {
    setState(() {
      _pickaplacevisibility = false;
    });
    Position userLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    geoPoint = new GeoPoint(userLocation.latitude, userLocation.longitude);
  }

  Future predictImagePicker() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() {
      _busy = true;
    });
    predictImage(image);
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

  Future loadModel() async {
    Tflite.close();
    try {
      String res;
      res = await Tflite.loadModel(
          model: "assets/models/ssd_mobilenet.tflite",
          labels: "assets/models/ssd_mobilenet.txt");
      print(res);
    } on PlatformException {
      print('Failed to load model.');
    }
  }

  Future ssdMobileNet(File image) async {
    var recognitions = await Tflite.detectObjectOnImage(
      path: image.path,
      numResultsPerClass: 1,
    );
    setState(() {
      _recognitions = recognitions;
    });
  }

  onSelect(model) async {
    setState(() {
      _busy = true;
      _model = model;
      _recognitions = null;
    });
    await loadModel();

    if (_image != null)
      predictImage(_image);
    else
      setState(() {
        _busy = false;
      });
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
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Widget> stackChildren = [];
    List<Chip> listChip = [];

    // _recognitions.map((res) {
    //   items.add(res["detectedClass"]);
    // });
    // renderChip() {
    //   return ListView.builder(
    //     itemCount: items.length,
    //     itemBuilder: (context, index) {
    //       return Chip(
    //         label: Text(items.elementAt(index)),
    //         onDeleted: () {
    //           setState(() {});
    //         },
    //       );
    //     },
    //   );
    // }

    stackChildren.add(Positioned(
      top: 0.0,
      left: 0.0,
      width: size.width,
      child: _image == null
          ? Image.asset(
              "assets/images/EmptyImage.png",
              fit: BoxFit.scaleDown,
            )
          : Image.file(_image, fit: BoxFit.scaleDown),
    ));

    if (_model == ssd) {
      stackChildren.addAll(renderBoxes(size));
    }
    if (_busy) {
      stackChildren.add(const Opacity(
        child: ModalBarrier(dismissible: false, color: Colors.grey),
        opacity: 0.3,
      ));
      stackChildren.add(const Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Donate"),
          backgroundColor: Color(0xfff5af19),
          /*leading: IconButton(
            icon: Icon(
              Icons.menu,
              semanticLabel: 'menu',
            ),
            onPressed: () {
              print("Menu button");
            },
          ),*/
        ),
        bottomNavigationBar: null,
        body: new GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                /*
                SizedBox.fromSize(
                  size: Size.fromHeight(200),
                  child: Stack(
                    children: <Widget>[
                      _image == null
                          ? Image.asset("assets/images/EmptyImage.png")
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
                                                  tooltip: "Remove this photo",
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
                    */
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 220,
                  child: Stack(
                    children: stackChildren,
                  ),
                ),
                Container(
                    width: double.infinity,
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
                              /*Text(
                          "Submit",
                          style: TextStyle(
                              fontFamily: "Poppins-Bold",
                              fontSize: 45,
                              letterSpacing: .6),
                        ),*/
                              Padding(
                                  padding: EdgeInsets.only(left: 5, right: 5),
                                  child: Row(
                                    children: <Widget>[
                                      RaisedButton(
                                        onPressed: () {
                                          predictImagePicker();
                                        },
                                        color: Color(0xfff5af19),
                                        child: Icon(
                                          Icons.add_a_photo,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  )),
                              Divider(),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Center(
                                          child: Text("Information",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: "Poppins-Medium",
                                              ))),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text("Describe",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: "Poppins-Medium",
                                          )),
                                      TextField(
                                        keyboardType: TextInputType.multiline,
                                        maxLines: null,
                                        onChanged: (value) {
                                          setState(() {
                                            body = value;
                                          });
                                        },
                                        decoration: InputDecoration(
                                            hintText: "Describe this ...",
                                            hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12.0)),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text("Address",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: "Poppins-Medium",
                                          )),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          RaisedButton(
                                              textColor: Colors.white,
                                              onPressed: onSeachBarButtonClick,
                                              padding:
                                                  const EdgeInsets.all(0.0),
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                    color: Color(0xfff5af19)
                                                    /* gradient: LinearGradient(colors: <Color>[
                                    Color(0xfff12711),
                                    Color(0xfff5af19)
                                  ])*/
                                                    ),
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: const Text(
                                                    'Pick a place',
                                                    style: TextStyle(
                                                        fontSize: 13)),
                                              )),
                                          const Text("  Or  "),
                                          RaisedButton(
                                              textColor: Colors.white,
                                              padding:
                                                  const EdgeInsets.all(0.0),
                                              onPressed:
                                                  onGetCurrentLocationClick,
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  color: Color(0xfff5af19),
                                                  /*gradient: LinearGradient(colors: <Color>[
                                        Color(0xfff12711),
                                        Color(0xfff5af19)
                                      ])*/
                                                ),
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: const Text(
                                                    'Get your location',
                                                    style: TextStyle(
                                                        fontSize: 13)),
                                              ))
                                        ],
                                      ),
                                      Visibility(
                                        visible: _pickaplacevisibility,
                                        child: Text(
                                          _address,
                                          overflow: TextOverflow.clip,
                                          style: style_state,
                                        ),
                                      ),
                                      Visibility(
                                          visible: !_pickaplacevisibility,
                                          child: TextField(
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLines: null,
                                            onChanged: (value) {
                                              setState(() {
                                                _address = value;
                                                style_state = TextStyle(
                                                  fontStyle: FontStyle.normal,
                                                );
                                              });
                                            },
                                            decoration: InputDecoration(
                                                hintText: "Enter your address",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12.0)),
                                          )),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text("Item types:",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: "Poppins-Medium",
                                          )),
                                      TextField(
                                        controller: _controller,
                                        onSubmitted: (value) {
                                          setState(() {
                                            items.add(value);
                                          });
                                          _controller.clear();
                                        },
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                            hintText: "Enter a missing item",
                                            hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12.0)),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                    ],
                                  )),
                            ]))),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(0.0),
                    onPressed: submit,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(
                            0xfff5af19), /*
                                  gradient: LinearGradient(colors: <Color>[
                                Color(0xfff12711),
                                Color(0xfff5af19)
                              ])*/
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: const Text('   Submit   ',
                          style: TextStyle(fontSize: 17)),
                    ))
              ],
            ),
          ),
        ));
  }
}
