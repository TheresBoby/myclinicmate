import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'models/doctors.dart';
import 'models/global.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
              myLocationButtonEnabled: false,
            ),
            Container(
              margin: EdgeInsets.only(bottom: 400),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 20.0,
                      ),
                    ],
                    color: Colors.white,
                  ),
                  height: 50,
                  width: 300,
                  child: TextField(
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      hintText: "What are you looking for?",
                      hintStyle: TextStyle(fontFamily: 'Gotham', fontSize: 15),
                      icon: Icon(Icons.search, color: Colors.black),
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent))
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 550, bottom: 50),
              child: ListView(
                padding: EdgeInsets.only(left: 20),
                children: getDoctorsInArea(),
                scrollDirection: Axis.horizontal,
              ),
            )
          ],
        )
      ),
    );
  }

  List<Doctor> getDoctors() {
    List<Doctor> doctors = [];
    for (int i = 0; i < 10; i++) {
      AssetImage profilePic = const AssetImage("lib/assets/doctors.jpg");
      Doctor doctor = Doctor(
        "Dr. Smith",
        "070-379-031",
        "First road 23 elm street",
        529.3,
        4,
        "Available",
        profilePic,
        "Pediatrician",
      );
      doctors.add(doctor);
    }
    return doctors;
  }

  List<Widget> getDoctorsInArea() {
    List<Doctor> doctors = getDoctors();
    List<Widget> cards = [];
    for (Doctor doctor in doctors) {
      cards.add(doctorCard(doctor));
    }
    return cards;
  }
}

Widget doctorCard(Doctor doctor) {
  return Container(
    padding: EdgeInsets.all(10),
    margin: EdgeInsets.only(right: 20),
    width: 180,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey,
          blurRadius: 20.0,
        ),
      ],
    ),
    child: Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              child: CircleAvatar(
                backgroundImage: doctor.profilePic,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(doctor.name, style: techCardTitleStyle),
                Text(doctor.specialization, style: techCardSubTitleStyle),
              ],
            )
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: 30),
          child: Row(
            children: <Widget>[
              Text("Status:  ", style: techCardSubTitleStyle),
              Text(doctor.status, style: statusStyles[doctor.status])
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text("Rating: " + doctor.rating.toString(), style: techCardSubTitleStyle),
                ],
              ),
              Row(
                children: getRatings(doctor.rating)
              )
            ],
          ),
        )
      ],
    ),
  );
}

List<Widget> getRatings(int rating) {
  List<Widget> ratings = [];
  for (int i = 0; i < 5; i++) {
    if (i < rating) {
      ratings.add(
        Icon(
          Icons.star,
          color: Colors.yellow
        )
      );
    } else {
      ratings.add(
        Icon(
          Icons.star_border,
          color: Colors.black
        )
      );
    }
  }
  return ratings;
}

Map statusStyles = {
  'Available' : statusAvailableStyle,
  'Unavailable' : statusUnavailableStyle
};