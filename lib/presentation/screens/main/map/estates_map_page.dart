import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jibox_reels/data/model/ad_filter_model.dart';
import 'package:jibox_reels/gen/colors.gen.dart';
import 'package:jibox_reels/presentation/screens/main/filter/reels_filter_page.dart';
import 'package:jibox_reels/presentation/ui/common/regular_app_bar.dart';
import 'package:jibox_reels/utils/app_router.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../main.dart';
import 'estates_map_bloc.dart';
import 'estates_map_event.dart';

class EstatesMapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => EstatesMapBloc()..add(InitEvent()),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final bloc = BlocProvider.of<EstatesMapBloc>(context);

    final CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(
          MyApp.currentLocation!.latitude, MyApp.currentLocation!.longitude),
      zoom: 12,
    );
    List<Marker> _markers = [];

    // Base location (41.326468, 69.222402)
    final LatLng baseLocation = LatLng(41.326468, 69.222402);

    // Random number generator for nearby locations
    final Random random = Random();

    Set<Marker> _generateCircles() {
      Set<Marker> circles = {};

      for (int i = 0; i < 500; i++) {
        // Generate small random offsets for latitude and longitude
        double offsetLat =
            (random.nextDouble() - 0.5) / 5; // Small variation in latitude
        double offsetLng =
            (random.nextDouble() - 0.5) / 5; // Small variation in longitude

        // Create a new location near the base location
        LatLng newLocation = LatLng(
          baseLocation.latitude + offsetLat,
          baseLocation.longitude + offsetLng,
        );

        // Add a new marker with the generated location
        circles.add(
          Marker(
            markerId: MarkerId("marker_$i"),
            position: newLocation,
            icon: circleMarkerIcon, // Custom color
            infoWindow: InfoWindow(
              title: 'Marker $i',
              snippet: 'Nearby Location',
            ),
          ),
        );
      }

      return circles;
    }

    final Completer<GoogleMapController> _controller =
        Completer<GoogleMapController>();

    return Scaffold(
      appBar: RegularAppBar(
        context,
        "E'lonlar haritasi",
        actions: [
          GestureDetector(
            onTap: (){
              AppRouter.push(ReelsFilterPage(AdFilterModel(latitude: 0, longitude: 0)));
            },
            child: Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: Assets.icons.filter.svg(
                  width: 24.w,
                  height: 24.w,
                  colorFilter: ColorFilter.mode(
                      ColorName.mainPrimary500Base, BlendMode.srcIn)),
            ),
          ),
        ],
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
          Factory<OneSequenceGestureRecognizer>(
            () => EagerGestureRecognizer(),
          ),
        },
        markers: _generateCircles(),
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        onCameraMoveStarted: () {},
        onCameraIdle: () {},
        onCameraMove: (p) {},
      ),
    );
  }
}
