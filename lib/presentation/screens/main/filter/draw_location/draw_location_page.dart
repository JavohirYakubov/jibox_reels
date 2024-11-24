import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jibox_reels/presentation/ui/common/regular_app_bar.dart';
import 'package:jibox_reels/presentation/ui/common/simple_button.dart';
import 'package:jibox_reels/utils/app_router.dart';
import 'package:jibox_reels/utils/common.dart';

class DrawLocationPage extends StatefulWidget {
  final LatLng selectedLocation;

  DrawLocationPage(this.selectedLocation);

  @override
  State<DrawLocationPage> createState() => _DrawLocationPageState();
}

class _DrawLocationPageState extends State<DrawLocationPage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  late CameraPosition _initialCameraPosition;

  final List<LatLng> _polygonVertices = [];
  final Set<Polygon> _polygons = {};

  @override
  void initState() {
    super.initState();
    _initialCameraPosition = CameraPosition(
      target: LatLng(
        widget.selectedLocation.latitude,
        widget.selectedLocation.longitude,
      ),
      zoom: 13,
    );
  }

  void _addPolygonVertex(LatLng point) {
    setState(() {
      _polygonVertices.add(point);
      _updatePolygon();
    });
  }

  void _updatePolygon() {
    if (_polygonVertices.length > 2) {
      final polygon = Polygon(
        polygonId: PolygonId('polygon_1'),
        points: _polygonVertices,
        strokeWidth: 2,
        strokeColor: Colors.blue,
        fillColor: Colors.blue.withOpacity(0.2),
      );

      _polygons.clear();
      _polygons.add(polygon);
    }
  }

  void _completePolygon() {
    if (_polygonVertices.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Kamida 3 ta chegara chizing')),
      );
      return;
    }
    AppRouter.pop(_polygonVertices);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RegularAppBar(
        context,
        "Qidiruv chegaralarini chizing",
        canBack: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer(),
              ),
            },
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            onTap: _addPolygonVertex,
            // Add point to the polygon on map tap
            polygons: _polygons,
          ),
          Positioned(
            left: 16.w,
            right: 16.w,
            bottom: safePadding(context).bottom + 16.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SimpleButton(
                  "Saqlash",
                  _completePolygon,
                  active: _polygonVertices.length >= 3,
                ),
                if (_polygonVertices.isNotEmpty)
                  SimpleButton(
                    "Tozalash",
                    () {
                      setState(() {
                        _polygonVertices.clear();
                        _polygons.clear();
                      });
                    },
                    active: true,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
