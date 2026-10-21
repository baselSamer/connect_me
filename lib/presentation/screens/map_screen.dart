import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../theme/app_theme.dart';
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
    appBar: AppBar(title: const Text('People nearby')),
    body: Stack(
      children: [
        GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: LatLng(30.3, 30.7),
            zoom: 6.5,
          ),
          markers: members.map((member) => member.toMarker()).toSet(),
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
        ),
        Positioned(
          left: 20,
          right: 20,
          bottom: 24,
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x24202137),
                  blurRadius: 20,
                  offset: Offset(0, 7),
                ),
              ],
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppPalette.violet,
                  child: Icon(
                    Icons.people_outline_rounded,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Explore the community',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: AppPalette.ink,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Tap a marker to meet a member.',
                        style: TextStyle(color: AppPalette.muted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
