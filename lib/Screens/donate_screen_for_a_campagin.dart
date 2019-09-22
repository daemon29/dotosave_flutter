import 'dart:io';
import 'dart:math';
import 'package:LadyBug/Widgets/ItemtypeList.dart';
import 'package:LadyBug/Widgets/SlideRightRoute.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tflite/tflite.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const String ssd = "SSD MobileNet";
const place_api = 'AIzaSyApNZMEtoLsnu0ANWqepMBZUbCHbMMkP38';

class DonateCampaignScreen extends StatefulWidget {
  final String currentUserId;
  final String cid;
  DonateCampaignScreen({Key key, @required this.currentUserId, this.cid})
      : super(key: key);
  @override
  DonateCampaignScreenState createState() =>
      new DonateCampaignScreenState(currentUserId: currentUserId, cid: cid);
}

class DonateCampaignScreenState extends State<DonateCampaignScreen> {
  DonateCampaignScreenState({Key key, @required this.currentUserId, this.cid});
  final String currentUserId;
  final String cid;
  final TextEditingController _controller = new TextEditingController();
  PersistentBottomSheetController controller;
  List<bool> indexList = List.filled(itemTypeList.length, false);
  List<String> tags = [];

  File _image;
  TextStyle style_state = TextStyle(
    fontFamily: 'Segoeu',
    fontStyle: FontStyle.italic,
  );
  bool donotpick = true;
  bool _pickaplacevisibility = true;
  Set<String> items = new Set();
  String _model = ssd;
  String _address = "Your address will show up here!";
  List _recognitions;
  double _imageHeight;
  GeoPoint geoPoint;
  String title;
  int exp;
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
            Firestore.instance.collection("Donation").document().setData({
              'cid': cid,
              'title': title,
              "describe": body,
              "imageurl": url,
              'exp': exp,
              'address': _address,
              'owner': currentUserId,
              "geo": geoPoint,
              'tag': tags
            }).then((onValue) {
              this.setState(() {
                _busy = false;
              });
              Fluttertoast.showToast(msg: "Upload success");
              Navigator.pop(context);
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

  DateTime selectedDate = DateTime.now();
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
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
              fontFamily: 'Segoeu',
              background: Paint()..color = blue,
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
          title: const Text(
            "Donate",
          ),
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 220,
                    child: Stack(
                      children: stackChildren,
                    ),
                  ),
                  Container(
                      width: double.infinity,
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(left: 5, right: 5),
                                child: Row(
                                  children: <Widget>[
                                    RaisedButton(
                                      onPressed: () {
                                        predictImagePicker();
                                      },
                                      child: Icon(
                                        Icons.add_a_photo,
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
                                                fontFamily: 'Segoeu',
                                              ))),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text("Title",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'Segoeu',
                                          )),
                                      TextField(
                                        maxLength: 70,
                                        keyboardType: TextInputType.multiline,
                                        maxLines: null,
                                        onChanged: (value) {
                                          setState(() {
                                            title = value;
                                          });
                                        },
                                        decoration: InputDecoration(
                                            hintText: "Title here...",
                                            hintStyle: TextStyle(
                                                fontFamily: 'Segoeu',
                                                fontSize: 12.0)),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text("Describe",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'Segoeu',
                                          )),
                                      TextField(
                                        maxLength: 200,
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
                                                fontFamily: 'Segoeu',
                                                fontSize: 12.0)),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          const Text(
                                            "Exp: ",
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                donotpick = false;
                                                _selectDate(context);
                                                exp = selectedDate
                                                    .millisecondsSinceEpoch;
                                              });
                                            },
                                            child: Text(
                                              (donotpick)
                                                  ? "Non-expiring(tap to select a day)"
                                                  : DateFormat('dd-MMMM-yyyy ')
                                                      .format(selectedDate),
                                              overflow: TextOverflow.clip,
                                              style: style_state,
                                            ),
                                          ),
                                          (!donotpick)
                                              ? InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      donotpick = true;
                                                      exp = 0;
                                                    });
                                                  },
                                                  child: Icon(Icons.clear))
                                              : Container()
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text("Address",
                                          style: TextStyle(
                                            fontFamily: 'Segoeu',
                                            fontSize: 15,
                                          )),
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
                                                  fontFamily: 'Segoeu',
                                                  fontStyle: FontStyle.normal,
                                                );
                                              });
                                            },
                                            decoration: InputDecoration(
                                                hintText: "Enter your address",
                                                hintStyle: TextStyle(
                                                    fontFamily: 'Segoeu',
                                                    fontSize: 12.0)),
                                          )),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          RaisedButton(
                                            onPressed: onSeachBarButtonClick,
                                            padding: const EdgeInsets.all(10.0),
                                            child: const Text('Pick a place',
                                                style: TextStyle(
                                                    fontFamily: 'Segoeu',
                                                    fontSize: 13)),
                                          ),
                                          const Text("  Or  "),
                                          RaisedButton(
                                            padding: const EdgeInsets.all(10.0),
                                            onPressed:
                                                onGetCurrentLocationClick,
                                            child: const Text(
                                                'Get your location',
                                                style: TextStyle(
                                                    fontFamily: 'Segoeu',
                                                    fontSize: 13)),
                                          ),
                                        ],
                                      ),
                                      Text("Tags: ",
                                          style: TextStyle(
                                              fontFamily: 'Segoeu',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700)),
                                      InkWell(
                                        onTap: () async {
                                          final result = await Navigator.push(
                                              context,
                                              SlideRightRoute(
                                                  page:
                                                      ItemTypeList(indexList)));

                                          setState(() {
                                            tags = result[0];
                                            indexList = result[1];
                                          });
                                        },
                                        child: Text(
                                            (tags.toString() != "[]")
                                                ? tags.toString()
                                                : 'Pick tags',
                                            maxLines: null,
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(
                                                fontFamily: 'Segoeu',
                                                fontSize: 13)),
                                      ),
                                    ])),
                            SizedBox(
                              height: 10,
                            ),
                            RaisedButton(
                              padding: const EdgeInsets.all(10.0),
                              onPressed: submit,
                              child: const Text('Submit',
                                  style: TextStyle(
                                      fontFamily: 'Segoeu', fontSize: 17)),
                            )
                          ],
                        ),
                      ))
                ]))));
  }
}
