import 'package:flutter/material.dart';
import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(23.777176, 90.399452);
  final Set<Marker> _merkers = {};
  LatLng _lastMapPosition = _center;
  MapType _currentMapType = MapType.normal;

  static final CameraPosition _position = CameraPosition(
    bearing: 192.833,
    target: LatLng(23.777176, 90.399452),
    tilt: 59.440,
    zoom: 15.0,
  );

  Future<void> _goToPosition1() async{
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_position));
  }

  _onMapCreated(GoogleMapController controller){
    _controller.complete(controller);
  }
  _onCameraMove(CameraPosition position){
    _lastMapPosition = position.target;
  }

  _onMapButtonPressed(){
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite : MapType.normal;
    });
  }
  _onAddMarkerButtonPressed(){
    //print(title);
    setState(() {
      _merkers.add(Marker(
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        infoWindow: InfoWindow(
          title: 'Lat:23.777176, Lan:90.399452',
          snippet: 'Badhon',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
    print('setState() done');

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Google Map'),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
            mapType: _currentMapType,
            markers: _merkers,
            onCameraMove: _onCameraMove,
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Column(
                children: <Widget>[
                  IconButton(
                    color: Colors.blue,
                    icon: Icon(Icons.map,size: 40,),
                      onPressed: (){
                        _onMapButtonPressed();
                      },
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  IconButton(
                    color: Colors.blue,
                    icon: Icon(Icons.add_location,size: 40,),
                    onPressed: (){
                      _onAddMarkerButtonPressed();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: _goToPosition1,
          child: Icon(Icons.my_location,color: Colors.blue,size: 30,),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class FormDialog extends StatefulWidget {
  FormDialog({Key key}) : super(key: key);
  @override
  _FormDialogState createState() => _FormDialogState();
}

class _FormDialogState extends State<FormDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        onSubmitted: (value) => Navigator.pop(context, value),
        decoration: InputDecoration(
            hintText: 'Tape title of marker'
        ),
      ),
    );
  }
}


