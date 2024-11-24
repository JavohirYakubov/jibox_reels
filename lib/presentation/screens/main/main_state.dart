import 'package:flutter/cupertino.dart';
import 'package:jibox_reels/data/bloc/base/base_state.dart';

abstract class MainState extends BaseState{

}

class UpdateitemsState extends MainState{
  @override
  List<Object?> get props => [UniqueKey()];

}

class UpdateMapMarkersState extends MainState{
  @override
  List<Object?> get props => [UniqueKey()];

}
class UpdateItemState extends MainState{
  final int adId;
  UpdateItemState(this.adId);
  @override
  List<Object?> get props => [UniqueKey()];

}