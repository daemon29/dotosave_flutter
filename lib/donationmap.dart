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
  @override
  _DonationMapState createState() => _DonationMapState();
}

class _DonationMapState extends State<DonationMap> {
  final GlobalKey<ScaffoldState> mapScaffold = GlobalKey<ScaffoldState>();
  Map<String, dynamic> markerInformation;
  String markerId = "";
  Map<String, String> _Infor_Org;
  bool campaignMarkerVisible = true;
  bool itemMarkerVisible = true;
  bool eventMarkerVisible = true;
  Set<Marker> markers = Set();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: mapScaffold,
        appBar: AppBar(
            backgroundColor: Color(0xfff5af19),
            title: const Text('Donation map'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false),
            )),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: (int index) {
            switch (index) {
              case 0: //search
                {
                  onSeachBarButtonClick();
                  break;
                }
              case 1: //mylocation
                {
                  onGetCurrentLocationClick();
                  break;
                }
              default:
                {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                              Row(),
                              Row(),
                              Row(),
                            ]));
                      });
                  break;
                }
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.search, color: Color.fromARGB(255, 0, 0, 0)),
              title: Text(
                "",
                style: TextStyle(fontSize: 0),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_searching,
                  color: Color.fromARGB(255, 0, 0, 0)),
              title: Text(
                "",
                style: TextStyle(fontSize: 0),
              ),
            ),
            BottomNavigationBarItem(
              title: Text(
                "",
                style: TextStyle(fontSize: 0),
              ),
              icon: Icon(Icons.visibility, color: Color.fromARGB(255, 0, 0, 0)),
            ),
          ],
        ),
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
      // show input autocomplete with selected mode
      // then get the Prediction selected
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
  }

  void createCampaignMarker(DocumentSnapshot doc) {
    //print("get it");
    GeoPoint geo = doc["geo"];
    Marker resultMarker = Marker(
      markerId: MarkerId(doc.documentID),
      visible: campaignMarkerVisible,
      icon: BitmapDescriptor.defaultMarkerWithHue(typeOfMarker(doc["type"])),
      onTap: () {
        setState(() {
          markerId = doc.documentID;
          title_txt = doc["title"];
          body_txt = doc["body"];
          address_txt = doc["address"];
        });
        mapScaffold.currentState.showBottomSheet((context) => Container(
            child: Padding(
                padding: const EdgeInsets.all(7.0),
                child: Container(
                    height: 300,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        new Flexible(
                            flex: 1,
                            child: Text(
                              title_txt,
                              //markerInformation[markerId]?.getTitle()??"",
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 21),
                            )),
                        new Flexible(
                            flex: 1,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 30,
                                  ),
                                  Text(
                                    address_txt,
                                    //markerInformation[markerId]?.getTitle()??"",
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                    ),
                                  )
                                ])),
                        new Flexible(
                            flex: 4,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  /*Icon(
                                  Icons.details,
                                  size: 30,
                                ),*/
                                  Text(
                                    body_txt,
                                    overflow: TextOverflow.clip,
                                    //softWrap: true,
                                    //markerInformation[markerId]?.getBody()??"",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal),
                                  )
                                ])),
                      ],
                    )))));
      },
      infoWindow:
          InfoWindow(title: typeOfMarker_(doc["type"]), snippet: doc["title"]),
      position: LatLng(geo.latitude, geo.longitude),
    );
    setState(() {
      markers.add(resultMarker);
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
      visible: campaignMarkerVisible,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      onTap: () {
        setState(() {
          markerId = doc.documentID;
          body_txt = doc["body"];
        });
      },
      infoWindow: InfoWindow(title: "Item", snippet: doc["body"]),
      position: LatLng(geo.latitude, geo.longitude),
    );
    setState(() {
      markers.add(resultMarker);
    });
  }
}
