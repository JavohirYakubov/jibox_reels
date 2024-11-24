import 'package:bloc/bloc.dart';

import 'add_ad_event.dart';
import 'add_ad_state.dart';

class AddAdBloc extends Bloc<AddAdEvent, AddAdState> {
  AddAdBloc() : super(AddAdState().init()) {
    on<InitEvent>(_init);
  }

  void _init(InitEvent event, Emitter<AddAdState> emit) async {
    emit(state.clone());
  }
}
