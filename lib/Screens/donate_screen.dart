import 'dart:io';
import 'package:LadyBug/Customize/MultiLanguage.dart';
import 'package:LadyBug/Widgets/ItemtypeList.dart';
import 'package:LadyBug/Widgets/SlideRightRoute.dart';
import 'package:LadyBug/Widgets/TagsList.dart';
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
  List<bool> indexList = List.filled(itemTypeList.length, false);
  List<String> tags = [];
  Map<String, dynamic> modelClass = {
    'bicycle': 'Vehicle',
    'car': 'Vehicle',
    'motorcycle': 'Vehicle',
    'backpack': 'Bag',
    'umbrella': 'Household goods',
    'handbag': 'Bag',
    'tie': 'Clothes',
    'suitcase': 'Bag',
    'frisbee': 'Toys',
    'skis': 'Sport',
    'snowboard': 'Sport',
    'sports ball': 'Sport',
    'kite': 'Toys',
    'baseball bat': 'Sport',
    'baseball glove': 'Sport',
    'skateboard': 'Sport',
    'surfboard': 'Sport',
    'tennis racket': 'Sport',
    'bottle': 'Household goods',
    'wine glass': 'Household goods',
    'cup': 'Household goods',
    'fork': 'Household goods',
    'knife': 'Household goods',
    'spoon': 'Household goods',
    'bowl': 'Household goods',
    'banana': 'Food',
    'apple': 'Food',
    'sandwich': 'Food',
    'orange': 'Food',
    'broccoli': 'Food',
    'carrot': 'Food',
    'hot dog': 'Food',
    'pizza': 'Food',
    'donut': 'Food',
    'cake': 'Food',
    'chair': 'Household goods',
    'couch': 'Household goods',
    'potted plant': 'Decor',
    'bed': 'Household goods',
    'dining table': 'Household goods',
    'toilet': 'Household goods',
    'tv': 'Electronic',
    'laptop': 'Electronic',
    'mouse': 'Electronic',
    'remote': 'Electronic',
    'keyboard': 'Electronic',
    'cell phone': 'Electronic',
    'microwave': 'Household goods',
    'oven': 'Household goods',
    'toaster': 'Household goods',
    'sink': 'Household goods',
    'refrigerator': 'Household goods',
    'book': 'Books',
    'clock': 'Household goods',
    'vase': 'Decor',
    'scissors': 'Stationary',
    'teddy bear': 'Toys',
    'hair drier': 'Household goods',
    'toothbrush': 'Household goods'
  };
  File _image;
  TextStyle style_state = TextStyle(
    fontFamily: 'Segoeu',
    fontStyle: FontStyle.italic,
  );
  bool donotpick = true;
  bool _pickaplacevisibility = true;
  Set<String> items = new Set();
  String _model = ssd;
  String _address = captions[setLanguage]["youraddresswillshowuphere!"];
  List _recognitions;
  double _imageHeight;
  GeoPoint geoPoint;
  String title;
  bool isDisable = false;
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
            Firestore.instance.collection("Item").document().setData({
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
              Fluttertoast.showToast(
                msg: captions[setLanguage]["Upload success"],
                backgroundColor: Colors.deepOrange[700],
                textColor: Colors.white,
              );
              Navigator.pop(context);
            }).catchError((error) {
              this.setState(() {
                _busy = false;
              });
              Fluttertoast.showToast(
                msg: error.toString(),
                backgroundColor: Colors.deepOrange[700],
                textColor: Colors.white,
              );
            });
          }).catchError((error) {
            this.setState(() {
              _busy = false;
            });
            Fluttertoast.showToast(
              msg: error.toString(),
              backgroundColor: Colors.deepOrange[700],
              textColor: Colors.white,
            );
          });
        } else {
          setState(() {
            _busy = false;
          });
          Fluttertoast.showToast(
            msg: captions[setLanguage]["This file is not an image"],
            backgroundColor: Colors.deepOrange[700],
            textColor: Colors.white,
          );
        }
      }, onError: (err) {
        setState(() {
          _busy = false;
        });
        Fluttertoast.showToast(
          msg: err.toString(),
          backgroundColor: Colors.deepOrange[700],
          textColor: Colors.white,
        );
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

  List<Widget> _getChip(List<dynamic> tags) {
    List listings = new List<Widget>();
    for (int i = 0; i < tags.length; ++i) {
      listings
          .add(new Chip(label: Text(itemTypeListMap[setLanguage][tags[i]])));
    }
    return listings;
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
      if (re["detectedClass"] != "???") {
        if (!tags.contains(
          modelClass["${re["detectedClass"]}"],
        ))
          setState(() {
            tags.add(modelClass["${re["detectedClass"]}"]);
          });
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
              itemTypeListMap[setLanguage]
                  [modelClass["${re["detectedClass"]}"]],
              style: TextStyle(
                fontFamily: 'Segoeu',
                background: Paint()..color = blue,
                fontSize: 12.0,
              ),
            ),
          ),
        );
      }
      return Container();
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
          title: Text(
            captions[setLanguage]["donate"],
          ),
        ),
        bottomNavigationBar: null,
        body: new GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Card(
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
                                          child: Text(
                                              captions[setLanguage]
                                                  ["information"],
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Segoeu',
                                              ))),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text(captions[setLanguage]["title"],
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
                                            hintText: captions[setLanguage]
                                                ["titlehere..."],
                                            hintStyle: TextStyle(
                                                fontFamily: 'Segoeu',
                                                fontSize: 12.0)),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text(captions[setLanguage]['describe'],
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
                                            hintText: captions[setLanguage]
                                                ["describehere"],
                                            hintStyle: TextStyle(
                                                fontFamily: 'Segoeu',
                                                fontSize: 12.0)),
                                      ),
                                      SizedBox(
                                        height: 15,
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
                                          captions[setLanguage]["exp"] +
                                              ": " +
                                              ((donotpick)
                                                  ? captions[setLanguage]
                                                      ["non-exp"]
                                                  : DateFormat('dd-mm-yyyy ')
                                                      .format(selectedDate)),
                                          maxLines: null,
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
                                              child: Icon(
                                                Icons.clear,
                                                color: Colors.red,
                                              ))
                                          : Container(),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text(captions[setLanguage]["address"],
                                          style: TextStyle(
                                            fontFamily: 'Segoeu',
                                            fontSize: 15,
                                          )),
                                      Visibility(
                                        visible: _pickaplacevisibility,
                                        child: Text(
                                          _address,
                                          maxLines: null,
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
                                                hintText: captions[setLanguage]
                                                    ["enteryouraddress"],
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
                                            child: Text(
                                                captions[setLanguage]
                                                    ['pickaplace'],
                                                style: TextStyle(
                                                    fontFamily: 'Segoeu',
                                                    fontSize: 13)),
                                          ),
                                          Text("  " +
                                              captions[setLanguage]["or"] +
                                              "  "),
                                          RaisedButton(
                                            padding: const EdgeInsets.all(10.0),
                                            onPressed:
                                                onGetCurrentLocationClick,
                                            child: Text(
                                                captions[setLanguage]
                                                    ['getyourlocation'],
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
                                          for (int i = 0;
                                              i < indexList.length;
                                              ++i) {
                                            if (tags.contains(itemTypeList[i]))
                                              indexList[i] = true;
                                          }
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
                                        child: (tags.toString() != "[]")
                                            ? Wrap(
                                                children: _getChip(tags),
                                              )
                                            : Text(
                                                captions[setLanguage]
                                                    ['picktags'],
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
                              onPressed: (isDisable)
                                  ? null
                                  : () {
                                      submit();
                                      setState(() {
                                        isDisable = true;
                                      });
                                    },
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(captions[setLanguage]['submit'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontFamily: 'Segoeu'))),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ))
                ])))));
  }
}
