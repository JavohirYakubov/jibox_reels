import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:jibox_reels/data/bloc/base/base_state.dart';
import 'package:jibox_reels/data/repository/auth_repository.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, BaseState> {
  final AuthRepository authRepository;
  final phoneEditingController = TextEditingController();
  final MaskTextInputFormatter maskFormatter = MaskTextInputFormatter(
      mask: "+998 ## ### ## ##", type: MaskAutoCompletionType.eager);

  AuthBloc(this.authRepository) : super(InitialState()) {
    on<InitEvent>((event, emit) {});
    on<ChangePhoneEvent>((event, emit) {
      emit(ChangePhoneState());
    });
    on<SubmitEvent>((event, emit) async {
      await login(event, emit);
    });
  }

  Future<void> login(SubmitEvent event, Emitter<BaseState> emit) async {
    emit(ShowLoadingState(true));
    final phone =
        phoneEditingController.text.replaceAll(" ", "").replaceAll("+", "");
    final response = await authRepository.login(phone);
    emit(ShowLoadingState(false));
    if (response.success) {
      emit(NavigateToConfirmState(
          phoneEditingController.text.replaceAll(" ", "").replaceAll("+", "")));
    } else {
      emit(ShowErrorMessage(response.message));
    }
  }
}
