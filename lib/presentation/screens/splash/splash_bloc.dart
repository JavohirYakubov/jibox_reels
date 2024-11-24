import 'package:bloc/bloc.dart';
import 'package:jibox_reels/data/bloc/base/base_state.dart';
import 'package:jibox_reels/data/repository/auth_repository.dart';

import 'splash_event.dart';

class SplashBloc extends Bloc<SplashEvent, BaseState> {
  final AuthRepository authRepository;
  SplashBloc(this.authRepository) : super(InitialState()) {
    on<InitEvent>((event, emit) {
      emit(InitialState());
    });
  }
}
