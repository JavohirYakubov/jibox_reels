import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jibox_reels/data/bloc/base/base_state.dart';
import 'package:jibox_reels/presentation/screens/main/filter/select_location/select_location_state.dart';
import 'package:jibox_reels/presentation/ui/common/regular_app_bar.dart';
import 'package:jibox_reels/presentation/ui/common/simple_button.dart';
import 'package:jibox_reels/utils/app_router.dart';
import 'package:jibox_reels/utils/common.dart';

import '../../../../../gen/assets.gen.dart';
import 'select_location_bloc.dart';
import 'select_location_event.dart';

class SelectLocationPage extends StatefulWidget {
  final LatLng selectedLocation;

  SelectLocationPage(this.selectedLocation);

  @override
  State<SelectLocationPage> createState() => _SelectLocationPageState();
}

class _SelectLocationPageState extends State<SelectLocationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _kGooglePlex = CameraPosition(
      target: LatLng(
          widget.selectedLocation.latitude, widget.selectedLocation.longitude),
      zoom: 13,
    );
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          SelectLocationBloc()..add(InitEvent(widget.selectedLocation)),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  late CameraPosition _kGooglePlex;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  Widget _buildPage(BuildContext context) {
    final bloc = BlocProvider.of<SelectLocationBloc>(context);

    return BlocListener<SelectLocationBloc, BaseState>(
      listener: (context, state) {
        if (state is CameraMoveStartedState) {
          _animationController.animateTo(state.value ? 0.5 : 0);
        }
      },
      child: Scaffold(
        appBar: RegularAppBar(
          context,
          "Nuqtani belgilash",
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
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              onCameraMoveStarted: () {
                bloc.add(CameraMoveStartEvent(true));
              },
              onCameraIdle: () {
                bloc.add(CameraMoveStartEvent(false));
              },
              onCameraMove: (p) {
                bloc.add(CameraMoveEvent(p.target));
              },
            ),
            Center(
              child: IgnorePointer(
                ignoring: true,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 180),
                  child: Assets.lotties.marker.lottie(
                      width: 200,
                      controller: _animationController,
                      repeat: false),
                ),
              ),
            ),
            Positioned(
              left: 16.w,
              right: 16.w,
              bottom: safePadding(context).bottom + 16.h,
              child: BlocBuilder<SelectLocationBloc, BaseState>(
                builder: (context, state) {
                  return SimpleButton(
                    "Saqlash",
                    () {
                      AppRouter.pop(bloc.centerLocation!);
                    },
                    active: bloc.centerLocation != null,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
