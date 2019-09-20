import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const place_api = 'AIzaSyApNZMEtoLsnu0ANWqepMBZUbCHbMMkP38';

class AddCampaign extends StatefulWidget {
  final String oid;

  AddCampaign(this.oid);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddCampaignState(oid);
  }
}

class AddCampaignState extends State<AddCampaign> {
  final String oid;
  AddCampaignState(this.oid);
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: place_api);
  GeoPoint geoPoint;
  bool _visible = false;
  bool _vol = false, _do = false;
  int _selectedType = 2;
  bool _pickaplacevisibility = true;
  String _address = "Your address will show up here!";
  TextStyle style_state = TextStyle(
    fontFamily: 'Segoeu',
    fontStyle: FontStyle.italic,
  );
  List<String> organizer = [], tags = [];
  bool _busy = false;
  File _image;
  final title = TextEditingController(),
      introduction = TextEditingController(),
      detail = TextEditingController();
  @override
  void initState() {
    organizer.add(oid);
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    title.dispose();
    introduction.dispose();
    detail.dispose();
    super.dispose();
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

  bool notpicked1 = true, notpicked2 = true;
  String imageurl;
  int startDate, endDate;
  Future submit() async {
    this.setState(() {
      _busy = true;
    });
    if (_image == null || introduction == null || detail == null) {
      this.setState(() {
        _busy = false;
      });
      return;
    } else {
      var uuid = new Uuid();
      String filename = oid + uuid.v1();
      StorageReference reference =
          FirebaseStorage.instance.ref().child('Campaign/$filename');
      StorageUploadTask uploadTask = reference.putFile(_image);
      StorageTaskSnapshot storageTaskSnapshot;
      uploadTask.onComplete.then((value) {
        if (value.error == null) {
          storageTaskSnapshot = value;
          storageTaskSnapshot.ref.getDownloadURL().then((url) {
            GeoPoint geoPoint = GeoPoint(90, -90);
            Firestore.instance.collection("Campaign").document().setData({
              'title': title.text,
              "introduction": introduction.text,
              'detail': detail.text,
              "imageurl": url,
              'address': _address,
              'startDate': startDate,
              'endDate': endDate,
              'organizer': organizer,
              "geo": geoPoint,
              'tags': tags,
              'needvol': _vol,
              'needdonor': _do,
              'type': _selectedType
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

  Image getImage(var _file) {
    if (_file == null)
      return Image.asset(
        "Images/image_02.png",
      );
    else {
      return Image.file(
        _file,
      );
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("Create Campaign",
              style: const TextStyle(
                fontSize: 22,
                fontFamily: 'Manjari',
              )),
        ),
        body: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Visibility(
                visible: _visible,
                child: Container(
                    child: Stack(
                  children: [
                    getImage(_image),
                    Positioned(
                      right: 2,
                      top: 2,
                      child: IconButton(
                        icon: Icon(Icons.close),
                        tooltip: 'Remove image',
                        onPressed: () {
                          setState(() {
                            _visible = false;
                          });
                        },
                        iconSize: 32,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ))),
            Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: RaisedButton(
                  color: Colors.blue,
                  child: Row(children: [
                    Icon(
                      Icons.image,
                      color: Colors.white,
                      size: 32,
                    ),
                    Text(
                      " Add a banner!",
                      style: TextStyle(color: Colors.white),
                    )
                  ]),
                  onPressed: () async {
                    var image = await ImagePicker.pickImage(
                        source: ImageSource.gallery, imageQuality: 10);
                    if (image == null) return;
                    setState(() {
                      _image = image;
                      _visible = true;
                    });
                  },
                )),
            Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text("Title",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ))),
            Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: TextField(
                  controller: title,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter a title/name...'),
                )),
            Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text("Introduction",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
            Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: TextFormField(
                  controller: introduction,
                  maxLength: 160,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Introduce your campaign...'),
                )),
            Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text("Detail",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
            Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: TextFormField(
                  controller: detail,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  maxLength: 700,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: 'Tell more...'),
                )),
            Padding(
                padding: EdgeInsets.only(left: 10),
                child: Row(children: [
                  RaisedButton(
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(10.0),
                    color: Colors.blue,
                    onPressed: () {
                      _selectDate(context);
                      setState(() {
                        notpicked1 = false;
                        startDate = selectedDate.millisecondsSinceEpoch;
                      });
                    },
                    child: const Text('Start date',
                        style: TextStyle(fontSize: 13)),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                      child: notpicked1
                          ? Text("")
                          : Text(DateFormat("dd MMMM yyyy").format(
                              DateTime.fromMillisecondsSinceEpoch(startDate))))
                ])),
            Padding(
                padding: EdgeInsets.only(left: 10),
                child: Row(children: [
                  RaisedButton(
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(10.0),
                    color: Colors.blue,
                    onPressed: () {
                      _selectDate(context);
                      setState(() {
                        notpicked2 = false;
                        endDate = selectedDate.millisecondsSinceEpoch;
                      });
                    },
                    child:
                        const Text('End date', style: TextStyle(fontSize: 13)),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                      child: notpicked2
                          ? Text("")
                          : Text(DateFormat("dd MMMM yyyy").format(
                              DateTime.fromMillisecondsSinceEpoch(endDate))))
                ])),
            Padding(
                padding: EdgeInsets.only(left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                        child: RaisedButton(
                            textColor: Colors.white,
                            onPressed: onSeachBarButtonClick,
                            padding: const EdgeInsets.all(0.0),
                            child: Container(
                              color: Colors.blue,
                              padding: const EdgeInsets.all(10.0),
                              child: const Text('Pick a place',
                                  style: TextStyle(
                                      fontFamily: 'Segoeu', fontSize: 13)),
                            ))),
                    const Text("  Or  "),
                    Flexible(
                        child: RaisedButton(
                            textColor: Colors.white,
                            padding: const EdgeInsets.all(0.0),
                            onPressed: onGetCurrentLocationClick,
                            child: Container(
                              color: Colors.blue,
                              padding: const EdgeInsets.all(10.0),
                              child: const Text('Get your location',
                                  style: TextStyle(
                                      fontFamily: 'Segoeu', fontSize: 13)),
                            )))
                  ],
                )),
            Visibility(
              visible: _pickaplacevisibility,
              child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    _address,
                    overflow: TextOverflow.clip,
                    style: style_state,
                  )),
            ),
            Visibility(
                visible: !_pickaplacevisibility,
                child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
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
                              color: Colors.grey,
                              fontSize: 12.0)),
                    ))),
            Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Row(children: <Widget>[
                  Flexible(
                      child: Text("Type: ",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ))),
                  Flexible(
                      child: DropdownButton(
                    onChanged: (int selected) {
                      setState(() {
                        _selectedType = selected;
                      });
                    },
                    value: _selectedType,
                    items: [
                      DropdownMenuItem(
                        value: 2,
                        child: Text("Campaign"),
                      ),
                      DropdownMenuItem(
                        value: 1,
                        child: Text("Event"),
                      )
                    ],
                  )),
                ])),
            //TO DO add organizers here !!!
            //
            //
            //
            Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  children: <Widget>[
                    Flexible(
                        child: Checkbox(
                      value: _vol,
                      onChanged: (value) {
                        setState(() {
                          _vol = value;
                        });
                      },
                    )),
                    Flexible(child: Text("Need volunteers")),
                    Flexible(
                        child: Checkbox(
                      value: _do,
                      onChanged: (value) {
                        setState(() {
                          _do = value;
                        });
                      },
                    )),
                    Flexible(child: Text("Need donors")),
                  ],
                )),
            Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child:
                    //TODO choose tags
                    Visibility(
                  visible: _do,
                  child: Text("What do you need?",
                      style: TextStyle(
                        fontSize: 16,
                      )),
                )),
            RaisedButton(
              color: Colors.blue,
              onPressed: () {
                submit();
              },
              child: Text("Create!",
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ));
  }
}
