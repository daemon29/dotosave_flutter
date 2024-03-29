import 'dart:core';
import 'dart:io';

import 'package:LadyBug/Customize/MultiLanguage.dart';
import 'package:LadyBug/Widgets/ItemtypeList.dart';
import 'package:LadyBug/Widgets/SlideRightRoute.dart';
import 'package:LadyBug/Widgets/TagsList.dart';
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
  List<bool> itemIndexList = List.filled(itemTypeList.length, false);
  List<bool> indexList = List.filled(tagsList.length, false);
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: place_api);
  GeoPoint geoPoint;
  bool _visible = false;
  bool _vol = false, _do = false;
  int _selectedType = 2;
  bool isDisable = false;
  bool _pickaplacevisibility = true;
  String _address = captions[setLanguage]["youraddresswillshowuphere!"];
  TextStyle style_state = TextStyle(
    fontStyle: FontStyle.italic,
  );
  List<String> organizer = [], tags = [], itemtags = [];
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

  DateTime startDate = DateTime.now(), endDate = DateTime.now();
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: startDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != startDate)
      setState(() {
        startDate = picked;
      });
  }

  Future<Null> __selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: endDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != endDate)
      setState(() {
        endDate = picked;
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

  List<Widget> _getChip2(List<dynamic> tags) {
    List listings = new List<Widget>();
    for (int i = 0; i < tags.length; ++i) {
      listings.add(new Chip(label: Text(itemTagsMap[setLanguage][tags[i]])));
    }
    return listings;
  }

  bool notpicked1 = true, notpicked2 = true;
  String imageurl;

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
            Firestore.instance.collection("Campaign").document().setData({
              'title': title.text,
              "introduction": introduction.text,
              'detail': detail.text,
              "imageurl": url,
              'address': _address,
              'startDate':
                  (notpicked1) ? null : startDate.millisecondsSinceEpoch,
              'endDate': (notpicked2) ? null : endDate.millisecondsSinceEpoch,
              'organizer': organizer,
              "geo": geoPoint,
              'tag': tags,
              'itemtag': _do ? itemtags : [],
              'needvol': _vol,
              'needdonor': _do,
              'type': _selectedType,
              'timestamp': DateTime.now().millisecondsSinceEpoch
            }).then((onValue) {
              this.setState(() {
                _busy = false;
              });
              Fluttertoast.showToast(
                msg: "Upload success",
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
            msg: "This file is not an image",
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
          title: Text(
            captions[setLanguage]['createcampaign'],
          ),
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
                        tooltip: captions[setLanguage]['removeimage'],
                        onPressed: () {
                          setState(() {
                            _visible = false;
                          });
                        },
                        iconSize: 32,
                      ),
                    ),
                  ],
                ))),
            Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: RaisedButton(
                  child: Row(children: [
                    Icon(
                      Icons.image,
                      size: 32,
                    ),
                    Text(
                      captions[setLanguage]["addabanner!"],
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
                child: Text(captions[setLanguage]["title"],
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
                      hintText: captions[setLanguage]['Enter a title/name...']),
                )),
            Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(captions[setLanguage]["introduction"],
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
                      hintText: captions[setLanguage]['introduceyourcampaign']),
                )),
            Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(captions[setLanguage]["detail"],
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
                      border: InputBorder.none,
                      hintText: captions[setLanguage]['tellmore']),
                )),
            Padding(
                padding: EdgeInsets.only(left: 10),
                child: Row(children: [
                  Text(captions[setLanguage]['from'] + ": ",
                      style: TextStyle(
                          fontFamily: 'Segoeu',
                          fontSize: 16,
                          fontWeight: FontWeight.w700)),
                  InkWell(
                    onTap: () {
                      _selectDate(context);
                      setState(() {
                        notpicked1 = false;
                      });
                    },
                    child: notpicked1
                        ? Text(captions[setLanguage]['selectaday'])
                        : Text(DateFormat("dd/MM/yyyy").format(startDate)),
                  ),
                  (!notpicked1)
                      ? InkWell(
                          onTap: () {
                            setState(() {
                              notpicked1 = true;
                            });
                          },
                          child: Icon(Icons.clear))
                      : Container()
                ])),
            Padding(
                padding: EdgeInsets.only(left: 10),
                child: Row(children: [
                  Text(captions[setLanguage]['to'] + ": ",
                      style: TextStyle(
                          fontFamily: 'Segoeu',
                          fontSize: 16,
                          fontWeight: FontWeight.w700)),
                  InkWell(
                    onTap: () {
                      __selectDate(context);
                      setState(() {
                        notpicked2 = false;
                      });
                    },
                    child: notpicked2
                        ? Text(captions[setLanguage]['selectaday'])
                        : Text(DateFormat("dd/MM/yyyy").format(endDate)),
                  ),
                  (!notpicked2)
                      ? InkWell(
                          onTap: () {
                            setState(() {
                              notpicked2 = true;
                            });
                          },
                          child: Icon(Icons.clear))
                      : Container()
                ])),
            SizedBox(
              width: 10,
            ),

            Padding(
                padding: EdgeInsets.only(left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                        child: RaisedButton(
                            onPressed: onSeachBarButtonClick,
                            padding: const EdgeInsets.all(0.0),
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(captions[setLanguage]['pickaplace'],
                                  style: TextStyle(
                                      fontFamily: 'Segoeu', fontSize: 13)),
                            ))),
                    const Text("  Or  "),
                    Flexible(
                        child: RaisedButton(
                            padding: const EdgeInsets.all(0.0),
                            onPressed: onGetCurrentLocationClick,
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                  captions[setLanguage]['getyourlocation'],
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
                    maxLines: null,
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
                            fontStyle: FontStyle.normal,
                          );
                        });
                      },
                      decoration: InputDecoration(
                          hintText: captions[setLanguage]['enteryouraddress'],
                          hintStyle:
                              TextStyle(fontFamily: 'Segoeu', fontSize: 12.0)),
                    ))),
            Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Row(children: <Widget>[
                  Flexible(
                      child: Text(captions[setLanguage]['type'],
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
                        child: Text(captions[setLanguage]['campaign']),
                      ),
                      DropdownMenuItem(
                        value: 1,
                        child: Text(captions[setLanguage]['event']),
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
                    Flexible(
                        child: Text(captions[setLanguage]["needvolunteers"])),
                    Flexible(
                        child: Checkbox(
                      value: _do,
                      onChanged: (value) {
                        setState(() {
                          _do = value;
                        });
                      },
                    )),
                    Flexible(child: Text(captions[setLanguage]["needdonors"])),
                  ],
                )),
            Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child:
                    //TODO choose tags
                    Visibility(
                  visible: _do,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: InkWell(
                      onTap: () async {
                        final result = await Navigator.push(context,
                            SlideRightRoute(page: ItemTypeList(itemIndexList)));

                        setState(() {
                          itemtags = result[0];
                          itemIndexList = result[1];
                        });
                      },
                      child: (itemtags.toString() != "[]")
                          ? Wrap(
                              children: _getChip(itemtags),
                            )
                          : Text(captions[setLanguage]['picktags'],
                              maxLines: null,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                  fontFamily: 'Segoeu', fontSize: 13)),
                    ),
                  ),
                )),

            Padding(
                padding: EdgeInsets.all(10),
                child: Text("Tags: ",
                    style: TextStyle(
                        fontFamily: 'Segoeu',
                        fontSize: 16,
                        fontWeight: FontWeight.w700))),
            Padding(
              padding: EdgeInsets.all(10),
              child: InkWell(
                onTap: () async {
                  final result = await Navigator.push(
                      context, SlideRightRoute(page: TagsList(indexList)));

                  setState(() {
                    tags = result[0];
                    indexList = result[1];
                  });
                },
                child: (tags.toString() != "[]")
                    ? Wrap(
                        children: _getChip2(tags),
                      )
                    : Text(captions[setLanguage]['picktags'],
                        maxLines: null,
                        overflow: TextOverflow.clip,
                        style: TextStyle(fontFamily: 'Segoeu', fontSize: 13)),
              ),
            ),
            RaisedButton(
              onPressed: (isDisable)
                  ? null
                  : () {
                      setState(() {
                        isDisable = true;
                      });
                      submit();
                    },
              child: Text(captions[setLanguage]['create!'],
                  style: TextStyle(fontSize: 16)),
            ),
          ],
        ));
  }
}
