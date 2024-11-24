import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class DrawLocationEvent {}

class InitEvent extends DrawLocationEvent {
  final LatLng value;
  InitEvent(this.value);
}
class CameraMoveStartEvent extends DrawLocationEvent {
  final bool started;
  CameraMoveStartEvent(this.started);
}
class CameraMoveEvent extends DrawLocationEvent {
  final LatLng value;
  CameraMoveEvent(this.value);
}