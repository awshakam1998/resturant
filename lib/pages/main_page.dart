import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:resturant/constants/values.dart';
import 'package:resturant/pages/menu_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(31.988033, 35.863491),
    zoom: 15,
  );
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> markers = {};

  @override
  void initState() {
    setPermissions();
    super.initState();
  }

  void setPermissions() async {
    if (await Permission.contacts.request().isGranted) {}
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
    ].request();
    print(statuses[Permission.location]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: deviceHeight(context) * .05,
            ),
            Center(
                child: Image.asset(
              'images/logo.png',
              width: MediaQuery.of(context).size.width / 3,
            )),
            SizedBox(
              height: deviceHeight(context) * .05,
            ),
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: mainColor)),
                margin: EdgeInsets.all(16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: deviceHeight(context) * .1,
                    child: GoogleMap(
                      zoomControlsEnabled: false,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      markers: markers,
                      initialCameraPosition: _kGooglePlex,
                      onMapCreated: (GoogleMapController controller) async {
                        _controller.complete(controller);
                        controller.animateCamera(CameraUpdate.newLatLng(
                          LatLng(31.988033, 35.863491),
                        ));
                        BitmapDescriptor customIcon;
                        BitmapDescriptor.fromAssetImage(
                                ImageConfiguration(size: Size(12, 12)),
                                'images/marker.png')
                            .then((d) {
                          customIcon = d;
                          markers.add(Marker(
                              markerId: MarkerId('marker'),
                              position: LatLng(31.988033, 35.863491),
                              icon: customIcon));
                          setState(() {});
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: deviceHeight(context) * .03,
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MenuPage(),
                          ));
                    },
                    child: Card(
                      color: mainColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      margin: EdgeInsets.all(16),
                      child: Container(
                        height: deviceHeight(context) * .2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'images/menu.png',
                              width: MediaQuery.of(context).size.width / 7,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Center(
                              child: Text(
                                'Menu',
                                style: titleStyle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    color: mainColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: EdgeInsets.all(16),
                    child: Container(
                      height: deviceHeight(context) * .2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'images/booking.png',
                            width: MediaQuery.of(context).size.width / 7,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Center(
                            child: Text(
                              'Booking',
                              style: titleStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: deviceHeight(context) * .05,
            ),
          ],
        ),
      ),
    );
  }
}
