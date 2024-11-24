import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:jibox_reels/data/model/ad_filter_model.dart';
import 'package:jibox_reels/data/model/ad_model.dart';
import 'package:jibox_reels/data/repository/ad_repository.dart';
import 'package:jibox_reels/data/repository/user_repository.dart';
import 'package:jibox_reels/main.dart';

import '../../../data/bloc/base/base_state.dart';
import '../../../data/repository/auth_repository.dart';
import 'main_event.dart';
import 'main_state.dart';

class MainBloc extends Bloc<MainEvent, BaseState> {
  final AuthRepository authRepository;
  final UserRepository userRepository;
  final AdRepository adRepository;
  List<AdModel>? items;
  late AdFilterModel filter;
  final StreamController<int> centeredItemStreamController =
      StreamController.broadcast();

  Stream<int> get centeredItemStream => centeredItemStreamController.stream;

  MainBloc(this.authRepository, this.adRepository, this.userRepository)
      : super(InitialState()) {
    on<InitEvent>((event, emit) {
      filter = AdFilterModel(
          latitude: MyApp.currentLocation!.latitude,
          longitude: MyApp.currentLocation!.longitude);
      emit(InitialState());
      add(LoadAdListEvent());
    });
    on<LoadAdListEvent>((event, emit) async {
      await loadAdList(emit);
    });
    on<ToggleLikeEvent>((event, emit) async {
      await toggleLike(event, emit);
    });
    on<UpdateItemsEvent>((event, emit) {
      emit(UpdateitemsState());
    });
    on<UpdateItemEvent>((event, emit) {
      emit(UpdateItemState(event.adId));
    });
    on<UpdateMapMarkersEvent>((event, emit) {
      emit(UpdateMapMarkersState());
    });
  }

  Future<void> loadAdList(Emitter<BaseState> emit) async {
    emit(ShowLoadingState(true));
    final response = await adRepository.loadAdList(filter);
    emit(ShowLoadingState(false));
    if (response.success) {
      items = response.data;
      emit(LoadedItems());
    } else {
      emit(ShowErrorMessage(response.message));
    }
  }

  Future<void> toggleLike(
      ToggleLikeEvent event, Emitter<BaseState> emit) async {
    event.ad.hasLike = !(event.ad.hasLike ?? false);
    if (event.ad.hasLike == true) {
      event.ad.likeCount++;
    } else {
      event.ad.likeCount--;
    }
    emit(UpdateItemState(event.ad.id));
    final response = await userRepository.toggleLike(event.ad.id);
  }
}
