import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jibox_reels/data/bloc/base/base_state.dart';

import 'draw_location_event.dart';
import 'draw_location_state.dart';

class DrawLocationBloc extends Bloc<DrawLocationEvent, BaseState> {
  LatLng? centerLocation;

  DrawLocationBloc() : super(InitialState()) {
    on<InitEvent>((event, emit) {});
    on<CameraMoveStartEvent>((event, emit) {
      emit(CameraMoveStartedState(event.started));
    });
    on<CameraMoveEvent>((event, emit) {
      centerLocation = event.value;
      emit(UpdateCameraMoveState());
    });
  }
}
