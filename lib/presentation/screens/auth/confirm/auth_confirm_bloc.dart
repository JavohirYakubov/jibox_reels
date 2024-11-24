import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:jibox_reels/data/bloc/base/base_state.dart';
import 'package:jibox_reels/utils/pref_utils.dart';

import '../../../../data/repository/auth_repository.dart';
import 'auth_confirm_event.dart';
import 'auth_confirm_state.dart';

class AuthConfirmBloc extends Bloc<AuthConfirmEvent, BaseState> {
  final otpTextEditingController = TextEditingController();
  final AuthRepository authRepository;
  final PrefUtils prefUtils;

  AuthConfirmBloc(this.authRepository, this.prefUtils) : super(InitialState()) {
    on<InitEvent>((event, emit) {});
    on<ChangePinEvent>((event, emit) {
      emit(ChangePinState());
    });
    on<SubmitEvent>((event, emit) async {
      await confirm(event, emit);
    });
  }

  Future<void> confirm(SubmitEvent event, Emitter<BaseState> emit) async {
    emit(ShowLoadingState(true));
    final response = await authRepository.loginConfirm(
        event.phone, otpTextEditingController.text);
    emit(ShowLoadingState(false));
    if (response.success) {
      prefUtils.setToken(response.data);
      emit(NavigateToMainState());
    } else {
      emit(ShowErrorMessage(response.message));
    }
  }
}
