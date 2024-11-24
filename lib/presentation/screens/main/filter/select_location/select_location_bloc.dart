import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jibox_reels/data/bloc/base/base_state.dart';

import 'select_location_event.dart';
import 'select_location_state.dart';

class SelectLocationBloc extends Bloc<SelectLocationEvent, BaseState> {
  LatLng? centerLocation;

  SelectLocationBloc() : super(InitialState()) {
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
