import 'package:flutter/cupertino.dart';
import 'package:jibox_reels/data/bloc/base/base_state.dart';

abstract class AdDetailState extends BaseState{

}

class UpdateLikeState extends AdDetailState{
  @override
  List<Object?> get props => [UniqueKey()];

}