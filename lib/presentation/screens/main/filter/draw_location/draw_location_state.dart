import 'package:flutter/cupertino.dart';
import 'package:jibox_reels/data/bloc/base/base_state.dart';

abstract class DrawLocationState extends BaseState{

}

class UpdateCameraMoveState extends DrawLocationState{
  @override
  List<Object?> get props => [UniqueKey()];

}

class CameraMoveStartedState extends DrawLocationState{
  final bool value;
  CameraMoveStartedState(this.value);
  @override
  List<Object?> get props => [UniqueKey()];

}