import 'package:flutter/cupertino.dart';
import 'package:jibox_reels/data/bloc/base/base_state.dart';

abstract class AuthConfirmState extends BaseState {}

class ChangePinState extends AuthConfirmState {
  @override
  List<Object?> get props => [UniqueKey()];
}

class NavigateToMainState extends AuthConfirmState {
  @override
  List<Object?> get props => [UniqueKey()];
}
