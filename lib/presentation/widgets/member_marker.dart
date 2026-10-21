import 'package:google_maps_flutter/google_maps_flutter.dart';

class MemberMarker {
  const MemberMarker(this.name, this.city, this.position);
  final String name;
  final String city;
  final LatLng position;

  Marker toMarker() => Marker(
    markerId: MarkerId(name),
    position: position,
    infoWindow: InfoWindow(title: name, snippet: city),
  );
}
