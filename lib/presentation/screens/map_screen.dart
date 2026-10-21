import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../widgets/member_marker.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  static const members = [
    MemberMarker('Maya', 'Cairo', LatLng(30.0444, 31.2357)),
    MemberMarker('Omar', 'Alexandria', LatLng(31.2001, 29.9187)),
    MemberMarker('Salma', 'Giza', LatLng(30.0131, 31.2089)),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Community Map')),
    body: GoogleMap(
      initialCameraPosition: const CameraPosition(
        target: LatLng(30.3, 30.7),
        zoom: 6.5,
      ),
      markers: members.map((member) => member.toMarker()).toSet(),
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
    ),
  );
}
