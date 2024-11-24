import 'package:flutter/cupertino.dart';
import 'package:jibox_reels/data/bloc/base/base_state.dart';

abstract class SelectLocationState extends BaseState{

}

class UpdateCameraMoveState extends SelectLocationState{
  @override
  List<Object?> get props => [UniqueKey()];

}

class CameraMoveStartedState extends SelectLocationState{
  final bool value;
  CameraMoveStartedState(this.value);
  @override
  List<Object?> get props => [UniqueKey()];

}