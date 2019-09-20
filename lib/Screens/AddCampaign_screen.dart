import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';

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
  bool _vol = false, _do = false;
  int _selectedType = 2;
  bool _pickaplacevisibility = true;
  String _address = "Your address will show up here!";
  TextStyle style_state = TextStyle(
    fontStyle: FontStyle.italic,
  );
  void onCreateButtonClick() {}
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("Create Campaign"),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: Text("Your campaign/event name"),
            ),
            Flexible(
                child: TextField(
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: 'Enter a title/name...'),
            )),
            Flexible(
              child: Text("Introduction"),
            ),
            Flexible(
                child: TextField(
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: 'Enter a title/name...'),
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                RaisedButton(
                    textColor: Colors.white,
                    onPressed: onSeachBarButtonClick,
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      decoration: const BoxDecoration(color: Color(0xfff5af19)
                          /* gradient: LinearGradient(colors: <Color>[
                                    Color(0xfff12711),
                                    Color(0xfff5af19)
                                  ])*/
                          ),
                      padding: const EdgeInsets.all(10.0),
                      child: const Text('Pick a place',
                          style: TextStyle(fontSize: 13)),
                    )),
                const Text("  Or  "),
                RaisedButton(
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(0.0),
                    onPressed: onGetCurrentLocationClick,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xfff5af19),
                        /*gradient: LinearGradient(colors: <Color>[
                                        Color(0xfff12711),
                                        Color(0xfff5af19)
                                      ])*/
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: const Text('Get your location',
                          style: TextStyle(fontSize: 13)),
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
                      hintText: "Enter your address",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                )),
            Flexible(
              child: Text("This is a"),
            ),
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
            //TO DO add organizers here !!!
            //
            //
            //
            Flexible(
              child: Row(
                children: <Widget>[
                  Checkbox(
                    value: _vol,
                    onChanged: (value) {
                      setState(() {
                        _vol = value;
                      });
                    },
                  ),
                  Text("Search for volunteers"),
                ],
              ),
            ),
            Flexible(
              child: Row(
                children: <Widget>[
                  Checkbox(
                    value: _do,
                    onChanged: (value) {
                      setState(() {
                        _do = value;
                      });
                    },
                  ),
                  Text("Search for donors"),
                ],
              ),
            ),
            //TODO choose tags
            Visibility(
              visible: _do,
              child: Text("Things you need?"),
            ),
            Flexible(
              child: RaisedButton(
                onPressed: onCreateButtonClick,
                child: Text("Create"),
              ),
            )
          ],
        ));
  }
}
