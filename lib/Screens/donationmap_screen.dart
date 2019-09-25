import 'dart:async';
import 'package:LadyBug/Customize/MultiLanguage.dart';
import 'package:LadyBug/Screens/Campaign_screen.dart';
import 'package:LadyBug/Screens/Item_infomation_screen.dart';
import 'package:LadyBug/Widgets/SlideRightRoute.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

const place_api = 'AIzaSyApNZMEtoLsnu0ANWqepMBZUbCHbMMkP38';

class DonationMap extends StatefulWidget {
  final String currentUserId;
  DonationMap(this.currentUserId);
  @override
  _DonationMapState createState() => _DonationMapState(currentUserId);
}

class _DonationMapState extends State<DonationMap> {
  final String currentUserId;

  final GlobalKey<ScaffoldState> mapScaffold = GlobalKey<ScaffoldState>();
  _DonationMapState(this.currentUserId);

  Map<String, dynamic> markerInformation;
  String markerId = "";
  Map<String, String> _Infor_Org;
  bool campaignMarkerVisible = true;
  bool itemMarkerVisible = true;
  bool eventMarkerVisible = true;
  Set<Marker> markers = Set();
  Set<Marker> imarkers = Set();
  Set<Marker> cmarkers = Set();
  Set<Marker> emarkers = Set();
  String title_txt = "";
  String body_txt = "";
  String address_txt = "";
  String exp_txt = "";
  double radius = 5000;
  //String _text = "empty";
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: place_api);
  GoogleMapController mapController;
  Position userLocation;
  //Geoflutterfire geo = Geoflutterfire();
  Firestore _firestore = Firestore.instance;
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    getLastKnownLocation();
  }

/*
  Set<Marker> getMarkerSet() {
    Set temp = imarkers;
    temp.union(emarkers);
    temp.union(cmarkers);
    return temp;
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: mapScaffold,
        /*endDrawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              ListTile(
                  leading: Icon(
                    Icons.visibility,
                    color: Colors.black,
                  ),
                  title: Text(
                    'Visibility',
                    style: TextStyle(fontFamily: 'Segoeu', color: Colors.black),
                  ),
                  onTap: null),
              ListTile(
                leading: (eventMarkerVisible == true)
                    ? Icon(
                        Icons.check_box,
                      )
                    : Icon(
                        Icons.check_box_outline_blank,
                      ),
                title: Text('Events',
                    style: TextStyle(
                        fontFamily: 'Segoeu', color: Colors.grey[700])),
                onTap: () {
                  setState(() {
                    //  markers = getMarkerSet();
                    eventMarkerVisible = !eventMarkerVisible;
                  });
                },
              ),
              ListTile(
                  leading: campaignMarkerVisible == true
                      ? Icon(Icons.check_box)
                      : Icon(
                          Icons.check_box_outline_blank,
                        ),
                  title:
                      Text('Campain', style: TextStyle(fontFamily: 'Segoeu')),
                  onTap: () {
                    setState(() {
                      //   markers = getMarkerSet();
                      campaignMarkerVisible = !campaignMarkerVisible;
                    });
                  }),
              ListTile(
                leading: (itemMarkerVisible == true)
                    ? Icon(Icons.check_box)
                    : Icon(Icons.check_box_outline_blank),
                title: Text('Items',
                    style: TextStyle(
                        fontFamily: 'Segoeu', color: Colors.grey[700])),
                onTap: () {
                  setState(() {
                    // markers = getMarkerSet();
                    itemMarkerVisible = !itemMarkerVisible;
                  });
                },
              )
            ],
          ),
        ),*/
        appBar: AppBar(
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  onSeachBarButtonClick();
                },
              ),
              IconButton(
                icon: Icon(Icons.my_location),
                onPressed: () {
                  onGetCurrentLocationClick();
                },
              ),
            ],
            title: Text(
              captions[setLanguage]['map'],
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false),
            )),
        body: Container(
            child: Stack(children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            markers: markers,
            initialCameraPosition: CameraPosition(
              target: new LatLng(10.82302, 106.62965),
              zoom: 11.0,
            ),
          ),
        ])));
  }

  void onError(PlacesAutocompleteResponse response) {}

  Future<void> onSeachBarButtonClick() async {
    try {
      Prediction p = await PlacesAutocomplete.show(
        context: context,
        apiKey: place_api,
        onError: onError,
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
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;
      LatLng temp = new LatLng(lat, lng);
      var controller = mapController;
      controller.animateCamera(CameraUpdate.newLatLngZoom(temp, 19));
      return temp;
    }
  }

  Future<void> onGetCurrentLocationClick() async {
    userLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    mapController.animateCamera(CameraUpdate.newLatLngZoom(
        new LatLng(userLocation.latitude, userLocation.longitude), 18));
    createMarkerList(userLocation, 5000);
  }

  Future<void> getLastKnownLocation() async {
    userLocation = await Geolocator().getLastKnownPosition();
    mapController.animateCamera(CameraUpdate.newLatLngZoom(
        new LatLng(userLocation.latitude, userLocation.longitude), 18));
    createMarkerList(userLocation, 5000);
  }

  void createMarkerList(Position location, double radius) {
    radius = radius * 0.000621371;
    double lat = 0.0144927536231884;
    double lon = 0.0181818181818182;

    double lowerLat = location.latitude - (lat * radius);
    double lowerLon = location.longitude - (lon * radius);

    double greaterLat = location.latitude + (lat * radius);
    double greaterLon = location.longitude + (lon * radius);
    GeoPoint a;
    _firestore
        .collection('Campaign')
        .where("geo", isGreaterThan: GeoPoint(lowerLat, lowerLon))
        .where("geo", isLessThan: GeoPoint(greaterLat, greaterLon))
        .snapshots()
        .listen((data) =>
            data.documents.forEach((doc) => createCampaignMarker(doc)));
    _firestore
        .collection('Item')
        .where("geo", isGreaterThan: GeoPoint(lowerLat, lowerLon))
        //.where("geo/Latitude", isGreaterThan: lowerLat)
        //.where("geo/Longitude", isGreaterThan: lowerLon)
        .where("geo", isLessThan: GeoPoint(greaterLat, greaterLon))
        //.where("geo/Latitude", isLessThan: greaterLat)
        //.where("geo/Longitude", isLessThan: greaterLon)
        .snapshots()
        .listen(
            (data) => data.documents.forEach((doc) => createItemMarker(doc)));
    setState(() {
      // markers;
    });
  }

  void createCampaignMarker(DocumentSnapshot doc) {
    //print("get it");
    GeoPoint geo = doc["geo"];
    Marker resultMarker = Marker(
      markerId: MarkerId(doc.documentID),
      visible: true,
      icon: BitmapDescriptor.defaultMarkerWithHue(typeOfMarker(doc["type"])),
      onTap: () {
        setState(() {
          markerId = doc.documentID;
          title_txt = doc["title"];
          body_txt = doc["introduction"];
          address_txt = doc["address"];
          exp_txt = (doc['startDate'] != null)
              ? ('' +
                  DateFormat("dd/MM/yyyy").format(
                      DateTime.fromMillisecondsSinceEpoch(doc['startDate'])))
              : "";
          exp_txt += (doc['endDate'] != null)
              ? (((doc['startDate'] != null) ? ' to ' : "Until ") +
                  DateFormat("dd/MM/yyyy").format(
                      DateTime.fromMillisecondsSinceEpoch(doc['endDate'])))
              : "";
        });
        mapScaffold.currentState.showBottomSheet(
            (context) => InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      SlideRightRoute(
                          page: CampaignScreen(
                              doc.data, doc.documentID, currentUserId)));
                },
                child: Card(
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 250,
                        child: Column(children: <Widget>[
                          Flexible(
                              child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(5),
                            child: Text(title_txt,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                    fontFamily: 'Segoeu',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 19)),
                          ) //)
                              ),
                          (exp_txt == "")
                              ? Container()
                              : Text(
                                  exp_txt,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.location_on,
                                  size: 17,
                                ),
                                Flexible(
                                    child: Text(
                                  address_txt,
                                  //markerInformation[markerId]?.getTitle()??"",
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    fontFamily: 'Segoeu',
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ))
                              ]),
                          Divider(
                            indent: 10,
                            endIndent: 10,
                          ),
                          Flexible(
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    "  " + body_txt,
                                    overflow: TextOverflow.clip,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontFamily: 'Segoeu',
                                        fontWeight: FontWeight.normal,
                                        fontSize: 13),
                                  )))
                        ])))),
            backgroundColor: Colors.transparent);
      },
      infoWindow: InfoWindow(
          title: captions[setLanguage][typeOfMarker_(doc["type"])],
          snippet: doc["title"]),
      position: LatLng(geo.latitude, geo.longitude),
    );
    setState(() {
      if (doc["type"] == 1)
        markers.add(resultMarker);
      else
        markers.add(resultMarker);
    });
  }

  String typeOfMarker_(int type) {
    switch (type) {
      case 1:
        return "event";
      case 2:
        return "campaign";
    }
  }

  double typeOfMarker(int type) {
    switch (type) {
      case 1:
        return 0;
      case 2:
        return 0;
    }
  }

  void createItemMarker(DocumentSnapshot doc) {
    //print("get it");
    GeoPoint geo = doc["geo"];
    Marker resultMarker = Marker(
      markerId: MarkerId(doc.documentID),
      visible: true,
      icon: BitmapDescriptor.defaultMarkerWithHue(25),
      onTap: () {
        setState(() {
          markerId = doc.documentID;
          title_txt = doc["title"];
          address_txt = doc['address'];
          body_txt = doc["describe"];
          exp_txt = (doc['exp'] == null)
              ? ""
              : DateFormat("dd/MM/yyyy")
                  .format(DateTime.fromMillisecondsSinceEpoch(doc['exp']));
        });
        mapScaffold.currentState.showBottomSheet(
            (context) => InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      SlideRightRoute(
                          page:
                              ItemInformationScreen(doc.data, currentUserId)));
                },
                child: Card(
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 220,
                        child: Column(children: <Widget>[
                          Flexible(
                              child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    title_txt,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ) //)
                                  )),
                          Text(
                            'Exp: ' + exp_txt,
                            textAlign: TextAlign.start,
                            maxLines: null,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.location_on,
                                  size: 17,
                                ),
                                Flexible(
                                    child: Text(
                                  address_txt,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ))
                              ]),
                          Divider(
                            indent: 10,
                            endIndent: 10,
                          ),
                          Flexible(
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    "  " + body_txt,
                                    overflow: TextOverflow.clip,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 13),
                                  )))
                        ])))),
            backgroundColor: Colors.transparent);
      },
      infoWindow: InfoWindow(
          title: captions[setLanguage]["item"], snippet: doc["title"]),
      position: LatLng(geo.latitude, geo.longitude),
    );
    setState(() {
      markers.add(resultMarker);
    });
  }
}
