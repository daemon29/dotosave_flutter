import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const place_api = 'AIzaSyApNZMEtoLsnu0ANWqepMBZUbCHbMMkP38';
/*
class RoutesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        routes: {
          "/": (_) => DonationMap(),
        },
      );
}
*/

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

  Set<Marker> getMarkerSet() {
    Set<Marker> set1 = Set();
    Set<Marker> set2 = Set();
    Set<Marker> set3 = Set();
    return (itemMarkerVisible ? imarkers : set1).union(
        (eventMarkerVisible ? emarkers : set2)
            .union((campaignMarkerVisible ? cmarkers : set3)));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: mapScaffold,
        endDrawer: Drawer(
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
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: null),
              ListTile(
                leading: eventMarkerVisible
                    ? Icon(Icons.check_box, color: Colors.blue)
                    : Icon(
                        Icons.check_box,
                        color: Colors.grey[700],
                      ),
                title:
                    Text('Events', style: TextStyle(color: Colors.grey[700])),
                onTap: () {
                  setState(() {
                    eventMarkerVisible = !eventMarkerVisible;
                    markers = getMarkerSet();
                  });
                },
              ),
              ListTile(
                  leading: campaignMarkerVisible
                      ? Icon(Icons.check_box, color: Colors.blue)
                      : Icon(
                          Icons.check_box,
                          color: Colors.grey[700],
                        ),
                  title: Text('Campain',
                      style: TextStyle(color: Colors.grey[700])),
                  onTap: () {
                    setState(() {
                      campaignMarkerVisible = !campaignMarkerVisible;
                      markers = getMarkerSet();
                    });
                  }),
              ListTile(
                leading: itemMarkerVisible
                    ? Icon(Icons.check_box, color: Colors.blue)
                    : Icon(
                        Icons.check_box,
                        color: Colors.grey[700],
                      ),
                title: Text('Items', style: TextStyle(color: Colors.grey[700])),
                onTap: () {
                  setState(() {
                    itemMarkerVisible = !itemMarkerVisible;
                    markers = getMarkerSet();
                  });
                },
              )
            ],
          ),
        ),
        appBar: AppBar(
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search, color: Colors.white),
                onPressed: () {
                  onSeachBarButtonClick();
                },
              ),
              IconButton(
                icon: Icon(Icons.my_location, color: Colors.white),
                onPressed: () {
                  onGetCurrentLocationClick();
                },
              ),
            ],
            backgroundColor: Colors.blue,
            title: const Text('Donation map'),
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
      // get detail (lat/lng)
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
        //.where("geo/Latitude", isGreaterThan: lowerLat)
        //.where("geo/Longitude", isGreaterThan: lowerLon)
        .where("geo", isLessThan: GeoPoint(greaterLat, greaterLon))
        //.where("geo/Latitude", isLessThan: greaterLat)
        //.where("geo/Longitude", isLessThan: greaterLon)
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
      markers = getMarkerSet();
    });
  }

  void createCampaignMarker(DocumentSnapshot doc) {
    //print("get it");
    GeoPoint geo = doc["geo"];
    Marker resultMarker = Marker(
      markerId: MarkerId(doc.documentID),
      visible: doc["type"] == 2 ? campaignMarkerVisible : eventMarkerVisible,
      icon: BitmapDescriptor.defaultMarkerWithHue(typeOfMarker(doc["type"])),
      onTap: () {
        setState(() {
          markerId = doc.documentID;
          title_txt = doc["title"];
          body_txt = doc["introduction"];
          address_txt = doc["address"];
        });
        mapScaffold.currentState.showBottomSheet((context) => InkWell(
            onTap: () {},
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: Column(children: <Widget>[
                  Flexible(
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          color: Colors.blue,
                          padding: EdgeInsets.all(5),
                          child: Text(
                            title_txt,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 21),
                          ) //)
                          )),
                  SizedBox(
                    height: 3,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Icon(
                      Icons.location_on,
                      size: 27,
                      color: Colors.blue,
                    ),
                    Flexible(
                        child: Text(
                      address_txt,
                      //markerInformation[markerId]?.getTitle()??"",
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.normal,
                      ),
                    ))
                  ]),
                  Divider(
                    color: Colors.blue,
                  ),
                  Text(
                    "  " + body_txt,
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.start,
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 17),
                  )
                ]))));
      },
      infoWindow:
          InfoWindow(title: typeOfMarker_(doc["type"]), snippet: doc["title"]),
      position: LatLng(geo.latitude, geo.longitude),
    );
    setState(() {
      if (doc["type"] == 1)
        emarkers.add(resultMarker);
      else
        cmarkers.add(resultMarker);
    });
  }

  String typeOfMarker_(int type) {
    switch (type) {
      case 1:
        return "Event";
      case 2:
        return "Campaign";
    }
  }

  double typeOfMarker(int type) {
    switch (type) {
      case 1:
        return BitmapDescriptor.hueGreen;
      case 2:
        return BitmapDescriptor.hueCyan;
    }
  }

  void createItemMarker(DocumentSnapshot doc) {
    //print("get it");
    GeoPoint geo = doc["geo"];
    Marker resultMarker = Marker(
      markerId: MarkerId(doc.documentID),
      visible: itemMarkerVisible,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      onTap: () {
        setState(() {
          markerId = doc.documentID;
          body_txt = doc["describe"];
        });
      },
      infoWindow: InfoWindow(title: "Item", snippet: doc["title"]),
      position: LatLng(geo.latitude, geo.longitude),
    );
    setState(() {
      imarkers.add(resultMarker);
    });
  }
}
