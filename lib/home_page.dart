import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GoogleMapController mapController;
  LocationData? currentLocation;
  Location location = Location();

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    // ตรวจสอบว่า Location services เปิดอยู่หรือไม่
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    // ตรวจสอบว่าอนุญาตให้เข้าถึง Location หรือไม่
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // อัปเดตตำแหน่งปัจจุบัน
    currentLocation = await location.getLocation();

    // อัปเดตตำแหน่งในแผนที่
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fitness Tracker"),
      ),
      body: currentLocation == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
        onMapCreated: (controller) {
          mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
          zoom: 15,
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              // โค้ดสำหรับเริ่มการติดตาม
            },
            child: Icon(Icons.play_arrow),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              // โค้ดสำหรับหยุดการติดตาม
            },
            child: Icon(Icons.stop),
          ),
        ],
      ),
    );
  }
}
