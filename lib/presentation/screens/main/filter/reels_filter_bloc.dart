import 'package:bloc/bloc.dart';
import 'package:jibox_reels/data/bloc/base/base_state.dart';
import 'package:jibox_reels/data/model/ad_filter_model.dart';
import 'package:jibox_reels/main.dart';

import 'reels_filter_event.dart';
import 'reels_filter_state.dart';

class ReelsFilterBloc extends Bloc<ReelsFilterEvent, BaseState> {
  AdFilterModel filter = AdFilterModel(latitude: 0, longitude: 0);

  ReelsFilterBloc() : super(InitialState()) {
    on<InitEvent>((event, emit) {
      filter = event.filterModel.copyWith();
      emit(InitialState());
    });
    on<ClearFilterEvent>((event, emit) {
      filter = AdFilterModel(
          latitude: MyApp.currentLocation!.latitude,
          longitude: MyApp.currentLocation!.longitude);
      emit(InitialState());
    });
    on<UpdateAdTypeEvent>((event, emit) {
      filter.adType = event.value;
      emit(UpdateAdTypeState());
    });
    on<UpdateCurrencyEvent>((event, emit) {
      emit(UpdateCurrencyState());
    });
    on<UpdateIsNewEvent>((event, emit) {
      emit(UpdateIsNewState());
    });
    on<UpdateRangeEvent>((event, emit) {
      filter.fromRadius = event.values.start;
      filter.toRadius = event.values.end;
      emit(UpdateRangeState());
    });
  }
}
