import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class SelectLocationEvent {}

class InitEvent extends SelectLocationEvent {
  final LatLng value;
  InitEvent(this.value);
}
class CameraMoveStartEvent extends SelectLocationEvent {
  final bool started;
  CameraMoveStartEvent(this.started);
}
class CameraMoveEvent extends SelectLocationEvent {
  final LatLng value;
  CameraMoveEvent(this.value);
}