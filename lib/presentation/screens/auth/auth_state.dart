import 'package:flutter/cupertino.dart';
import 'package:jibox_reels/data/bloc/base/base_state.dart';

abstract class AuthState extends BaseState {}

class NavigateToConfirmState extends AuthState {
  final String phone;

  NavigateToConfirmState(this.phone);

  @override
  List<Object?> get props => [UniqueKey()];
}


class ChangePhoneState extends AuthState {

  ChangePhoneState();

  @override
  List<Object?> get props => [UniqueKey()];
}
