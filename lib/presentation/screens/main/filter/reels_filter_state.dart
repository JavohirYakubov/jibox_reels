import 'package:flutter/cupertino.dart';
import 'package:jibox_reels/data/bloc/base/base_state.dart';

abstract class ReelsFilterState extends BaseState{

}

class UpdateRangeState extends ReelsFilterState{
  @override
  List<Object?> get props => [UniqueKey()];

}

class UpdateAdTypeState extends ReelsFilterState{
  @override
  List<Object?> get props => [UniqueKey()];

}

class UpdateCurrencyState extends ReelsFilterState{
  @override
  List<Object?> get props => [UniqueKey()];

}

class UpdateIsNewState extends ReelsFilterState{
  @override
  List<Object?> get props => [UniqueKey()];

}