import 'package:bloc/bloc.dart';

import 'estates_map_event.dart';
import 'estates_map_state.dart';

class EstatesMapBloc extends Bloc<EstatesMapEvent, EstatesMapState> {
  EstatesMapBloc() : super(EstatesMapState().init()) {
    on<InitEvent>(_init);
  }

  void _init(InitEvent event, Emitter<EstatesMapState> emit) async {
    emit(state.clone());
  }
}
